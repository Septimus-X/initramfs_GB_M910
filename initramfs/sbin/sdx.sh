#!/system/bin/sh
# establish root in common system directories for 3rd party applications
/system/bin/mount -o remount,rw /dev/stl5 /system
/system/bin/rm /system/bin/su
/system/bin/rm /system/xbin/su
/system/bin/rm /system/bin/ifconfig
/system/bin/rm /system/xbin/ifconfig
/system/bin/rm /system/bin/route
/system/bin/rm /system/xbin/route
/system/bin/ln -s /sbin/su /system/bin/su
/system/bin/ln -s /sbin/su /system/xbin/su
/system/bin/ln -s /sbin/busybox /system/bin/ifconfig
/system/bin/ln -s /sbin/busybox /system/xbin/ifconfig
/system/bin/ln -s /sbin/busybox /system/bin/route
/system/bin/ln -s /sbin/busybox /system/xbin/route
/sbin/busybox install -s

#Resets su perms
chmod 4775 /sbin/su

# fix busybox DNS while system is read-write
if [ ! -f "/system/etc/resolv.conf" ]; then
  echo "nameserver 8.8.8.8" >> /system/etc/resolv.conf
  echo "nameserver 8.8.8.4" >> /system/etc/resolv.conf
fi
#setup proper passwd and group files for 3rd party root access
if [ ! -f "/system/etc/passwd" ]; then
	echo "root::0:0:root:/data/local:/system/bin/sh" > /system/etc/passwd
	chmod 0666 /system/etc/passwd
fi
if [ ! -f "/system/etc/group" ]; then
	echo "root::0:" > /system/etc/group
	chmod 0666 /system/etc/group
fi
/system/bin/mount -o remount,ro /dev/stl5 /system

#provide support script to assume direct control
if [ -r "/system/protectsu.sh" ]; then
  /system/bin/sh /system/xbin/su 
fi

#prevents recovery from updating on its own
if [ -r "/system/etc/install-recovery.sh" ]; then
 rm /system/etc/install-recovery.sh
fi