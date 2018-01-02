#!/bin/bash
# create certificates for local testing/development in conjunction with haproxy

export SUBJECT='/C=CH/ST=ZH/L=Zurich'

# FEHOSTNAME: FrontEnd Hostname - could be anything
export FEHOSTNAME='localhost'

# BEHOSTNAME: BackEnd Hostname Prefix (will be extended with the linenumber _1.._4)
export BEHOSTNAME='backend'
# BECOUNT: Number of backend hosts
export BECOUNT=4

# DOMAIN: docker defined network. Get it using:
#   docker inspect $(docker ps --filter "name=haproxy" --format "{{.ID}}") | jq -r .[0].HostConfig.NetworkMode
export DOMAIN='lb_sdn'


# certificate authority creation
openssl genrsa -out ca.key 4096
openssl req -new -x509 -days 365 -key ca.key -out ca.crt -subj "$SUBJECT"

# server certificate creation
server=${FEHOSTNAME}
openssl genrsa -out ${server}.key 1024
openssl req -new -key ${server}.key -out ${server}.csr -subj "${SUBJECT}/CN=${server}"
openssl x509 -req -days 365 -in ${server}.csr -CA ca.crt -CAkey ca.key -set_serial 01 -out ${server}.crt
cat ${server}.crt ${server}.key > ${server}.pem

# client certificate creation
for (( i=1; i<=${BECOUNT}; i++ )); do
    client=${BEHOSTNAME}_${i}
    openssl genrsa -out ${client}.key 1024
    openssl req -new -key ${client}.key -out ${client}.csr -subj "$SUBJECT/CN=${client}.${DOMAIN}"
    openssl x509 -req -days 365 -in ${client}.csr -CA ca.crt -CAkey ca.key -set_serial 01 -out ${client}.crt
    cat ${client}.crt ${client}.key > ${client}.pem
done

rm -f *.csr
exit 0
