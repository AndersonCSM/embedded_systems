#!/bin/bash

LOG="/boot/firstboot.log"

echo "Iniciando configuração automática..." >> $LOG

# Atualizar sistema
apt update >> $LOG 2>&1
apt -y upgrade >> $LOG 2>&1

# Instalar pacotes
apt -y install fastfetch stress-ng >> $LOG 2>&1

# Configurar WiFi
cat <<EOF >> /etc/wpa_supplicant/wpa_supplicant.conf

network={
    ssid="ACSMNOTEBOOK-NET"
    psk="38aM3<92"
}
EOF

# Ajustar swap agressividade
cat <<EOF > /etc/sysctl.d/99-custom.conf
vm.swappiness=10
vm.vfs_cache_pressure=50
EOF

sysctl --system >> $LOG 2>&1

# Aplicar overclock (Pi Zero 2W)
cat <<EOF >> /boot/config.txt

# Overclock custom
arm_freq=1200
core_freq=500
EOF

echo "Finalizado." >> $LOG

# Remover serviço e script
rm -f /etc/systemd/system/firstboot.service
rm -f /boot/firstboot.sh

reboot