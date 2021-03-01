#1 Remove all pem files present before
echo "Deleting all pem files present before."
rm *.pem

#2 Generate CA's private key and self-signed certificate
echo "Generating CA's private key and self signed certificate"
#use -nodes flag to avoid encryption so no pass pharse required
openssl req -x509 -newkey rsa:4096 -days 365 -keyout ca-key.pem -out ca-cert.pem -subj "/C=FR/ST=caparis/L=caparis/O=caparis/OU=caparis/CN=*.caparis.com/emailAddress=ca.paris@gmail.com"

#To see the generated Certificate
openssl x509 -in ca-cert.pem -text -noout

#3 Generate web server's private key and it's Certificate Signing Request (CSR)
echo "Generating web server's private key and it's CSR"
#use -nodes flag to avoid encryption so no pass pharse required
openssl req -newkey rsa:4096 -nodes -keyout server-key.pem -out server-req.pem -subj "/C=US/ST=clientnewyork/L=clientnewyork/O=clientnewyork/OU=clientnewyork/CN=*.clientnewyork.com/emailAddress=client.newyork@gmail.com"

#4 Use CA's private key and its ceriticate to sign the web server's CSR and
# get the signed certificate
openssl x509 -req -in server-req.pem -CA ca-cert.pem -CAkey ca-key.pem -CAcreateserial -out server-cert.pem -extfile server-ext.conf

#To see the generated WebServer Certificate
openssl x509 -in server-cert.pem -text -noout

#To validate the generated cerificate
openssl verify -CAfile ca-cert.pem server-cert.pem