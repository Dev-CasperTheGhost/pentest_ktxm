#!/bin/bash

binarylist='aria2c\|arp\|ash\|awk\|base64\|bash\|busybox\|cat\|chmod\|chown\|cp\|csh\|curl\|cut\|dash\|date\|dd\|diff\|dmsetup\|docker\|ed\|emacs\|env\|expand\|expect\|file\|find\|flock\|fmt\|fold\|ftp\|gawk\|gdb\|gimp\|git\|grep\|head\|ht\|iftop\|ionice\|ip$\|irb\|jjs\|jq\|jrunscript\|ksh\|ld.so\|ldconfig\|less\|logsave\|lua\|make\|man\|mawk\|more\|mv\|mysql\|nano\|nawk\|nc\|netcat\|nice\|nl\|nmap\|node\|od\|openssl\|perl\|pg\|php\|pic\|pico\|python\|readelf\|rlwrap\|rpm\|rpmquery\|rsync\|ruby\|run-parts\|rvim\|scp\|script\|sed\|setarch\|sftp\|sh\|shuf\|socat\|sort\|sqlite3\|ssh$\|start-stop-daemon\|stdbuf\|strace\|systemctl\|tail\|tar\|taskset\|tclsh\|tee\|telnet\|tftp\|time\|timeout\|ul\|unexpand\|uniq\|unshare\|vi\|vim\|watch\|wget\|wish\|xargs\|xxd\|zip\|zsh'

hdh=$( (cat /proc/version || uname -a ) 2>/dev/null )
echo -e "\e[34mThông tin về hệ điều hành:\e[0m"
echo "$hdh" | sed 's/^/  /'

sudo_result=$(sudo -V 2>&1)
echo -e "\e[33mĐây là phiên bản sudo:\e[0m"
echo "$sudo_result" | sed 's/^/  /'

pass=$( (env || set) 2>/dev/null )
echo -e "\e[31mThông tin thú vị, mật khẩu hoặc khóa API trong các biến môi trường:\e[0m"
echo "$pass" | sed 's/^/  /'

apparmor=$(
    if [ `which aa-status 2>/dev/null` ]; then

   aa-status

 elif [ `which apparmor_status 2>/dev/null` ]; then

   apparmor_status

 elif [ `ls -d /etc/apparmor* 2>/dev/null` ]; then

   ls -d /etc/apparmor*

 else

   echo "Not found AppArmor"

fi

 )
echo -e "\e[34mThông tin về cơ chế phòng thủ apparmor:\e[0m"
echo "$apparmor" | sed 's/^/  /'



grsecurity=$(((uname -r | grep "\-grsec" >/dev/null 2>&1 || grep "grsecurity" /etc/sysctl.conf >/dev/null 2>&1) && echo "Yes" || echo "Not found grsecurity")
)
echo -e "\e[33mThông tin về cơ chế phòng thủ Grsecurity:\e[0m"
echo "$grsecurity" | sed 's/^/  /'


selinux=$( (sestatus 2>/dev/null || echo "Not found sestatus") )
echo -e "\e[31mThông tin về cơ chế phòng thủ SElinux:\e[0m"
echo "$selinux" | sed 's/^/  /'



allsuid=`find / -perm -4000 -type f 2>/dev/null`
findsuid=`find $allsuid -perm -4000 -type f -exec ls -la {} 2>/dev/null \;`
if [ "$findsuid" ]; then
  echo -e "\e[00;31m[-] SUID files:\e[00m\n$findsuid"
  echo -e "\n"
fi


crontab=$( cat /etc/cron* /etc/at* /etc/anacrontab /var/spool/cron/crontabs/root 2>/dev/null | grep -v "^#" )
echo -e "\e[33mThông tin về chức năng lên lịch:\e[0m"
echo "$crontab" | sed 's/^/  /'

tepdoi=$( find / -type f -mmin -5 ! -path "/proc/*" ! -path "/sys/*" ! -path "/run/*" ! -path "/dev/*" ! -path "/var/lib/*" 2>/dev/null )
echo -e "\e[31mThông tin về tệp được sửa đổi gần đây:\e[0m"
echo "$tepdoi" | sed 's/^/  /'


crontab=$( find / -name '*.db' -o -name '*.sqlite' -o -name '*.sqlite3' 2>/dev/null )
echo -e "\e[34mTìm file liên quan tới sqiite db:\e[0m"
echo "$crontab" | sed 's/^/  /'



intsuid=`find $allsuid -perm -4000 -type f -exec ls -la {} \; 2>/dev/null | grep -w $binarylist 2>/dev/null`
if [ "$intsuid" ]; then
  echo -e "\e[00;33m[+] Possibly interesting SUID files:\e[00m\n$intsuid"
  echo -e "\n"
fi