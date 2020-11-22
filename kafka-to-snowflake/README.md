Complete the following steps to generate a key pair. Install openssl for windows from https://wiki.openssl.org/index.php/Binaries

- Generate a private key using OpenSSL.
`openssl genrsa -out snowflake_key.pem 2048`

- Generate the public key referencing the private key.
`openssl rsa -in snowflake_key.pem  -pubout -out snowflake_key.pub`

- Get the required part of public key using
`grep -v "BEGIN PUBLIC" snowflake_key.pub | grep -v "END PUBLIC"|tr -d '\r\n'`

- Get the required part of private key using
`grep -v "BEGIN RSA PRIVATE KEY" snowflake_key.pem | grep -v "END RSA PRIVATE KEY"|tr -d '\r\n'`
