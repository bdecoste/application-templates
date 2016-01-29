#Application Templates
This project contains OpenShift v3 application templates which support
Red Hat SSO/Keycloak

##Structure
Several templates are provided:
 * ssoeap-image-stream.json: ImageStream for SSO/Keycloak-enabled EAP
 * ssoeap64-basic-s2i.json: SSO/Keycloak-enabled EAP template

Templates are configured with the following basic parameters in addition to the standard EAP parameters:
 * SSO_URI: URI of the SSO/Keycloak server
 * SSO_REALM: SSO/Keycloak realm for the deployed application(s)
 * SSO_PUBLIC_KEY: Public key of the SSO/Keycloak Realm. This field is optional but if omitted can leave the applications vulnerable to man-in-middle attacks
 * SSO_USERNAME: SSO/Keycloak User required to access the SSO/Keycloak REST API
 * SSO_PASSWORD: Password for SSO_USERNAME
 * SSO_SAML_KEYSTORE_SECRET: Secret to use for access to SAML keystore (defaults to sso-app-secret)
 * SSO_SAML_KEYSTORE: Keystore location for SAML (defaults to /etc/sso-saml-secret-volume/keystore.jks)
 * SSO_SAML_KEYSTORE_PASSWORD=Keystore password for SAML (defaults to mykeystorepass)
 * SSO_SAML_CERTIFICATE_NAME=Alias for keys/certificate to use for SAML (default to jboss)


##Example
Once the SSO/Keycloak server has been instantiated (see sso/README) and configured with the appropriate Realm, Role(s), and User(s) ...
```
$ oc create -n myproject -f secrets/sso-secret.json
$ oc create -n myproject -f ssoeap/ssoeap-image-stream.json
$ oc import-image jboss-ssoeap-openshift
$ oc process -f ssoeap/ssoeap64-basic-s2i.json -v APPLICATION_NAME=helloworld,SOURCE_REPOSITORY_URL=https://github.com/keycloak/keycloak-examples,SOURCE_REPOSITORY_REF=master,CONTEXT_DIR=,SSO_URI=https://secure-sso-demo.hostname/auth,SSO_REALM=demo,SSO_USERNAME=demouser,SSO_PASSWORD=demopass | oc create -f -
```

After executing the above, you should be able to access the SSO/Keycloak-enabled applications at http://helloworld-myproject.hostname/app-context and https://secure-helloworld-myproject.hostname/app-context

