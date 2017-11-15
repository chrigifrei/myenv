
#!/bin/bash
# tested on a Ubuntu 16.04.3 LTS (Xenial Xerus)

sudo apt update
sudo apt install -y vim slapd ldap-utils
#sudo dpkg-reconfigure slapd

# generate LDAP_BIND_PW
# export LDAP_BIND_PW=<LDAP BIND PASSWORD>
echo $LDAP_BIND_PW >ldap_bind_pw.txt
chmod 600 ldap_bind_pw.txt
export LDAP_BIND_PW=$(slappasswd -T ldap_bind_pw.txt)

cat <<EOF >modules.ldif
dn: cn=module{0},cn=config
changetype: modify
add: olcModuleLoad
olcModuleLoad: back_ldap

dn: cn=module{0},cn=config
changetype: modify
add: olcModuleLoad
olcModuleLoad: pcache
EOF

cat <<EOF >chainoverlay.ldif
dn: olcOverlay=chain,olcDatabase={-1}frontend,cn=config
objectClass: olcOverlayConfig
objectClass: olcChainConfig
olcOverlay: chain
olcChainCacheURI: FALSE
olcChainMaxReferralDepth: 1
olcChainReturnError: TRUE
EOF

cat <<EOF >defaultldap.ldif
dn: olcDatabase=ldap,olcOverlay={0}chain,olcDatabase={-1}frontend,cn=config
objectClass: olcLDAPConfig
objectClass: olcChainDatabase
olcDatabase: ldap
EOF

cat <<EOF >chainedserver.ldif
dn: olcDatabase=ldap,olcOverlay={0}chain,olcDatabase={-1}frontend,cn=config
objectClass: olcLDAPConfig
objectClass: olcDatabaseConfig
objectClass: olcConfig
objectClass: top
objectClass: olcChainDatabase
olcDatabase: ldap
olcDbURI: ldap://<LDAP-SERVER:PORT>
EOF

cat <<EOF >proxy.ldif
dn: olcDatabase={2}ldap,cn=config
objectClass: olcDatabaseConfig
objectClass: olcLDAPConfig
olcDatabase: {2}ldap
olcDbURI: ldap://<LDAP-SERVER:PORT>
olcSuffix: <BASE-DN>
olcRootDN: <BIND-DN>
EOF
echo "olcRootPW: $LDAP_BIND_PW" >>proxy.ldif
cat <<EOF >>proxy.ldif

dn: olcOverlay={0}pcache,olcDatabase={2}ldap,cn=config
objectClass: olcOverlayConfig
objectClass: olcPcacheConfig
olcOverlay: {0}pcache
olcPcache: hdb 100000 1 1000 100
olcPcacheAttrset: 0 uid
olcPcacheAttrset: 1 cn
olcPcacheAttrset: 2 uniqueMember
olcPcacheTemplate: "(uid=)" 0 3600 0 0 0
olcPcacheTemplate: "(&(uid=)(uniqueMember=))" 0 3600 0 0 0
olcPcacheTemplate: "(&(|(objectClass=)))" 0 3600 0 0 0
olcPcacheTemplate: "(objectClass=*)" 0 3600 0 0 0
olcPcacheTemplate: "(objectClass=*)" 1 3600 0 0 0
olcPcacheTemplate: "(objectClass=*)" 2 3600 0 0 0

dn: olcDatabase={0}mdb,olcOverlay={0}pcache,olcDatabase={2}ldap,cn=config
objectClass: olcMdbConfig
objectClass: olcPcacheDatabase
olcDatabase: {0}mdb
olcDbDirectory: /var/lib/ldap/db.2.a
olcDbCacheSize: 20
olcDbIndex: objectClass eq
olcDbIndex: cn,sn,uid,mail  pres,eq,sub
EOF

#sudo ldapsearch -Q -LLL -Y EXTERNAL -H ldapi:/// -b cn=config dn

## https://serverfault.com/questions/518407/openldap-2-4-chain-overlay-minimal-ldif-configuration

sudo ldapadd -Y EXTERNAL -H ldapi:/// -f modules.ldif
sudo ldapadd -Y EXTERNAL -H ldapi:/// -f chainoverlay.ldif
sudo systemctl stop slapd
sudo slapadd -b cn=config -l defaultldap.ldif
sudo rm "/etc/ldap/slapd.d/cn=config/olcDatabase={-1}over.ldif"
sudo chown -R openldap:openldap "/etc/ldap/slapd.d/cn=config"
sudo systemctl start slapd

#sudo ldapadd -Y EXTERNAL -H ldapi:/// -f chainedserver.ldif 

sudo ldapadd -Y EXTERNAL -H ldapi:/// -f proxy.ldif 

## fails with
## Nov 07 16:29:40 ubuntu-xenial kernel: slapd[4788]: segfault at 14 ip 00007fdaeb51c91c sp 00007fdaaab0fdb0 error 4 in pcache-2.4.so.2.10.5[7fdaeb515000+12000]


## ldapsearch -x -LLL -h <LDAP-SERVER:PORT> -D <BIND-DN> -b <BASE-DN> -W
## docker run --volume $(pwd)/ldif:/container/service/slapd/assets/config/bootstrap/ldif -e LDAP_BACKEND=ldap osixia/openldap:1.1.9 --copy-service --loglevel debug

rm -f ldap_bind_pw.txt
unset LDAP_BIND_PW
exit 0
