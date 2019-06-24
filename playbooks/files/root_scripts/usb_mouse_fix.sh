#!/bin/bash
#https://forum.manjaro.org/t/keyboard-and-mouse-not-working-after-suspend/61424/15
#reset all USB1/2/3 ports
for i in /sys/bus/pci/drivers/[uoex]hci_hcd/*:*; do
  [ -e "$i" ] || continue
  echo "${i##*/}" > "${i%/*}/unbind"
  echo "${i##*/}" > "${i%/*}/bind"
done
