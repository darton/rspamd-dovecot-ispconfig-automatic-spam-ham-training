#!/usr/bin/env bash

set -e  # Exit immediately if a command exits with a non-zero status

if [[ $(id -u) -ne 0 ]]; then
  echo "This script must be executed as root or using sudo"
  exit 99
fi

echo "🔧 Installing 'expect' package for automating interactive scripts..."
apt update
apt install -y expect

# Check if ISPConfig is installed by verifying the existence of its custom install directory
echo "📁 Copying custom Dovecot configuration to ISPConfig override directory..."
if [ -d "/usr/local/ispconfig/server/conf-custom/install/" ]; then
    cp dovecot_custom.conf.master /usr/local/ispconfig/server/conf-custom/install/
else
    echo "ISPConfig is not installed or the path does not exist."
    exit 1
fi

echo "🔐 Making the Expect script executable..."
chmod +x ispconfig_auto_update.exp

echo "🚀 Running automated ISPConfig update via Expect script..."
./ispconfig_auto_update.exp

mkdir -p /etc/dovecot/rspamd
cp rspamd-learn-spam.sieve /etc/dovecot/rspamd/
cp rspamd-learn-ham.sieve /etc/dovecot/rspamd/
sievec /etc/dovecot/rspamd/rspamd-learn-ham.sieve
sievec /etc/dovecot/rspamd/rspamd-learn-spam.sieve

chmod u=rw,go= /etc/dovecot/rspamd/rspamd-learn-{spam,ham}.{sieve,svbin}
chown vmail:vmail /etc/dovecot/rspamd/rspamd-learn-{spam,ham}.{sieve,svbin}

cp rspamd-learn-spam.sh /etc/dovecot/rspamd/
cp rspamd-learn-ham.sh /etc/dovecot/rspamd/

chmod u=rwx,go= /etc/dovecot/rspamd/rspamd-learn-{spam,ham}.sh
chown vmail:vmail /etc/dovecot/rspamd/rspamd-learn-{spam,ham}.sh

systemctl restart dovecot
systemctl restart rspamd
