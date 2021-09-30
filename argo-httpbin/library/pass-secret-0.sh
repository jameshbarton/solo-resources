# Generate the bcrypt hash with cost of 10
pass=$(htpasswd -bnBC 10 "" mysecurepassword | tr -d ':\n')

# Store the hash as a Kubernetes Secret
kubectl create secret generic dev1-password \
  -n gloo-portal --type=opaque \
  --from-literal=password=$pass