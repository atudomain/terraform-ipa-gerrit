#!/bin/bash -e

if [ ! -d /var/gerrit/git/All-Projects.git ]
then
  if [ -f /gerrit.config ]; then
    echo "Initializing Gerrit config ..."
    envsubst '${GERRIT_CANONICAL_WEB_URL} ${LDAP_SERVER} ${LDAP_USERNAME} ${LDAP_ACCOUNTBASE}' < /gerrit.config > /var/gerrit/etc/gerrit.config
  fi
  if [ -f /secure.config ]; then
    echo "Initializing Gerrit secure config ..."
    envsubst '${LDAP_PASSWORD}' < /secure.config > /var/gerrit/etc/secure.config
  fi
fi

/entrypoint.sh $@
