
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
olcModuleLoad: back_mdb

dn: cn=module{0},cn=config
changetype: modify
add: olcModuleLoad
olcModuleLoad: syncprov
EOF

cat <<EOF >replica.ldif
dn: cn=config
changetype: modify
replace: olcLogLevel
olcLogLevel: stats

dn: olcDatabase=mdb,cn=config 
objectClass: olcDatabaseConfig 
objectClass: olcMdbConfig 
olcDatabase: mdb
olcSuffix: <BASE-DN>
olcRootDN: <BIND-DN>
olcRootPW: secret 
olcDbDirectory: /var/lib/ldap 
olcDbIndex: objectClass eq

dn: olcDatabase={1}mdb,cn=config
changetype: modify
add: olcDbIndex
olcDbIndex: entryUUID eq
-
add: olcSyncRepl
olcSyncRepl:
  rid=0
  provider=ldap://<LDAP-SERVER:PORT>
  searchbase="<BASE-DN>"
  logbase="cn=accesslog"
  logfilter="(&(objectClass=auditWriteObject)(reqResult=0))"
  schemachecking=on
  type=refreshAndPersist
  retry="60 +"
  syncdata=accesslog
  bindmethod=simple
  binddn="<BIND-DN>"
EOF
echo "  credentials=$LDAP_BIND_PW" >>replica.ldif
cat <<EOF >>replica.ldif
-
add: olcUpdateRef
olcUpdateRef: ldap://<LDAP-SERVER:PORT>
EOF

#sudo ldapsearch -Q -LLL -Y EXTERNAL -H ldapi:/// -b cn=config dn

## https://serverfault.com/questions/518407/openldap-2-4-chain-overlay-minimal-ldif-configuration

sudo ldapadd -Y EXTERNAL -H ldapi:/// -f modules.ldif
sudo ldapadd -Y EXTERNAL -H ldapi:/// -f replica.ldif
# sudo systemctl stop slapd
# sudo slapadd -b cn=config -l defaultldap.ldif
# sudo rm "/etc/ldap/slapd.d/cn=config/olcDatabase={-1}over.ldif"
# sudo chown -R openldap:openldap "/etc/ldap/slapd.d/cn=config"
# sudo systemctl start slapd


## ldapsearch -x -LLL -h <LDAP-SERVER:PORT> -D <BIND-DN> -b <BASE-DN> -W
## docker run --volume $(pwd)/ldif:/container/service/slapd/assets/config/bootstrap/ldif -e LDAP_BACKEND=ldap osixia/openldap:1.1.9 --copy-service --loglevel debug

rm -f ldap_bind_pw.txt
unset LDAP_BIND_PW
exit 0
