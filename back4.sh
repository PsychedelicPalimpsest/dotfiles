#!/bin/env bash
# Taken fron https://github.com/elapse-d/foo-Wallpaper-Feh-Gif/blob/master/back4.sh


select1='feh --bg-fill '
select2='xwallpaper --zoom '
select3='xloadimage -onroot -fullscreen '
select4='xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/last-image -s '
select5='hsetroot -full '
select6='gsettings set org.gnome.desktop.background picture-uri file:///'

prog=$select1
[ "$#" -lt "1" ] || [ "$#" -gt "2" ] && {  echo -e "ERROR : args number invalid \n $0 speed /path/name.gif" ; echo "try 0.010 as speed" ; exit 1 ; }
dir=/tmp/back4  
#example of speed  : 0.010
speed=$1
name=$2

[[ "$name" == "" ]] && { name=$speed ; speed=${name##*-} ; }

case $name in
    *.gif)
        ;;
    *)
        $prog$name && sleep infinity        ;;
esac


[ ! -f "$name" ] && { echo "file not found" ; exit 1 ; }
[  -f "/usr/local/share/gif-wallpaper/loading.png" ] && ${select1}/usr/local/share/gif-wallpaper/loading.png
hash=`md5sum $name | cut -f1 -d" "`

[[ ! -d $dir ]] && mkdir $dir 

[[ ! -d $dir/$hash ]] && { mkdir $dir/$hash ; echo "spliting .." ; convert -coalesce $name $dir/$hash/$hash.png ; echo ok ; }

if [ "$1" == "auto" ]; then
    frames=($(ls -v "$dir/$hash"))
    amount_of_frames=${#frames[@]}
    frames_per_second=30
    speed=$(bc <<< "scale=3; ($amount_of_frames/$frames_per_second) * (1/$frames_per_second)")
fi
echo $dir
while : ; do for i in ` ls $dir/$hash -v ` ; do $prog$dir/$hash/$i || exit 1 ; sleep $speed || exit 1 ; done ; done    
   
