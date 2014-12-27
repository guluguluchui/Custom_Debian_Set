#! /usr/bin/sh

#kernel_version
kernel_version=3.8.13-bone68
filesystem_path=./tmp
kernel_deploy=~/workspace/AM335x/eewiki/deploy


#uEnv.txt
sudo sh -c "echo 'uname_r=${kernel_version}' > ${filesystem_path}/boot/uEnv.txt"
sudo sh -c "echo 'optargs=quiet capemgr.enable_partno=BB-UART1,BB-UART2,BB-UART4,BB-SPIDEV1,BB-I2C1,BB-ADC  init=/lib/systemd/systemd' >> ${filesystem_path}/boot/uEnv.txt"

#kernel, dtbs, modules, firmware 
sudo cp -v ${kernel_deploy}/${kernel_version}.zImage ${filesystem_path}/boot/vmlinuz-${kernel_version}
sudo mkdir -p ${filesystem_path}/boot/dtbs/${kernel_version}/
sudo tar xfv ${kernel_deploy}/${kernel_version}-dtbs.tar.gz -C ${filesystem_path}/boot/dtbs/${kernel_version}/
sudo tar xfv ${kernel_deploy}/${kernel_version}-modules.tar.gz -C ${filesystem_path}/
sudo tar xfv ${kernel_deploy}/${kernel_version}-firmware.tar.gz -C ${filesystem_path}/lib/firmware/

#fstab
sudo sh -c "echo '/dev/mmcblk0p1  /  auto  errors=remount-ro  0  1' >> ${filesystem_path}/etc/fstab"

#inittab
sudo sh -c "echo 'T0:23:respawn:/sbin/getty -L ttyO0 115200 vt102' >> ${filesystem_path}/etc/inittab"

#eMMC-flasher
sudo cp -v ~/workspace/AM335x/eewiki/bbb-eMMC-flasher-eewiki-ext4.sh ${filesystem_path}/root/

#etc/network/interfaces
sudo mv ${filesystem_path}/etc/network/interfaces ${filesystem_path}/etc/network/backup_interfaces
sudo sh -c "echo '# interfaces(5) file used by ifup(8) and ifdown(8)' > ${filesystem_path}/etc/network/interfaces"
sudo sh -c "echo 'auto lo' >> ${filesystem_path}/etc/network/interfaces"
sudo sh -c "echo 'allow-hotplug eth0' >> ${filesystem_path}/etc/network/interfaces"
sudo sh -c "echo 'iface eth0 inet dhcp' >> ${filesystem_path}/etc/network/interfaces"
sudo sh -c "echo 'iface lo inet loopback' >> ${filesystem_path}/etc/network/interfaces" 