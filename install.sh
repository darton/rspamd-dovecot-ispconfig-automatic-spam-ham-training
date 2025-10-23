#!/usr/bin/env bash


if [[ $(id -u) -ne 0 ]]; then
  echo "This script must be executed as root or using sudo"
  exit 99
fi

set -e  # Exit immediately if a command exits with a non-zero status

echo "🔧 Installing 'expect' package for automating interactive scripts..."
apt update
apt install -y expect

echo "📁 Copying custom Dovecot configuration to ISPConfig override directory..."
cp dovecot_custom.conf.master /usr/local/ispconfig/server/conf-custom/install/

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
