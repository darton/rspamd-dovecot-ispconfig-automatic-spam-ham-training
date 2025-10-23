#!/bin/bash

set -e  # zakończ przy pierwszym błędzie

echo "🔧 Instalacja expect..."
sudo apt update
sudo apt install -y expect

echo "📁 Kopiowanie pliku konfiguracyjnego dovecot..."
sudo cp dovecot_custom.conf.master /usr/local/ispconfig/server/conf-custom/install/

echo "🔐 Nadanie uprawnień do skryptu expect..."
sudo chmod +x ispconfig_auto_update.exp

echo "🚀 Uruchamianie automatycznej aktualizacji ISPConfig..."
sudo ./ispconfig_auto_update.exp
