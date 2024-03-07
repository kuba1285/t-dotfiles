#!/bin/bash

cat << EOF >> ~/.zshrc
export PATH="\$PATH:/home/$USER/bin"

neofetch
TMOUT=900
TRAPALRM() {
MODELS=(\$(ls -d /home/$USER/bin/models/*))
SEC=\`date +%S\`
I=\$((SEC%\$(echo \${#MODELS[@]})+1))
3d-ascii-viewer -z 120 \${MODELS[\$I]}
}
EOF

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
sudo sed -i -e '/^ *exec -a/c\exec -a "$0" "$HERE/chrome" "$@" --gtk-version=4 --ozone-platform-hint=auto --enable-gpu-rasterization --enable-zero-copy \
--enable-features=TouchpadOverscrollHistoryNavigation --disable-smooth-scrolling --enable-fluent-scrollbars' /opt/google/chrome/google-chrome

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

if [[ $XDG_SESSION_TYPE = x11 ]] ; then
  grep -q "feh --bg-center" ~/.zshrc ||
  WPDIR=~/.config/swww/
  mkdir $WPDIR
  cat << EOF >> ~/.zshrc
WALLPAPER="\$(ls -1a $WPDIR | shuf -n 1)"; feh --bg-center \$WALLPAPER; wal -i \$WALLPAPER -n
EOF

  grep -q "xinput set-prop 11 318 1" ~/.xsessionrc ||
  cat << EOF | tee -a ~/.xsessionrc
xinput set-prop 11 318 1
xinput --set-prop "Apple SPI Touchpad" "Coordinate Transformation Matrix" 4 0 0 0 4 0 0 0 1
EOF

  grep -q "TearFree" /etc/X11/xorg.conf.d/20-intel.conf ||
  cat << EOF | sudo tee -a /etc/X11/xorg.conf.d/20-intel.conf
GSection "Device"
Identifier "Intel Graphics"
Driver "intel"
Option "TearFree" "true"
EndSection
EOF

  grep -q "CornerCoasting" /etc/X11/xorg.conf.d/51-synaptics-tweaks.conf ||
  cat << EOF | sudo tee -a /etc/X11/xorg.conf.d/51-synaptics-tweaks.conf
Section "InputClass"
  Identifier "touchpad"
  Driver "synaptics"
  MatchIsTouchpad "on"
    Option "Tapping" "True"
    Option "TappingDrag" "True"
    Option "DisableWhileTyping" "True"
    Option "CornerCoasting" "0"
    Option "CoastingSpeed" "20"
    Option "CoastingFriction" "50"
EndSection
EOF

  cat << EOF | tee ~/.config/fusuma/config.yml
swipe:
  4:
    left:
      sendkey: 'LEFTMETA+LEFTCTRL+RIGHT' # next
    right:
      sendkey: 'LEFTMETA+LEFTCTRL+LEFT'  # previous
threshold:
  swipe: 0.7
interval:
  swipe: 0.8
---
context:
  application:  Google-chrome
swipe:
  3:
    begin:
      command: xdotool keydown Ctrl # hold ctrl down
    right:
      update:
        command: xdotool key Tab  # press tab
        interval: 3
    left:
      update:
        command: xdotool key Shift+Tab # press shift+tab
        interval: 3
    end:
      command: xdotool keyup Ctrl  Ctrl # release ctrl
    up:
      sendkey: 'LEFTCTRL+T'    # new tab
      keypress:
        LEFTSHIFT: # when press shift down
          sendkey: 'LEFTSHIFT+LEFTCTRL+T' # open last closed tab
    down:
      sendkey: 'LEFTCTRL+W'    # close tab
---
context:
  application:  firefox
swipe:
  3:
    begin:
      command: xdotool keydown Ctrl # hold ctrl down
    right:
      update:
        command: xdotool key Tab  # press tab
        interval: 3
    left:
      update:
        command: xdotool key Shift+Tab # press shift+tab
        interval: 3
    end:
      command: xdotool keyup Ctrl  Ctrl # release ctrl
    up:
      sendkey: 'LEFTCTRL+T'    # new tab
      keypress:
        LEFTSHIFT: # when press shift down
          sendkey: 'LEFTSHIFT+LEFTCTRL+T' # open last closed tab
    down:
      sendkey: 'LEFTCTRL+W'    # close tab
EOF
fi
