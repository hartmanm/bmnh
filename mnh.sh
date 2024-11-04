#!/bin/bash

# Copyright (c) 2015-2024 Michael Neill Hartman. All rights reserved.
# mnh_license@proton.me
# https://github.com/hartmanm

# mnh.sh

# bash mnh.sh <SOURCE_URL>

# to download and source your config.sh

SOURCE_URL="$1"
CONFIG=`echo "$SOURCE_URL" | tr '/' ' ' | awk '{print $NF}'`
[[ -e $CONFIG ]] && rm $CONFIG
wget $SOURCE_URL 
sleep 1
source $CONFIG

gsshk(){
cd $HOME
ssh-keygen -t ed25519 -C "$GIT_EMAIL"
echo "
add your key to your github ssh keys
xclip -sel clip < ~/.ssh/*.pub
"
ssh -T git@github.com   
}

up(){
source $LEVEL_ZERO/$GIT_REPO_DIRECTORY/$REPO_DIRECTORY/src/b_src/mw
source $LEVEL_ABOVE/open_wrapper/open_wrapper
}

ul(){
cd $LEVEL_ZERO
cd ..
ls -plah
}

lz(){
cd $LEVEL_ZERO
ls -plah
}

gd(){
cd $LEVEL_ZERO/$GIT_REPO_DIRECTORY
ls -plah
}

mnh(){
cd $LEVEL_ZERO/$GIT_REPO_DIRECTORY/$REPO_DIRECTORY
ls -plah
gs
}

cl(){
clear
}

og(){
lz 
(gnome-text-editor &)
sleep 2
cl
}

cr(){
cd $LEVEL_ZERO/$GIT_REPO_DIRECTORY
[[ ! -d $LEVEL_ZERO/$GIT_REPO_DIRECTORY/.git ]] && {
git init -b main
git config user.email "$GIT_EMAIL"
git config user.name "$GIT_USER_NAME"
echo "
initialized repo with branch 'main' at:  $LEVEL_ZERO/$GIT_REPO_DIRECTORY
"
}
#local last_record=
#local current_sha256_sum=
#local current_record=
#local current_tar_name=$REPO_DIRECTORY.tar
#tar -cf $current_tar_name $REPO_DIRECTORY
local current_dtg=`d`
#current_sha256_sum=`sha256sum $current_tar_name`
#touch $current_sha256_sum
#mkdir -p $current_dtg
#mv $current_sha256_sum $current_dtg
#cd $LEVEL_ZERO/$GIT_REPO_DIRECTORY
#while [[ -e $LEVEL_ZERO/$GIT_REPO_DIRECTORY/$current_tar_name ]] 
#do
#mv $LEVEL_ZERO/$GIT_REPO_DIRECTORY/$current_tar_name $LEVEL_ZERO/$GIT_REPO_DIRECTORY/$current_dtg
#sleep 1
#ls
#done
#[[ ! -d $LEVEL_ZERO/$GIT_REPO_DIRECTORY/$RECORD_DIRECTORY ]] && mkdir -p $LEVEL_ZERO/#$GIT_REPO_DIRECTORY/$RECORD_DIRECTORY
#last_record=`glcrd`
#current_record=$LEVEL_ZERO/$GIT_REPO_DIRECTORY/$RECORD_DIRECTORY/$(($last_record +1))
#mkdir -p $current_record
#mv $current_dtg $current_record
#ls
#ls $RECORD_DIRECTORY
#du -ah $LEVEL_ZERO/$GIT_REPO_DIRECTORY/$RECORD_DIRECTORY/$(($last_record +1))
cd $LEVEL_ZERO/$GIT_REPO_DIRECTORY
git add .
[[ "$@" != "" ]] && {
git commit -m "`echo $@`"
} || git commit -m creating_record
git bundle create $REPO_DIRECTORY.bundle --all
mv $REPO_DIRECTORY.bundle ..
mhr
gl
echo "
generating level_zero archive
"
cd $LEVEL_ZERO
cd ..
time tar -cf ${LEVEL_ZERO_TOKEN}.tar --exclude=build --exclude=remote_gref --exclude=brute_dictionaries --exclude=ssl_keys $LEVEL_ZERO_TOKEN
mkdir enc_$current_dtg
mv ${LEVEL_ZERO_TOKEN}.tar enc_$current_dtg
cd enc_$current_dtg
## todo "stdin encryption password required"
time openssl enc -pbkdf2 -aes-256-cbc -in ${LEVEL_ZERO_TOKEN}.tar -out e.enc
rm ${LEVEL_ZERO_TOKEN}.tar
echo "
level_zero archive complete
"
ls -plahi
cd ..
ls -plahi | grep $current_dtg
lz
}

d(){
date | tr ': ' '_' | tr '[:upper:]' '[:lower:]'
}

#glcrd(){
#cd $LEVEL_ZERO/$GIT_REPO_DIRECTORY/$RECORD_DIRECTORY
#ls -1 | sort -n | tail -1
#}

mhr(){
local start=`pwd`
cd $LEVEL_ZERO/$GIT_REPO_DIRECTORY
local target_directory="$REPO_DIRECTORY"
local items=` du -a ${target_directory} | awk '{print $2}'`
local level_above=
local gref_directory=
local directories=
local files=
local current_sum=
local char_order=(a b c d e f g h i j k l m n o p q r s t u v w x y z)
local iterator=0
local directory_iterator=0
local directory_level_iterator=1
local processed=
local unprocessed=
local last_directory=
local current_path=
local repo_directory=
local skip=0
local initialize_gref_repo=0
for item in `echo $items`
do
[[ -d $item ]]   && directories="$directories $item" 
[[ ! -d $item ]] && files="$files $item"
done
[[ -d gref ]] && rm -r gref
mkdir gref
cd gref
gref_directory=`pwd`
for directory in `echo $directories`
do
mkdir -p $directory
for file in `echo $files`
do
current_sum=""
[[ `echo $file | grep $directory` != "" ]] && [[ `ls -R $directory | grep '\n' | wc -l` == 1 ]] && {
current_sum=`sha256sum ../${directory}/$(basename ${file})`
#echo "from $directory is one  $file  ${iterator}_${current_sum}"
touch ${directory}/${iterator}_${current_sum}
[[ $iterator -eq 25 ]] && iterator=0
iterator=$(($iterator +1))
}
done
done
# process gref as mhr
cd $gref_directory
repo_directory=`ls`
cd $repo_directory
current_path=${gref_directory}/${repo_directory}
directory_level_iterator=1
unprocessed="init"
while [[ `echo $unprocessed` != "" ]] 
do
cd ${gref_directory}/${repo_directory}
unprocessed=`ls -R | grep : | tr '/:.' ' ' | awk -v i=$directory_level_iterator '{print $i}' | tr '\n' ' '`
#echo "
#unprocessed : $unprocessed
#"
#echo "
#current_path : $current_path
#"
[[ -d ${current_path} ]] && cd ${current_path}  
for directory in `echo $unprocessed`
do
#echo $directory from  "directory in echo unprocessed"
skip=0
for already_processed_directory in `echo $processed`
do
[[ $directory == $already_processed_directory ]] && skip=1
done
## todo fix
## 2 edge cases
[[ $skip -eq 0 ]] && {
mv $directory ${directory_level_iterator}${char_order[$directory_iterator]}
last_directory=${directory_level_iterator}${char_order[$directory_iterator]}
current_path=${current_path}/${last_directory}
}
processed="$processed $directory"
directory_iterator=$(($directory_iterator +1))
done
directory_level_iterator=$(($directory_level_iterator +1))
directory_iterator=0
#echo "
#current_path : $current_path
#"
done
# end process gref as mhr
cd $gref_directory
cd ..
level_above=`pwd`
cd ..
[[ -d gref ]] && rm -rf gref
cd $level_above
mv gref ..
cd ..
#ls -R $LEVEL_ZERO/${GIT_REPO_DIRECTORY}/${target_directory}
ls -R gref
## process remote gref
#REPO_HEAD=`git ls-remote https://github.com/${GREF_GITHUB_USERNAME}/${REPO_DIRECTORY}.git | head -1`
#REPO_HEAD=`git ls-remote git@github.com/${GREF_GITHUB_USERNAME}/${REPO_DIRECTORY}.git | head -1`
#IS_REPO=`echo $REPO_HEAD | awk '{print $2}'`
#[[ `echo $IS_REPO` != "HEAD" ]] && initialize_gref_repo=1
[[ $initialize_gref_repo -eq 1 ]] && {
echo "
initialize_gref_repo -eq 1
"
[[ ! -d gref/.git ]] && {
## todo fix
## ensure repo is already existing on github
cd gref/${REPO_DIRECTORY}
git init -b gref
git config user.email "$GIT_EMAIL"
git config user.name "$GIT_USER_NAME"
#git remote set-url origin git@github.com:${GREF_GITHUB_USERNAME}/${REPO_DIRECTORY}.git
#git remote add origin https://github.com/${GREF_GITHUB_USERNAME}/${REPO_DIRECTORY}.git
git remote add origin git@github.com:${GREF_GITHUB_USERNAME}/${REPO_DIRECTORY}.git
git push -u origin gref
git branch --set-upstream-to=origin/gref gref
echo "
initialized repo with branch 'gref' at:  ${LEVEL_ZERO}/gref/${REPO_DIRECTORY}
"
}
git add -A
git commit -am "initial commit gref"
git push -u origin gref
cd $LEVEL_ZERO
}
[[ $initialize_gref_repo -eq 0 ]] && {
#CURRENT_REPO_COMMMIT=`echo $REPO_HEAD | awk '{print $1}'`
#echo "
#CURRENT_REPO_COMMMIT:
#$CURRENT_REPO_COMMMIT
#"
cd $LEVEL_ZERO
[[ ! -d remote_gref ]] && {
mkdir -p remote_gref
cd remote_gref
git clone git@github.com:${GREF_GITHUB_USERNAME}/${REPO_DIRECTORY}.git
}
cd ${LEVEL_ZERO}/remote_gref/${REPO_DIRECTORY}
git pull
cp -rp ${LEVEL_ZERO}/remote_gref/${REPO_DIRECTORY}/.git ${LEVEL_ZERO}/gref/${REPO_DIRECTORY}
cd ${LEVEL_ZERO}/gref/${REPO_DIRECTORY}
git config user.email "$GIT_EMAIL"
git config user.name "$GIT_USER_NAME"
#git remote set-url gref git@github.com:${GREF_GITHUB_USERNAME}/${REPO_DIRECTORY}.git
git add -A
git commit -am "gref $REFERENCE_TOKEN"
git push
gs
gl
}
cd $start
echo "
------------------------------------------
gref processing complete
"
}

obd(){
objdump -s $LEVEL_ZERO/build/$C_EXEC
}

di(){
docker images
}

dp(){
docker ps
}

dk(){
docker kill `docker ps -q`
}

ob(){
ls -plahiR $LEVEL_ZERO/build
}

lc(){
local 
local build_command="gcc -o $LEVEL_ZERO/build/$C_EXEC $LEVEL_ZERO/$GIT_REPO_DIRECTORY/$REPO_DIRECTORY/src/c_src/m.c -l ssl -l crypto"
#local build_parameters="generate display run_cmd du -ah end"
local build_parameters="generate display run_cmd ls end"
local run_command="./${C_EXEC} $build_parameters"
[[ -d $LEVEL_ZERO/build ]] && rm -rf $LEVEL_ZERO/build
while [[ ! -d $LEVEL_ZERO/build ]]
do
mkdir -p $LEVEL_ZERO/build
done
cp $LD_LIBRARY_PATH/libssl.so.3 $LEVEL_ZERO/build
cp $LEVEL_ZERO/ssl_keys/* $LEVEL_ZERO/build
`${build_command}`
echo "!${run_command}!"
# todo make abstraction
###############
cd $LEVEL_ZERO/$GIT_REPO_DIRECTORY/$REPO_DIRECTORY/src/s_src
gcc -o hss hss.c -l ssl -l crypto
mv hss $LEVEL_ZERO/build
gcc -o hcs hcs.c -l ssl -l crypto
mv hcs $LEVEL_ZERO/build
###############
cd $LEVEL_ZERO/build
./${C_EXEC} ${run_command}
ob
}

dc(){
local gcc_version_tag=13.3.0-bookworm
local exec_version_tag=stable-glibc
local build_command="/usr/local/bin/./gcc -o build/$C_EXEC $GIT_REPO_DIRECTORY/$REPO_DIRECTORY/src/c_src/m.c -l ssl -l crypto"
#local build_parameters="generate display run_cmd du -ah end"
local build_parameters="generate display run_cmd ls end"
local run_command="./$C_EXEC $build_parameters"
[[ -d $LEVEL_ZERO/build ]] && rm -rf $LEVEL_ZERO/build
while [[ ! -d $LEVEL_ZERO/build ]]
do
mkdir -p $LEVEL_ZERO/build
done
cp $LD_LIBRARY_PATH/libssl.so.3 $LEVEL_ZERO/build
cp $LEVEL_ZERO/ssl_keys/* $LEVEL_ZERO/build
docker run --rm -v "$LEVEL_ZERO":/build -w /build gcc:$gcc_version_tag ${build_command}
ls -plahi $LEVEL_ZERO/build
docker run --rm -v "$LD_LIBRARY_PATH":/usr/lib -v "$LEVEL_ZERO/build":/build -w /build busybox:$exec_version_tag ${run_command}
ob
}

cw(){
local emsdk_version_tag=3.1.61
local exec_version_tag=hydrogen-alpine3.20
local build_command="emcc -o build/h.js $GIT_REPO_DIRECTORY/$REPO_DIRECTORY/src/c_src/m.c -l ssl -l crypto"
local build_parameters="generate display"
local run_command="node h.js $build_parameters="
while [[ ! -d $LEVEL_ZERO/build ]]
do
mkdir -p $LEVEL_ZERO/build
done
cp $LD_LIBRARY_PATH/libssl.so.3 $LEVEL_ZERO/build
cp $LEVEL_ZERO/ssl_keys/* $LEVEL_ZERO/build
docker run --rm -v "$LEVEL_ZERO":/build -w /build emscripten/emsdk:$emsdk_version_tag ${build_command}
ls -plahi $LEVEL_ZERO/build
docker run --rm -v "$LD_LIBRARY_PATH":/usr/lib -v "$LEVEL_ZERO/build":/build -w /build node:$exec_version_tag ${run_command}             
ob
}

gs(){
git status
}

gl(){
git log -1
}

ga(){
git add -A
}

gp(){
git pull
}

gb(){
git branch
}

gll(){
git log --pretty=oneline
}

gt(){
ssh -T git@github.com  
}

gtv(){  
ssh -vT git@github.com
}

le(){
ul
ls -plhR enc*
}

dcrypt_archive(){
[[ -e e.enc ]] && {
time openssl enc -d -pbkdf2 -aes-256-cbc -in e.enc -out ${LEVEL_ZERO_TOKEN}.tar
time tar -xf ${LEVEL_ZERO_TOKEN}.tar
}
}

mount_d_drive(){
# windows v
cd /mnt
[[ ! -d d ]] && sudo mkdir d
sudo mount -t drvfs D: /mnt/d
}

umount_d_drive(){
# windows v
sudo umount /mnt/d
}

generate_new_yubikey_with_password(){
ykman config usb --disable u2f
ykman config usb --disable fido2
ykman config usb --disable oath
ykman config usb --disable openpgp
ykman config usb --disable piv
ykman config usb --disable hsmauth
echo "warning new password!!"
ykman otp static 1 --no-enter -k US -g
ykman info
}

generate_new_yubikey_for_passkey(){
ykman config usb --disable u2f
ykman config usb --enable fido2
ykman config usb --disable oath
ykman config usb --disable openpgp
ykman config usb --disable piv
ykman config usb --disable hsmauth
ykman config usb --disable otp
ykman info
}

us(){
sudo ufw status verbose
}

block(){
# ufws
#stop_processes
#sudo apt install -y ufw
sudo ufw enable
sudo ufw default deny incoming
sudo ufw default deny outgoing
sudo ufw deny https
sudo ufw deny http
sudo ufw default deny 22
sudo ufw status verbose
deny_workers
#sudo ufw deny from 8.8.8.8 to any port 53
sudo ufw deny out to ${GITHUB_IP} port 22
sudo ufw deny out to any
sudo ufw deny in to any
#sudo ufw deny to ${GITHUB_IP} from any port 22
#sudo ufw deny from 0.0.0.0 to any port $SERVER_PORT proto tcp
#sudo ufw deny to 0.0.0.0 from any port $SERVER_PORT proto tcp
#sudo ufw deny from 127.0.0.1 to any port $SERVER_PORT proto tcp
#sudo ufw deny to 127.0.0.1 from any port $SERVER_PORT proto tcp
sudo systemctl stop networking
lsof -i
us
}

github(){
sudo ufw enable
sudo ufw default deny incoming
sudo ufw default deny outgoing
sudo systemctl start networking
sudo ufw default deny 22
#sudo ufw allow from 8.8.8.8 to any port 53
sudo ufw allow out to ${GITHUB_IP} port 22
#sudo ufw allow to ${GITHUB_IP} from any port 22
sudo ufw status verbose
deny_workers
lsof -i
}

net(){
# ufws
#sudo apt install -y ufw
sudo ufw enable
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow https
sudo ufw deny http
sudo systemctl start networking
sudo ufw status verbose
#sudo ufw allow out to ${GITHUB_IP} port 22
#sudo ufw allow from 0.0.0.0 to any port $SERVER_PORT proto tcp
#sudo ufw allow to 0.0.0.0 from any port $SERVER_PORT proto tcp
#sudo ufw allow from 127.0.0.1 to any port $SERVER_PORT proto tcp
#sudo ufw allow to 127.0.0.1 from any port $SERVER_PORT proto tcp
deny_workers
lsof -i
}

allow_workers(){
# ufws
sudo ufw allow from $WORKER_IP to any port $SERVER_PORT proto tcp
sudo ufw reload
#sudo ufw status numbered
us
}

deny_workers(){
# ufws
sudo ufw deny from $WORKER_IP to any port $SERVER_PORT proto tcp
sudo ufw reload
#sudo ufw status numbered
us
}

#stop_processes(){
# ufws
#sudo systemctl stop cups
#sudo systemctl disable cups
#sudo systemctl stop avahi-daemon
#sudo systemctl disable avahi-daemon
#lsof -i
# ss -a
#}

disable_ipv6(){
echo "
sudo nano /etc/sysctl.conf
# append to the end of the file
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
net.ipv6.conf.tun0.disable_ipv6 = 1
"
echo "
sudo nano /etc/default/ufw
add or modify the following to disable ipv6:
IPV6=no
"
echo "
sudo ufw reload
sudo ufw disable
sudo ufw enable
"
echo "
now
sudo reboot
"
}

genssl(){
[[ `which openssl` == "" ]] && sudo apt install -y libssl-dev
[[ ! -d $LEVEL_ZERO/ssl_keys ]] && mkdir -p $LEVEL_ZERO/ssl_keys
cd $LEVEL_ZERO/ssl_keys
openssl genrsa -out client.key 2048
openssl req -new -key client.key -out client.csr
openssl x509 -req -days 365 -in client.csr -signkey client.key -out client.crt
openssl genrsa -out server.key 2048
openssl req -new -key server.key -out server.csr
openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt
}

open_wrapper_src(){
#add to open_wrapper dir on same level as level_zero
#add to bashrc : 
#source /media/root/space/open_wrapper/open_wrapper
#source /media/root/space/level_zero/gd/mnh/src/b_src/mw
#!/bin/bash

##
## © 2024 Michael Neill Hartman, All rights reserved.
## 

LA=/media/root/space
LZ=/media/root/space/level_zero

dec_arc(){
cd $LA
cd `ls | grep enc_`
# assumes function is exec from same directory as e.enc
time openssl enc -d -pbkdf2 -aes-256-cbc -in e.enc -out level_zero.tar
time tar -xf level_zero.tar
rm level_zero.tar
mv level_zero ..
cd ..
ls -plahi
}
enc_dev(){
[[ -d $LZ ]] && {
cd $LZ
cd ..
time tar -cf level_zero.tar level_zero
time openssl enc -pbkdf2 -aes-256-cbc -in level_zero.tar -out e.enc
rm level_zero.tar
local current_date=`d`
mkdir enc_$current_date
mv e.enc enc_$current_date
ls -plahi enc_$current_date
echo "verify and rm local"
}
}

}

bl(){
cat /sys/class/power_supply/BAT0/capacity
}

wbl(){
watch -n 1 cat /sys/class/power_supply/BAT0/capacity
}

wlsof(){
watch -n 1 sudo lsof -i
}

scs(){
systemctl status
}

ds(){
local contents=$@
#echo "
#$contents
#"
local last_ds="`ls /tmp | grep dropped_shell | tr '_' ' ' | awk '{print $3}' | sort -n | tail -1`"
[[ $last_ds == "" ]] && last_ds=0
#local last_ds=$(($last_ds +1-1))
local new_ds_number=$(($last_ds +1))
cat << EOF > /tmp/dropped_shell_$new_ds_number
#!/bin/bash
$contents
EOF
cat /tmp/dropped_shell_$new_ds_number
(bash /tmp/dropped_shell_$new_ds_number &)
}

dsd(){
# on process stop , restart
local contents=$@
local last_ds="`ls /tmp | grep dropped_daemon | tr '_' ' ' | awk '{print $3}' | sort -n | tail -1`"
[[ $last_ds == "" ]] && last_ds=0
local new_ds_number=$(($last_ds +1))
cat << EOF > /tmp/dropped_daemon_$new_ds_number
#!/bin/bash
$contents
EOF
#cat /tmp/dropped_daemon_$new_ds_number
cat << EOF > /tmp/d_droppeddaemon_$new_ds_number
#!/bin/bash
while [[ 1 -eq 1 ]]
do
[[ "`ps -ef | grep dropped_daemon_$new_ds_number`" == "" ]] && (bash /tmp/dropped_daemon_$new_ds_number &)
done
EOF
(bash /tmp/d_droppeddaemon_$new_ds_number &)
}

eaib(){
# exec at interval like watch in background
local interval=1
local contents=$@
local last_ds="`ls /tmp | grep dropped_daemon | tr '_' ' ' | awk '{print $3}' | sort -n | tail -1`"
[[ $last_ds == "" ]] && last_ds=0
local new_ds_number=$(($last_ds +1))
cat << EOF > /tmp/dropped_daemon_$new_ds_number
#!/bin/bash
$contents
EOF
cat << EOF > /tmp/d_droppeddaemon_$new_ds_number
#!/bin/bash
while [[ 1 -eq 1 ]]
do
sleep $interval
(bash /tmp/dropped_daemon_$new_ds_number &)
done
EOF
(bash /tmp/d_droppeddaemon_$new_ds_number &)
}

eai(){
# exec at interval like watch
local interval=1
local contents=$@
local last_ds="`ls /tmp | grep dropped_daemon | tr '_' ' ' | awk '{print $3}' | sort -n | tail -1`"
[[ $last_ds == "" ]] && last_ds=0
local new_ds_number=$(($last_ds +1))
cat << EOF > /tmp/dropped_daemon_$new_ds_number
#!/bin/bash
$contents
EOF
cat << EOF > /tmp/d_droppeddaemon_$new_ds_number
#!/bin/bash
while [[ 1 -eq 1 ]]
do
sleep $interval
clear
bash /tmp/dropped_daemon_$new_ds_number
done
EOF
(bash /tmp/d_droppeddaemon_$new_ds_number &)
}

dk(){
pkill -f d_
rm /tmp/*drop*
}

dl(){
local contents=$@
cat << EOF > /tmp/dropped_log
$contents
EOF
}

dc(){
[[ -e $1 ]] && { 
local start_state="`sha256sum $1`"
local spot=0
local execs=`echo "$@" | cut -d ' ' -f 2-`
while [[ "`sha256sum $1`" == $start_state ]]
do
spot=0
done
# do something when file changes
echo "
$1 changed, running:
$execs 
"
#echo "`$execs`"
exec "`$execs`"
}
}

mscs(){
local event="$@"
echo "
processing:
$event
"
dl "`scs | grep ─`"
while [[ 1 -eq 1 ]]
do
cp /tmp/dropped_log /tmp/compare_log
(dc /tmp/dropped_log "$event" &)
while [[ 1 -eq 1 ]]
do
dl "`scs | grep ─`"
done
done
}

eosc(){
mscs diff -y /tmp/compare_log /tmp/dropped_log
#mscs echo "'systemctl status change'; diff /tmp/compare_log /tmp/dropped_log"
}

fs_bk_dvd(){
local bk_name=dvd_bk_`d`.tar
cd /media/root/space/archive
tar -cf $bk_name *
sudo growisofs -dvd-compat -Z /dev/`lsblk | grep 2K | grep rom | awk '{print $1}'` -R -J $bk_name
}

#append_fs_to_bk_dvd(){
#local bk_name=dvd_bk_`d`.tar
#cd /media/root/space/archive
#tar -cf $bk_name *
## todo how to id with 2x dvd roms?
#sudo growisofs -dvd-compat -M /dev/`lsblk | grep rom | awk '{print $1}'` -i -R -J $bk_name
#}

ba_bk_dvd(){
gbafa
sudo growisofs -dvd-compat -Z /dev/`lsblk | grep 2K | grep rom | awk '{print $1}'`=/media/root/space/ba_bk
}

#append_to_bk_dvd(){
#gbafa
## todo how to id with 2x dvd roms?
#sudo growisofs -dvd-compat -M /dev/`lsblk | grep rom | awk '{print $1}'`=/media/root/space/ba_bk
#}

gba(){
local ba_size=$1
local build_directory=$2
dd if=/dev/zero of=$build_directory/ba bs=4096 count=$(($ba_size / 4096)) status=progress
sudo /usr/sbin/mkfs.ext4 -b 4096 $build_directory/ba
}

gbafa(){
[[ ! -e /media/root/space/ba_bk ]] && {
local archive_size=`du -s /media/root/space/archive | awk '{print $1}'`
archive_size=$(($archive_size * 10))
# full 4.7GB dvd
[[ $archive_size -lt  4700000000 ]] && archive_size=4700000000
echo $archive_size
gba $archive_size `pwd`
[[ ! -d /media/root/space/m ]] && mkdir /media/root/space/m
sudo mount -rw /media/root/space/ba /media/root/space/m
sudo chown r2r:r2r /media/root/space/m
sudo cp -rp /media/root/space/archive/* /media/root/space/m
sudo chown -R r2r:r2r /media/root/space/m
ls -plahi /media/root/space/m
sudo umount /media/root/space/m
mv /media/root/space/ba ba_bk
rm -rf /media/root/space/m
}
[[ -e /media/root/space/ba_bk ]] && {
[[ ! -d /media/root/space/m ]] && mkdir /media/root/space/m
sudo mount -rw /media/root/space/ba_bk /media/root/space/m
sudo chown r2r:r2r /media/root/space/m
sudo cp -rp /media/root/space/archive/* /media/root/space/m
sudo chown -R r2r:r2r /media/root/space/m
ls -plahi /media/root/space/m
sudo umount /media/root/space/m
rm -rf /media/root/space/m
}
}

# from dxrb

droppc(){
#  "
##!/bin/bash
#echo "
# Copyright (c) Michael Neill Hartman. All rights reserved.
# mnh_license@proton.me
# https://github.com/hartmanm
#"
#" > /bin/$1
echo "1"
}

pc(){
echo ""
echo "# Copyright (c) Michael Neill Hartman. All rights reserved."
echo "# mnh_license@proton.me"
echo "# https://github.com/hartmanm"
echo ""
}

lls(){
ls -plahi
}

xt(){
xterm -geometry 300x100+50+50
#+100+100
}

xf(){
xfce4-terminal --geometry=90x80+50+50 --title=spawn
}

x2(){
xfce4-terminal --geometry=92x58+10+10 --title=spawn
xfce4-terminal --geometry=92x58+980+10 --title=spawn
}

xx(){
xfce4-terminal --geometry=92x27+980+10 --title=spawn
}

x4e(){
xfce4-terminal --geometry=92x27+10+10 --title=spawn  --execute="`pc`"
xfce4-terminal --geometry=92x27+970+10 --title=spawn --command=htop
xfce4-terminal --geometry=92x27+10+610 --title=spawn --execute="`lls`"
xfce4-terminal --geometry=92x27+970+610 --title=spawn --execute="`df`"
}

x4(){
xfce4-terminal --geometry=92x27+10+10 --title=spawn  
xfce4-terminal --geometry=92x27+970+10 --title=spawn 
xfce4-terminal --geometry=92x27+10+610 --title=spawn 
xfce4-terminal --geometry=92x27+970+610 --title=spawn 
}

ht(){
xfce4-terminal --help
}

ct(){
xterm &
pkill -f xfce4-terminal
#xfce4-terminal --geometry=92x15+10+10 
}

ks(){
pkill -f terminal
}

get_diff(){
diff -y "$1" "$2" | grep "<" 
}

sb(){
source ~/bf
}

eb(){
nano ~/bf
}

c(){
clear
}

ai(){
apt install $@
}

ap(){
apt purge ${@}*
}

dfw(){
watch -n 1 df -h
}

gblobs(){
BASE=/sps
TARGET_MOUNT=/sps
BLOBS=0
SEC_DIR=0
SKIP=0
[[ `ls -1 $BASE | sort -n | tail -1` != "" ]] && {
SKIP=`ls -1 $BASE | sort -n | tail -1`
SEC_DIR=$(($SEC_DIR+$SKIP-1))
}
mkdir -p $BASE/$SEC_DIR
while [[ `df -h $BASE/$SEC_DIR | grep -w $TARGET_MOUNT  | awk '{print $(NF-1)}'` != "100%" ]]
do
[[ $(($BLOBS % 1000)) -eq 0 ]] && {
SEC_DIR=$(($SEC_DIR-1+2))
mkdir $BASE/$SEC_DIR
echo generated $BASE/$SEC_DIR
}
dd if=/dev/zero of=$BASE/$SEC_DIR/b_$BLOBS bs=1 count=1 status=none
chmod 444 $BASE/$SEC_DIR/b_$BLOBS
BLOBS=$(($BLOBS-1+2))
done
chmod 444 -R $BASE/*
}
