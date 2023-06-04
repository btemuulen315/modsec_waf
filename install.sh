#sed -i 's/\r//'
echo "---------------------------------------------Installing packages---------------------------------------------"
apt-get update
apt-get install -y libapache2-mod-security2
apt-get install -y apache2
a2enmod security2
systemctl restart apache2

echo "---------------------------------------------Editing packages---------------------------------------------"
sudo mv /etc/modsecurity/modsecurity.conf-recommended /etc/modsecurity/modsecurity.conf
sed -i 's/SecRuleEngine DetectionOnly/SecRuleEngine On/' /etc/modsecurity/modsecurity.conf
sed -i 's/SecAuditLogParts ABDEFHIJZ/SecAuditLogParts ABCEFHJKZ/' /etc/modsecurity/modsecurity.conf
systemctl restart apache2

echo "---------------------------------------------Installing Custom rules---------------------------------------------"
mkdir /etc/apache2/custom-crs
mv custom.conf /etc/apache2/custom-crs

echo "---------------------------------------------Installing OWASP rules---------------------------------------------"
wget https://github.com/coreruleset/coreruleset/archive/v3.3.0.tar.gz
tar xvf v3.3.0.tar.gz
mkdir /etc/apache2/modsecurity-crs/
mv coreruleset-3.3.0/ /etc/apache2/modsecurity-crs/
mv /etc/apache2/modsecurity-crs/coreruleset-3.3.0/crs-setup.conf.example /etc/apache2/modsecurity-crs/coreruleset-3.3.0/crs-setup.conf
sed -i 's/IncludeOptional \/usr\/share\/modsecurity-crs\/\*\.load/IncludeOptional \/etc\/apache2\/modsecurity\-crs\/coreruleset\-3\.3\.0\/crs\-setup\.conf\n	IncludeOptional \/etc\/apache2\/modsecurity\-crs\/coreruleset\-3\.3\.0\/rules\/\*\.conf\n	IncludeOptional \/etc\/apache2\/custom\-crs\/\*\.conf/' /etc/apache2/mods-enabled/security2.conf
systemctl restart apache2





