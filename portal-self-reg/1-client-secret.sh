export CLIENT_SECRET=your-oidc-client-secret-here
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: petstore-portaloidc-secret
  namespace: default
data:
  client_secret: "$(echo $CLIENT_SECRET | base64)"
EOF
