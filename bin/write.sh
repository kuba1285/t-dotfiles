#!/bin/bash

grep -q "XMODIFIERS=@im=fcitx" /etc/environment ||
cat << EOF | sudo tee -a /etc/environment
GTK_IM_MODULE=fcitx
QT_IM_MODULE=fcitx
XMODIFIERS=@im=fcitx
EOF

grep -q "IgnoreCarrierLoss=3s" /etc/systemd/network/*.network ||
cat << EOF | sudo tee -a /etc/systemd/network/*.network
IPv6PrivacyExtensions=true
IgnoreCarrierLoss=3s
EOF

sudo sed -i -e "/^ *#Color$/c\ Color\n\ ILoveCandy" /etc/pacman.conf
sudo sed -i -e "/^ *#DefaultTimeoutStartSec=90s/c\ DefaultTimeoutStartSec=10s" /etc/systemd/system.conf
sudo sed -i -e "/^ *#DefaultTimeoutStopSec=90s/c\ DefaultTimeoutStopSec=10s" /etc/systemd/system.conf
sudo sed -i -e '/^ *exec -a/c\exec -a "$0" "$HERE/chrome" "$@" --gtk-version=4 --ozone-platform-hint=auto --enable-features=TouchpadOverscrollHistoryNavigation --disable-smooth-scrolling --enable-fluent-scrollbars' /opt/google/chrome/google-chrome

# steam big picture mode setting
grep -q "Exec=/usr/bin/steam -bigpicture" /usr/share/xsessions/steam-big-picture.desktop ||
sudo mkdir -p /usr/share/xsessions/
sudo touch /usr/share/xsessions/steam-big-picture.desktop
cat << EOF | sudo tee -a /usr/share/xsessions/steam-big-picture.desktop
[Desktop Entry]
Name=Steam Big Picture Mode
Comment=Start Steam in Big Picture Mode
Exec=/usr/bin/steam -bigpicture
TryExec=/usr/bin/steam
Icon=
Type=Application
EOF