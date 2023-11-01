# Specify the friendly name for the certificate
$friendlyName = "FriendlyNameHere"

# Specify the certificate store type (Web Hosting store)
$certStoreType = "WebHosting"

# Create a new self-signed certificate and add it to the specified store
New-SelfSignedCertificate -DnsName "localhost" -CertStoreLocation $certStoreType -FriendlyName $friendlyName -NotAfter (Get-Date).AddYears(10) -KeyExportPolicy Exportable -KeyUsage KeyEncipherment,DigitalSignature -KeyAlgorithm RSA -KeyLength 2048 -HashAlgorithm SHA256