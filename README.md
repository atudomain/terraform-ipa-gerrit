# FreeIpa with Gerrit in Terraform

## Set up

Run:

```
terraform init
```

```
terraform apply
```

Set passwords as variables when asked.


## Wait for FreeIpa

Wait until FreeIpa finishes the setup:

```
docker logs -f ipa
```

Wait until 'FreeIPA server configured.' line appears.


## Set up hostname resolution

Services are available locally after setting dns entries with ips from terraform output:

```
terraform output
```

Use obtained gerrit_ip to set 'gerrit.ci.local' entry in /etc/hosts.
Use obtained ipa_ip to set 'ipa.ci.local' entry in /etc/hosts.

## Access Gerrit


Use admin login to sign in:
```
http://gerrit.ci.local
```

## Access FreeIpa

Use admin login to sign in:
```
https://ipa.ci.local
```
