#!/bin/bash -e

if [ ! -d /var/gerrit/git/All-Projects.git ]
then
  if [ -f /gerrit.config ]; then
    echo "Initializing Gerrit config ..."
    cp -f /gerrit.config /var/gerrit/etc/gerrit.config
    sed -i "s/<gerrit_canonicalWebUrl>/$GERRIT_CANONICAL_WEB_URL/" /var/gerrit/etc/gerrit.config
    sed -i "s/<ldap_server>/$LDAP_SERVER/" /var/gerrit/etc/gerrit.config
    sed -i "s/<ldap_username>/$LDAP_USERNAME/" /var/gerrit/etc/gerrit.config
    sed -i "s/<ldap_accountBase>/$LDAP_ACCOUNTBASE/" /var/gerrit/etc/gerrit.config
  fi
  if [ -f /secure.config ]; then
    echo "Initializing Gerrit secure config ..."
    cp -f /secure.config /var/gerrit/etc/secure.config
    sed -i "s/<ldap_password>/$LDAP_PASSWORD/" /var/gerrit/etc/secure.config
  fi
fi

/entrypoint.sh $@
