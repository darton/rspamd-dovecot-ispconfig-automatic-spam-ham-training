#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

echo "🔧 Installing 'expect' package for automating interactive scripts..."
sudo apt update
sudo apt install -y expect

echo "📁 Copying custom Dovecot configuration to ISPConfig override directory..."
sudo cp dovecot_custom.conf.master /usr/local/ispconfig/server/conf-custom/install/

echo "🔐 Making the Expect script executable..."
sudo chmod +x ispconfig_auto_update.exp

echo "🚀 Running automated ISPConfig update via Expect script..."
sudo ./ispconfig_auto_update.exp
