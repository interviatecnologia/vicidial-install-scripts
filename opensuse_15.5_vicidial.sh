#!/bin/sh

echo "Vicidial installation Opensuse Leap-15.5"

timedatectl set-timezone America/Sao_Paulo

### Global node configuration, applicable to any server role

# Export a usable path so things work right
PATH="/sbin:/usr/sbin:/usr/local/sbin:/root/bin:/usr/local/bin:/usr/bin:/bin"
export PATH
cd /tmp # Go somewhere safe

# If we are in debug, then give useful wget and CLI output, otherwise be quiet about it
WGET="wget -nv"
ZYPPER='zypper'
if [ "${0}" == "debug" ]; then
	WGET="wget"
	ZYPPER='zypper'
fi

# Simple check for directory, make if doesn't exist subversion
function checkdir {
	if [ ! -d $1 ]; then
		echo -n " Creating dir $1..."
		mkdir -p $1
		echo "done."
	fi
}

# Checks to see if the file exists in the current directory unless directory is supplied, and then downloads it
function checkget {
	# Check to see if we are supplied a target directory, otherwise assume current directory
	if [ -z "$2" ]; then
		LOCALDIR="$PWD"
	else
		LOCALDIR="$2"
	fi
	
	# Make sure directory exists
	checkdir "$LOCALDIR"
	cd $LOCALDIR
	
	# And now check for our file and download if it's not there
	FILE="${1##*/}"
	if [ ! -f $FILE ]; then
		echo -n " Downloading $1..."
		$WGET $1 -O $PWD/$FILE
		echo "done."
	fi
	
	# If we were provided a file mask, apply it
	if [ ! -z "$3" ]; then
		chmod $3 $PWD/$FILE
	fi
}

# Sometimes the CD gets left in as a repo, so check and remove it
CDTEST=`zypper lr --url | grep cd: | awk '{split($0,a,"|"); print a[1]}'`
if [ ! -z "$CDTEST" ]; then
        echo "Removing CD-Rom repository"
		$ZYPPER rr $CDTEST
fi

# Add repositories
$ZYPPER ar https://download.opensuse.org/repositories/home:/vicidial/openSUSE_Leap_15.5/home:vicidial.repo
$ZYPPER ar https://download.opensuse.org/repositories/home:/vicidial:/asterisk-16/openSUSE_Leap_15.5/home:vicidial:asterisk-16.repo
$ZYPPER ar https://download.opensuse.org/repositories/home:/vicidial:/vicibox/openSUSE_Leap_15.5/home:vicidial:vicibox.repo 
$ZYPPER ar https://download.opensuse.org/repositories/devel:/languages:/perl/15.5/devel:languages:perl.repo
$ZYPPER ar https://mirrorcache-us.opensuse.org/repositories/devel:/languages:/php/openSUSE_Leap_15.5/devel:languages:php.repo
$ZYPPER ar https://mirrorcache-us.opensuse.org/repositories/devel:/languages:/python:/azure/15.5/devel:languages:python:azure.repo
$ZYPPER ar https://mirrorcache-us.opensuse.org/update/leap/15.5/oss/openSUSE:Leap:15.5:Update.repo
$ZYPPER ar https://download.opensuse.org/repositories/home:/zippy:/jx:/packages-ready/15.5/home:zippy:jx:packages-ready.repo
$ZYPPER ar https://download.opensuse.org/repositories/home:interstar001:Centreon/15.5/home:interstar001:Centreon.repo

$ZYPPER --gpg-auto-import-keys refresh
$ZYPPER --non-interactive in -t pattern lamp_server
$ZYPPER --non-interactive in home_vicidial:libjansson4
$ZYPPER --non-interactive in adaptec-firmware aggregate apache2-mod_cband asterisk-dahdi bmon ddclient dhcp-client digitemp extundelete fonts-config git gnu_ddrescue htop iftop iotop iprelay iptraf-ng lame lshw lvm2 memtest86+ mlocate mpt-firmware mtop mtr mydumper mytop ncftp net-tools-deprecated ngrep-sip nmap numad ntp openr2 OpenIPMI patch pcapsipdump perl-MIME-Lite perl-Net-SFTP-Foreign perl-MySQL-Diff perl-Term-ANSIColor phpMyAdmin php7-opcache pico ploticus python-eyeD3 recode sensord sensors sipp shim sngrep sshfs stress-ng sysstat tcpdump telnet vicibox-dynportal vicibox-firewall vicibox-install vicibox-ssl voicesync-kmp-default vsftpd zip
$ZYPPER --non-interactive up

$ZYPPER in php screen php-mcrypt php-cli php-gd php-curl php-mysql php-ldap php-zip php-fileinfo php-opcache php php-devel gd-devel readline-devel php-mbstring
$ZYPPER in php-imap php-ldap php-mysqli php-odbc php-pear php-xml php-xmlrpc curl curl-devel perl-libwww-perl ImageMagick 
$ZYPPER in wget unzip make patch gcc gcc-c++ subversion
$ZYPPER in newt-devel libxml2-devel kernel-devel sqlite-devel libuuid-devel sox sendmail lame-devel htop iftop perl-File-Which
$ZYPPER in libss7 libss7* libopen*
$ZYPPER in httpd libpcap libpcap-devel libnet ncurses ncurses-devel screen mysql-devel ntp mutt nano sipsak
$ZYPPER in mariadb-server mariadb  mariadb-devel
$ZYPPER in sqlite-devel httpd mod_ssl chkconfig htop atop mytop iftop
$ZYPPER in libedit-devel uuid* libxml2* speex*
$ZYPPER in libsrtp-devel elfutils-libelf-devel libedit-devel
$ZYPPER in httpd php-common php-pdo mod_ssl perl-DBI perl-DBD-MySQL perl-Digest-HMAC perl-YAML
$ZYPPER in perl-ExtUtils-ParseXS perl-NetAddr-IP perl-Crypt-SSLeay perl-Curses perl-DBD-Pg perl-Module-ScanDeps perl-Text-CSV perl-HTML-Template perl-IO-Compress perl-Text-Glob perl-Jcode perl-Test-Script perl-Archive-Tar perl-Test-Base perl-OLE-Storage_Lite perl-Archive-Zip perl-Net-Server perl-Convert-ASN1 perl perl-Compress-Raw-Zlib perl-Digest-SHA1 perl-Data-Dumper perl-Error perl-ExtUtils-CBuilder perl-Test-Tester perl-Parse-RecDescent perl-Spiffy perl-IO-Zlib perl-Module-Build perl-HTML-Parser perl-Net-SSLeay perl-Proc-ProcessTable perl-TermReadKey perl-Term-ReadLine-Gnu perl-Digest-SHA perl-Tk perl-Net-SNMP perl-Test-NoWarnings perl-XML-Writer perl-Proc-PID-File perl-Compress-Raw-Bzip2 perl-libwww-perl perl-XML-Parser perl-File-Remove perl-Parse-CPAN-Meta perl-Set-Scalar perl-Probe-Perl perl-File-Which perl-Package-Constants perl-Module-Install perl-File-HomeDir perl-Spreadsheet-ParseExcel perl-Mail-Sendmail
$ZYPPER in perl-Spreadsheet-XLSX asterisk-perl perl-version perl-Crypt-DES perl-URI perl-Net-Daemon perl-IO-stringy perl-YAML-Tiny perl-HTML-Tagset perl-Socket6 perl-BSD-Resource perl-IPC-Run3 perl-Text-CSV_XS perl-Unicode-Map perl-Net-Telnet perl-PAR-Dist perl-Date-Manip perl-JSON perl-rrdtool lame screen iftop dahdi-linux-devel perl-GD

systemctl enable mariadb

cp /etc/my.cnf /etc/my.cnf.original
echo "" > /etc/my.cnf

cat <<MYSQLCONF>> /etc/my.cnf
[mysql.server]
user = mysql
#basedir = /var/lib

[client]
port = 3306
socket = /var/lib/mysql/mysql.sock

[mysqld]
datadir = /var/lib/mysql
#tmpdir = /home/mysql_tmp
socket = /var/lib/mysql/mysql.sock
user = mysql
old_passwords = 0
ft_min_word_len = 3
max_connections = 800
max_allowed_packet = 32M
skip-external-locking
sql_mode="NO_ENGINE_SUBSTITUTION"

log-error = /var/log/mysqld/mysqld.log

query-cache-type = 1
query-cache-size = 32M

long_query_time = 1
#slow_query_log = 1
#slow_query_log_file = /var/log/mysqld/slow-queries.log

tmp_table_size = 128M
table_cache = 1024

join_buffer_size = 1M
key_buffer = 512M
sort_buffer_size = 6M
read_buffer_size = 4M
read_rnd_buffer_size = 16M
myisam_sort_buffer_size = 64M

max_tmp_tables = 64

thread_cache_size = 8
thread_concurrency = 8

# If using replication, uncomment log-bin below
#log-bin = mysql-bin

[mysqldump]
quick
max_allowed_packet = 16M

[mysql]
no-auto-rehash

[isamchk]
key_buffer = 256M
sort_buffer_size = 256M
read_buffer = 2M
write_buffer = 2M

[myisamchk]
key_buffer = 256M
sort_buffer_size = 256M
read_buffer = 2M
write_buffer = 2M

[mysqlhotcopy]
interactive-timeout

[mysqld_safe]
#log-error = /var/log/mysqld/mysqld.log
#pid-file = /var/run/mysqld/mysqld.pid
MYSQLCONF

mkdir /var/log/mysqld
touch /var/log/mysqld/slow-queries.log
chown -R mysql:mysql /var/log/mysqld
systemctl restart mariadb

systemctl enable apache2
systemctl enable mariadb.service
systemctl restart apache2
systemctl restart mariadb.service


###preparing for the next part with MCPAN
perl -MCPAN -e 'my $c = "CPAN::HandleConfig"; $c->load(doit => 1, autoconfig => 1); $c->edit(prerequisites_policy => "follow"); $c->edit(build_requires_install_policy => "yes"); $c->commit'

cpan -i String::CRC Tk::TableMatrix Net::Address::IP::Local Term::ReadLine::Gnu Spreadsheet::Read Net::Address::IPv4::Local RPM::Specfile Spreadsheet::XLSX Spreadsheet::ReadSXC

cpan MD5 Digest::MD5 Digest::SHA1 Bundle::CPAN Pod::Usage Getopt::Long DBI DBD::mysql Net::Telnet Time::HiRes Net::Server Mail::Sendmail Unicode::Map Jcode Spreadsheet::WriteExcel OLE::Storage_Lite Proc::ProcessTable IO::Scalar Scalar::Util Spreadsheet::ParseExcel Archive::Zip Compress::Raw::Zlib Spreadsheet::XLSX Test::Tester Spreadsheet::ReadSXC Text::CSV Test::NoWarnings Text::CSV_PP File::Temp Text::CSV_XS Spreadsheet::Read LWP::UserAgent HTML::Entities HTML::Strip HTML::FormatText HTML::TreeBuilder Switch Time::Local MIME::POP3Client Mail::IMAPClient Mail::Message IO::Socket::SSL readline

###copy and paste this at the same time:

cd /usr/bin/

curl -LOk http://xrl.us/cpanm
chmod +x cpanm
cpanm -f File::Which
cpanm -f File::HomeDir
cpanm CPAN::Meta::Requirements
cpanm -f CPAN
cpanm YAML
cpanm MD5
cpanm Digest::MD5
cpanm Digest::SHA1
cpanm Bundle::CPAN
cpanm -f DBD::mysql
cpanm Curses
cpanm Getopt::Long
cpanm Net::Domain
cpanm Term::ReadKey
cpanm Term::ANSIColor
cpanm HTML::FormatText
cpanm MIME::Decoder
cpanm Mail::POP3Client
cpanm User::Identity –force
cpanm Mail::Message
cpanm Crypt::Eksblowfish::Bcrypt

#Install Perl Modules

echo "Install Perl"

zypper in perl-CPAN perl-YAML perl-CPAN-DistnameInfo perl-libwww-perl perl-DBI perl-DBD-MySQL perl-GD perl-Env perl-Term-ReadLine-Gnu perl-SelfLoader perl-open.noarch 

#####CPM install
#cd /usr/src/vicidial-install-scripts
#curl -fsSL https://raw.githubusercontent.com/skaji/cpm/main/cpm | perl - install -g App::cpm
#/usr/local/bin/cpm install -g

#Install Asterisk Perl
cd /usr/src
wget http://download.vicidial.com/required-apps/asterisk-perl-0.08.tar.gz
tar xzf asterisk-perl-0.08.tar.gz
cd asterisk-perl-0.08
perl Makefile.PL
make all
make install 

#Install Lame
cd /usr/src
wget http://downloads.sourceforge.net/project/lame/lame/3.99/lame-3.99.5.tar.gz
tar -zxf lame-3.99.5.tar.gz
cd lame-3.99.5
./configure
make
make install


#Install Jansson
cd /usr/src/
wget https://digip.org/jansson/releases/jansson-2.13.tar.gz
tar xvzf jansson*
cd jansson-2.13
./configure
make clean
make
make install 
ldconfig

##########################################################################################################################################

***Install Dadhi and libpri

cd /usr/src
wget https://downloads.asterisk.org/pub/telephony/libpri/libpri-1.6.1.tar.gz
wget http://downloads.asterisk.org/pub/telephony/dahdi-linux-complete/dahdi-linux-complete-current.tar.gz
tar xzf dahdi-linux-complete-*
tar xzf libpri-*

cd /usr/src/dahdi-linux-complete-3.4.0+3.4.0/   
Step 2 – Download kernel update and needed compile tools
zypper in autoconf gcc make libtool
zypper in *kernel-default*
##Press 2 when it gives you options

reboot
####################################################################################

Step 3 – Compile Dahdi
Run the following commands:

cd /usr/src/dahdi-linux-complete-3.4.0+3.4.0/  
make
make install
make install-config
cd tools
make clean
make
make install
make install-config
cp /etc/dahdi/system.conf.sample /etc/dahdi/system.conf

Step 4 – Run modprobe for dahdi and check to make sure its working
modprobe dahdi
dahdi_cfg -v

cd /usr/src/libpri-1.6.1/
make
make install
make install-config

read -p 'Press Enter to continue: '

echo 'Continuing...'

#Install Asterisk 
cd /usr/src
wget https://download.vicidial.com/required-apps/asterisk-16.30.1-vici.tar.gz
tar -xvzf asterisk-16.30.1-vici

cd /usr/src
wget https://github.com/cisco/libsrtp/archive/v2.1.0.tar.gz
tar xfv v2.1.0.tar.gz
cd libsrtp-2.1.0
./configure --prefix=/usr --enable-openssl
make shared_library && sudo make install
ldconfig

cd /usr/src/asterisk-16.30.1-vici

: ${JOBS:=$(( $(nproc) + $(nproc) / 2 ))}
./configure --libdir=/usr/lib64 --with-gsm=internal --enable-opus --enable-srtp --with-ssl --enable-asteriskssl --with-pjproject-bundled --with-jansson-bundled

make menuselect/menuselect menuselect-tree menuselect.makeopts
#enable app_meetme
menuselect/menuselect --enable app_meetme menuselect.makeopts
#enable res_http_websocket
menuselect/menuselect --enable res_http_websocket menuselect.makeopts
#enable res_srtp
menuselect/menuselect --enable res_srtp menuselect.makeopts
make -j ${JOBS} all
make install
make samples
make basic-pbx

read -p 'Press Enter to continue: '

echo 'Continuing...'

#Install astguiclient
echo "Installing astguiclient"
mkdir /usr/src/astguiclient
cd /usr/src/astguiclient
svn checkout svn://svn.eflo.net/agc_2-X/trunk
cd /usr/src/astguiclient/trunk

#Add mysql users and Databases
echo "%%%%%%%%%%%%%%%Please Enter Mysql Password Or Just Press Enter if you Dont have Password%%%%%%%%%%%%%%%%%%%%%%%%%%"
mysql -u root -p << MYSQLCREOF
CREATE DATABASE asterisk DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
CREATE USER 'cron'@'localhost' IDENTIFIED BY '1234';
GRANT SELECT,CREATE,ALTER,INSERT,UPDATE,DELETE,LOCK TABLES on asterisk.* TO cron@'%' IDENTIFIED BY '1234';
GRANT SELECT,CREATE,ALTER,INSERT,UPDATE,DELETE,LOCK TABLES on asterisk.* TO cron@localhost IDENTIFIED BY '1234';
GRANT RELOAD ON *.* TO cron@'%';
GRANT RELOAD ON *.* TO cron@localhost;
CREATE USER 'custom'@'localhost' IDENTIFIED BY 'custom1234';
GRANT SELECT,CREATE,ALTER,INSERT,UPDATE,DELETE,LOCK TABLES on asterisk.* TO custom@'%' IDENTIFIED BY 'custom1234';
GRANT SELECT,CREATE,ALTER,INSERT,UPDATE,DELETE,LOCK TABLES on asterisk.* TO custom@localhost IDENTIFIED BY 'custom1234';
GRANT RELOAD ON *.* TO custom@'%';
GRANT RELOAD ON *.* TO custom@localhost;
flush privileges;

SET GLOBAL connect_timeout=60;

use asterisk;
\. /usr/src/astguiclient/trunk/extras/MySQL_AST_CREATE_tables.sql
\. /usr/src/astguiclient/trunk/extras/first_server_install.sql
update servers set asterisk_version='16.30.1';
quit
MYSQLCREOF


####################################################

####ALTERNATIVA 1

chmod 777 install.pl
/usr/src/astguiclient/trunk/install.pl
/usr/share/astguiclient/start_asterisk_boot.pl

chmod 777 ADMIN_area_code_populate.pl
/usr/share/astguiclient/ADMIN_area_code_populate.pl
chmod 777 ADMIN_update_server_ip.pl
/usr/src/astguiclient/trunk/bin/ADMIN_update_server_ip.pl

##### ALTERNATIVA 2

read -p 'Press Enter to continue: '

echo 'Continuing...'

#Get astguiclient.conf file
cat <<ASTGUI>> /etc/astguiclient.conf
# astguiclient.conf - configuration elements for the astguiclient package
# this is the astguiclient configuration file
# all comments will be lost if you run install.pl again

# Paths used by astGUIclient
PATHhome => /usr/share/astguiclient
PATHlogs => /var/log/astguiclient
PATHagi => /var/lib/asterisk/agi-bin
PATHweb => /usr/local/apache2/htdocs  ####  /var/www/html ( CENTOS )
PATHsounds => /var/lib/asterisk/sounds
PATHmonitor => /var/spool/asterisk/monitor
PATHDONEmonitor => /var/spool/asterisk/monitorDONE

# The IP address of this machine
VARserver_ip => SERVERIP

# Database connection information
VARDB_server => localhost
VARDB_database => asterisk
VARDB_user => cron
VARDB_pass => 1234
VARDB_custom_user => custom
VARDB_custom_pass => custom1234
VARDB_port => 3306

# Alpha-Numeric list of the astGUIclient processes to be kept running
# (value should be listing of characters with no spaces: 123456)
#  X - NO KEEPALIVE PROCESSES (use only if you want none to be keepalive)
#  1 - AST_update
#  2 - AST_send_listen
#  3 - AST_VDauto_dial
#  4 - AST_VDremote_agents
#  5 - AST_VDadapt (If multi-server system, this must only be on one server)
#  6 - FastAGI_log
#  7 - AST_VDauto_dial_FILL (only for multi-server, this must only be on one server)
#  8 - ip_relay (used for blind agent monitoring)
#  9 - Timeclock auto logout
#  E - Email processor, (If multi-server system, this must only be on one server)
#  S - SIP Logger (Patched Asterisk 13 required)
VARactive_keepalives => 12345689EC

# Asterisk version VICIDIAL is installed for
VARasterisk_version => 16.X

# FTP recording archive connection information
VARFTP_host => 10.0.0.4
VARFTP_user => cron
VARFTP_pass => test
VARFTP_port => 21
VARFTP_dir => RECORDINGS
VARHTTP_path => http://10.0.0.4

# REPORT server connection information
VARREPORT_host => 10.0.0.4
VARREPORT_user => cron
VARREPORT_pass => test
VARREPORT_port => 21
VARREPORT_dir => REPORTS

# Settings for FastAGI logging server
VARfastagi_log_min_servers => 3
VARfastagi_log_max_servers => 16
VARfastagi_log_min_spare_servers => 2
VARfastagi_log_max_spare_servers => 8
VARfastagi_log_max_requests => 1000
VARfastagi_log_checkfordead => 30
VARfastagi_log_checkforwait => 60

# Expected DB Schema version for this install
ExpectedDBSchema => 1645
ASTGUI

echo "Replace IP address in Default"
echo "%%%%%%%%%Please Enter This Server IP ADD%%%%%%%%%%%%"
read serveripadd
sed -i s/SERVERIP/"$serveripadd"/g /etc/astguiclient.conf

echo "Install VICIDIAL"
perl install.pl --no-prompt --copy_sample_conf_files=Y

#Secure Manager 
sed -i s/0.0.0.0/127.0.0.1/g /etc/asterisk/manager.conf


echo "Populate AREA CODES"
/usr/share/astguiclient/ADMIN_area_code_populate.pl
echo "Replace OLD IP. You need to Enter your Current IP here"
/usr/share/astguiclient/ADMIN_update_server_ip.pl --old-server_ip=10.10.10.15


perl install.pl --no-prompt


#Install Crontab
cat <<CRONTAB>> /root/crontab-file

###certbot renew
51 23 1 * * /usr/bin/systemctl stop firewalld
52 23 1 * * /usr/sbin/certbot renew
53 23 1 * * /usr/bin/systemctl start firewalld
54 23 1 * * /usr/bin/systemctl restart httpd

### recording mixing/compressing/ftping scripts
#0,3,6,9,12,15,18,21,24,27,30,33,36,39,42,45,48,51,54,57 * * * * /usr/share/astguiclient/AST_CRON_audio_1_move_mix.pl
0,3,6,9,12,15,18,21,24,27,30,33,36,39,42,45,48,51,54,57 * * * * /usr/share/astguiclient/AST_CRON_audio_1_move_mix.pl --MIX
0,3,6,9,12,15,18,21,24,27,30,33,36,39,42,45,48,51,54,57 * * * * /usr/share/astguiclient/AST_CRON_audio_1_move_VDonly.pl
1,4,7,10,13,16,19,22,25,28,31,34,37,40,43,46,49,52,55,58 * * * * /usr/share/astguiclient/AST_CRON_audio_2_compress.pl --MP3 --HTTPS
#2,5,8,11,14,17,20,23,26,29,32,35,38,41,44,47,50,53,56,59 * * * * /usr/share/astguiclient/AST_CRON_audio_3_ftp.pl --MP3

### keepalive script for astguiclient processes
* * * * * /usr/share/astguiclient/ADMIN_keepalive_ALL.pl --cu3way

### kill Hangup script for Asterisk updaters
* * * * * /usr/share/astguiclient/AST_manager_kill_hung_congested.pl

### updater for voicemail
* * * * * /usr/share/astguiclient/AST_vm_update.pl

### updater for conference validator
* * * * * /usr/share/astguiclient/AST_conf_update.pl

### flush queue DB table every hour for entries older than 1 hour
11 * * * * /usr/share/astguiclient/AST_flush_DBqueue.pl -q

### fix the vicidial_agent_log once every hour and the full day run at night
33 * * * * /usr/share/astguiclient/AST_cleanup_agent_log.pl
50 0 * * * /usr/share/astguiclient/AST_cleanup_agent_log.pl --last-24hours

## uncomment below if using QueueMetrics
#*/5 * * * * /usr/share/astguiclient/AST_cleanup_agent_log.pl --only-qm-live-call-check

## uncomment below if using Vtiger
#1 1 * * * /usr/share/astguiclient/Vtiger_optimize_all_tables.pl --quiet

### updater for VICIDIAL hopper
* * * * * /usr/share/astguiclient/AST_VDhopper.pl -q

### adjust the GMT offset for the leads in the vicidial_list table
1 1,7 * * * /usr/share/astguiclient/ADMIN_adjust_GMTnow_on_leads.pl --debug

### reset several temporary-info tables in the database
2 1 * * * /usr/share/astguiclient/AST_reset_mysql_vars.pl

### optimize the database tables within the asterisk database
3 1 * * * /usr/share/astguiclient/AST_DB_optimize.pl

## adjust time on the server with ntp
#30 * * * * /usr/sbin/ntpdate -u pool.ntp.org 2>/dev/null 1>&amp;2

### VICIDIAL agent time log weekly and daily summary report generation
2 0 * * 0 /usr/share/astguiclient/AST_agent_week.pl
22 0 * * * /usr/share/astguiclient/AST_agent_day.pl

### VICIDIAL campaign export scripts (OPTIONAL)
#32 0 * * * /usr/share/astguiclient/AST_VDsales_export.pl
#42 0 * * * /usr/share/astguiclient/AST_sourceID_summary_export.pl

### remove old recordings
#24 0 * * * /usr/bin/find /var/spool/asterisk/monitorDONE -maxdepth 2 -type f -mtime +7 -print | xargs rm -f
#26 1 * * * /usr/bin/find /var/spool/asterisk/monitorDONE/MP3 -maxdepth 2 -type f -mtime +65 -print | xargs rm -f
#25 1 * * * /usr/bin/find /var/spool/asterisk/monitorDONE/FTP -maxdepth 2 -type f -mtime +1 -print | xargs rm -f
24 1 * * * /usr/bin/find /var/spool/asterisk/monitorDONE/ORIG -maxdepth 2 -type f -mtime +1 -print | xargs rm -f


### roll logs monthly on high-volume dialing systems
#30 1 1 * * /usr/share/astguiclient/ADMIN_archive_log_tables.pl

### remove old vicidial logs and asterisk logs more than 2 days old
28 0 * * * /usr/bin/find /var/log/astguiclient -maxdepth 1 -type f -mtime +2 -print | xargs rm -f
29 0 * * * /usr/bin/find /var/log/asterisk -maxdepth 3 -type f -mtime +2 -print | xargs rm -f
30 0 * * * /usr/bin/find / -maxdepth 1 -name "screenlog.0*" -mtime +4 -print | xargs rm -f

### cleanup of the scheduled callback records
25 0 * * * /usr/share/astguiclient/AST_DB_dead_cb_purge.pl --purge-non-cb -q

### GMT adjust script - uncomment to enable
#45 0 * * * /usr/share/astguiclient/ADMIN_adjust_GMTnow_on_leads.pl --list-settings

### Dialer Inventory Report
1 7 * * * /usr/share/astguiclient/AST_dialer_inventory_snapshot.pl -q --override-24hours

### inbound email parser
* * * * * /usr/share/astguiclient/AST_inbound_email_parser.pl

### Daily Reboot
#30 6 * * * /sbin/reboot

######TILTIX GARBAGE FILES DELETE
#00 22 * * * root cd /tmp/ && find . -name '*TILTXtmp*' -type f -delete

### Dynportal
###@reboot /usr/bin/VB-firewall --whitelist=ViciWhite --dynamic --quiet
###* * * * * /usr/bin/VB-firewall --whitelist=ViciWhite --dynamic --quiet
###* * * * * /usr/bin/VB-firewall --white --dynamic --quiet
###* * * * * sleep 10; /usr/bin/VB-firewall --white --dynamic --quiet
###* * * * * sleep 20; /usr/bin/VB-firewall --white --dynamic --quiet
###* * * * * sleep 30; /usr/bin/VB-firewall --white --dynamic --quiet
###* * * * * sleep 40; /usr/bin/VB-firewall --white --dynamic --quiet
###* * * * * sleep 50; /usr/bin/VB-firewall --white --dynamic --quiet

CRONTAB

crontab /root/crontab-file
crontab -l

#Install rc.local

#########################################
nano /etc/rc.local

### paste this below: 

### paste this below: 

#!/bin/sh
#
# This script will be executed *after* all the other init scripts.
# You can put your own initialization stuff in here if you don't
# want to do the full Sys V style init stuff.

touch /var/lock/subsys/local

# OPTIONAL enable ip_relay(for same-machine trunking and blind monitoring)
/usr/share/astguiclient/ip_relay/relay_control start 2>/dev/null 1>&2

# Disable console blanking and powersaving
/usr/bin/setterm -blank
/usr/bin/setterm -powersave off
/usr/bin/setterm -powerdown

### start up the MySQL server
systemctl start mariadb.service
systemctl enable mariadb.service

### start up the apache web server
systemctl start apache2
systemctl enable apache2

### roll the Asterisk logs upon reboot
/usr/share/astguiclient/ADMIN_restart_roll_logs.pl

### clear the server-related records from the database
/usr/share/astguiclient/AST_reset_mysql_vars.pl

### load dahdi drivers
modprobe dahdi
/usr/sbin/dahdi_cfg -vvvvvvvvvvvvv

### sleep for 20 seconds before launching Asterisk
sleep 20

### start up asterisk
/usr/share/astguiclient/start_asterisk_boot.pl


############## END PASTE HERE ##################


####################################################################END###############################################
##Fix ip_relay
cd /usr/src/astguiclient/trunk/extras/ip_relay/
unzip ip_relay_1.1.112705.zip
cd ip_relay_1.1/src/unix/
make
cp ip_relay ip_relay2
mv -f ip_relay /usr/bin/
mv -f ip_relay2 /usr/local/bin/ip_relay

cd /usr/lib64/asterisk/modules
wget http://asterisk.hosting.lv/bin/codec_g729-ast160-gcc4-glibc-x86_64-core2-sse4.so
mv codec_g729-ast160-gcc4-glibc-x86_64-core2-sse4.so codec_g729.so
chmod 777 codec_g729.so

tee -a /etc/httpd/conf/httpd.conf <<EOF

CustomLog /dev/null common

Alias /RECORDINGS/MP3 "/var/spool/asterisk/monitorDONE/MP3/"

<Directory "/var/spool/asterisk/monitorDONE/MP3/">
    Options Indexes MultiViews
    AllowOverride None
    Require all granted
</Directory>
EOF

##Install Sounds

cd /usr/src
wget http://downloads.asterisk.org/pub/telephony/sounds/asterisk-core-sounds-en-ulaw-current.tar.gz
wget http://downloads.asterisk.org/pub/telephony/sounds/asterisk-core-sounds-en-wav-current.tar.gz
wget http://downloads.asterisk.org/pub/telephony/sounds/asterisk-core-sounds-en-gsm-current.tar.gz
wget http://downloads.asterisk.org/pub/telephony/sounds/asterisk-extra-sounds-en-ulaw-current.tar.gz
wget http://downloads.asterisk.org/pub/telephony/sounds/asterisk-extra-sounds-en-wav-current.tar.gz
wget http://downloads.asterisk.org/pub/telephony/sounds/asterisk-extra-sounds-en-gsm-current.tar.gz
wget http://downloads.asterisk.org/pub/telephony/sounds/asterisk-moh-opsound-gsm-current.tar.gz
wget http://downloads.asterisk.org/pub/telephony/sounds/asterisk-moh-opsound-ulaw-current.tar.gz
wget http://downloads.asterisk.org/pub/telephony/sounds/asterisk-moh-opsound-wav-current.tar.gz

#Place the audio files in their proper places:
cd /var/lib/asterisk/sounds
tar -zxf /usr/src/asterisk-core-sounds-en-gsm-current.tar.gz
tar -zxf /usr/src/asterisk-core-sounds-en-ulaw-current.tar.gz
tar -zxf /usr/src/asterisk-core-sounds-en-wav-current.tar.gz
tar -zxf /usr/src/asterisk-extra-sounds-en-gsm-current.tar.gz
tar -zxf /usr/src/asterisk-extra-sounds-en-ulaw-current.tar.gz
tar -zxf /usr/src/asterisk-extra-sounds-en-wav-current.tar.gz

mkdir /var/lib/asterisk/mohmp3
mkdir /var/lib/asterisk/quiet-mp3
ln -s /var/lib/asterisk/mohmp3 /var/lib/asterisk/default

cd /var/lib/asterisk/mohmp3
tar -zxf /usr/src/asterisk-moh-opsound-gsm-current.tar.gz
tar -zxf /usr/src/asterisk-moh-opsound-ulaw-current.tar.gz
tar -zxf /usr/src/asterisk-moh-opsound-wav-current.tar.gz
rm -f CHANGES*
rm -f LICENSE*
rm -f CREDITS*

cd /var/lib/asterisk/moh
rm -f CHANGES*
rm -f LICENSE*
rm -f CREDITS*

cd /var/lib/asterisk/sounds
rm -f CHANGES*
rm -f LICENSE*
rm -f CREDITS*

cd /var/lib/asterisk/quiet-mp3
sox ../mohmp3/macroform-cold_day.wav macroform-cold_day.wav vol 0.25
sox ../mohmp3/macroform-cold_day.gsm macroform-cold_day.gsm vol 0.25
sox -t ul -r 8000 -c 1 ../mohmp3/macroform-cold_day.ulaw -t ul macroform-cold_day.ulaw vol 0.25
sox ../mohmp3/macroform-robot_dity.wav macroform-robot_dity.wav vol 0.25
sox ../mohmp3/macroform-robot_dity.gsm macroform-robot_dity.gsm vol 0.25
sox -t ul -r 8000 -c 1 ../mohmp3/macroform-robot_dity.ulaw -t ul macroform-robot_dity.ulaw vol 0.25
sox ../mohmp3/macroform-the_simplicity.wav macroform-the_simplicity.wav vol 0.25
sox ../mohmp3/macroform-the_simplicity.gsm macroform-the_simplicity.gsm vol 0.25
sox -t ul -r 8000 -c 1 ../mohmp3/macroform-the_simplicity.ulaw -t ul macroform-the_simplicity.ulaw vol 0.25
sox ../mohmp3/reno_project-system.wav reno_project-system.wav vol 0.25
sox ../mohmp3/reno_project-system.gsm reno_project-system.gsm vol 0.25
sox -t ul -r 8000 -c 1 ../mohmp3/reno_project-system.ulaw -t ul reno_project-system.ulaw vol 0.25
sox ../mohmp3/manolo_camp-morning_coffee.wav manolo_camp-morning_coffee.wav vol 0.25
sox ../mohmp3/manolo_camp-morning_coffee.gsm manolo_camp-morning_coffee.gsm vol 0.25
sox -t ul -r 8000 -c 1 ../mohmp3/manolo_camp-morning_coffee.ulaw -t ul manolo_camp-morning_coffee.ulaw vol 0.25

tee -a ~/.bashrc <<EOF

# Commands
/usr/share/astguiclient/ADMIN_keepalive_ALL.pl --cu3way
/usr/bin/systemctl status httpd --no-pager
/usr/bin/systemctl status firewalld --no-pager
/usr/bin/screen -ls
/usr/sbin/dahdi_cfg -v
/usr/sbin/asterisk -V
EOF

#add rc-local as a service - thx to ras
tee -a /etc/systemd/system/rc-local.service <<EOF
[Unit]
Description=/etc/rc.local Compatibility

[Service]
Type=oneshot
ExecStart=/etc/rc.local
TimeoutSec=0
StandardInput=tty
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

##fstab entry
tee -a /etc/fstab <<EOF
none /var/spool/asterisk/monitor tmpfs nodev,nosuid,noexec,nodiratime,size=500M 0 0
EOF

systemctl daemon-reload
sudo systemctl enable rc-local.service
sudo systemctl start rc-local.service

#cat <<WELCOME>> /var/www/html/index.html
#<META HTTP-EQUIV=REFRESH CONTENT="1; URL=/vicidial/welcome.php">
#Please Hold while I redirect you!
#WELCOME

chmod 777 /var/spool/asterisk/monitorDONE
##chkconfig asterisk off

zypper in certbot 
systemctl enable certbot-renew.timer
systemctl start certbot-renew.timer
##cd /usr/src/vicidial-install-scripts
##chmod +x vicidial-enable-webrtc.sh
#service firewalld stop
##./vicidial-enable-webrtc.sh
#service firewalld start
#systemctl enable firewalld
systemctl enable rc-local

##mv /etc/httpd/conf.d/viciportal-ssl.conf /etc/httpd/conf.d/viciportal-ssl.conf.off

read -p 'Press Enter to Reboot: '

echo "Restarting"

reboot

##go to http://127.0.0.1/vicidial/admin.php
