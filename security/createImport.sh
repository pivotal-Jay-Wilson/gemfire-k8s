LNPASSWORD=$(kubectl get secret client-cert-ln -n uk -o=jsonpath='{.data.password}' | base64 --decode)
LNkeyStoreFileBase64String=$(kubectl get secret client-cert-ln -n uk -o=jsonpath='{.data.keystore\.p12}')
LNtrustStoreFileBase64String=$(kubectl get secret client-cert-ln -n uk -o=jsonpath='{.data.truststore\.p12}')

NYPASSWORD=$(kubectl get secret client-cert-ny -n us -o=jsonpath='{.data.password}' | base64 --decode)
NYkeyStoreFileBase64String=$(kubectl get secret client-cert-ny -n us -o=jsonpath='{.data.keystore\.p12}')
NYtrustStoreFileBase64String=$(kubectl get secret client-cert-ny -n us -o=jsonpath='{.data.truststore\.p12}')
cat >./import.json <<EOF
[
  {
    "connectionNumber": 1,
    "clusterNickname": "ny",
    "clusterHost": "ny-locator.us.svc.cluster.local",
    "clusterPort": 7070,
    "clusterSecurityType": "None",
    "keyStoreFileBase64String": "$NYkeyStoreFileBase64String",
    "keyStoreFileName": "keystor.p12",
    "keyStoreFilePassword": "$NYPASSWORD",
    "trustStoreFileBase64String": "$NYtrustStoreFileBase64String",
    "trustStoreFileName": "truststore.p12",
    "trustStoreFilePassword": "$NYPASSWORD"
  },
  {
    "connectionNumber": 2,
    "clusterNickname": "ln",
    "clusterHost": "ln-locator.uk.svc.cluster.local",
    "clusterPort": 7070,
    "clusterSecurityType": "None",
    "keyStoreFileBase64String": "$LNkeyStoreFileBase64String",
    "keyStoreFileName": "keystor.p12",
    "keyStoreFilePassword": "$LNPASSWORD",
    "trustStoreFileBase64String": "$LNtrustStoreFileBase64String",
    "trustStoreFileName": "truktstore.p12",
    "trustStoreFilePassword": "$LNPASSWORD"
  }
]
EOF