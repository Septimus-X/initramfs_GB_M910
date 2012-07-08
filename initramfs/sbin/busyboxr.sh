#!/system/bin/sh
# Remove Busybox from /sbin and symlinks /system/xbon/busybox so the user can update it at will but allow its use durring boot before /system is mounted or if /system/xbin/busybox doesn't exist.

rm /sbin/busybox
ln -s /system/xbin/busybox /sbin/busybox
