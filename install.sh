#!/bin/bash

POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -a|--advanced)
    ADVANCED="y"
    shift
    ;;
    -n|--normal)
    ADVANCED="n"
    FAIL2BAN="y"
    UFW="y"
    BOOTSTRAP="y"
    shift
    ;;
    -i|--externalip)
    EXTERNALIP="$2"
    ARGUMENTIP="y"
    shift
    shift
    ;;
    -k|--privatekey)
    KEY="$2"
    shift
    shift
    ;;
    -f|--fail2ban)
    FAIL2BAN="y"
    shift
    ;;
    --no-fail2ban)
    FAIL2BAN="n"
    shift
    ;;
    -u|--ufw)
    UFW="y"
    shift
    ;;
    --no-ufw)
    UFW="n"
    shift
    ;;
    -b|--bootstrap)
    BOOTSTRAP="y"
    shift
    ;;
    --no-bootstrap)
    BOOTSTRAP="n"
    shift
    ;;
    -h|--help)
    cat << EOL

NORT Masternode installer arguments:

    -n --normal               : Run installer in normal mode
    -a --advanced             : Run installer in advanced mode
    -i --externalip <address> : Public IP address of VPS
    -k --privatekey <key>     : Private key to use
    -f --fail2ban             : Install Fail2Ban
    --no-fail2ban             : Don't install Fail2Ban
    -u --ufw                  : Install UFW
    --no-ufw                  : Don't install UFW
    -b --bootstrap            : Sync node using Bootstrap
    --no-bootstrap            : Don't use Bootstrap
    -h --help                 : Display this help text.

EOL
    exit
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

clear

# Set these to change the version of northern to install
TARBALLURL="https://github.com/northern-community/Northern/releases/download/3.3.1/northern_linux.3_3_1.tar.gz"
TARBALLNAME="northern_linux.3_3_1.tar.gz"
BOOTSTRAPURL=""
BOOTSTRAPARCHIVE=""
BWKVERSION="1.0.0"

#!/bin/bash

# Check if we are root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root." 1>&2
   exit 1
fi

# Install tools for dig and systemctl
echo "Preparing installation..."
apt-get install git dnsutils systemd -y > /dev/null 2>&1

# Check for systemd
systemctl --version >/dev/null 2>&1 || { echo "systemd is required. Are you using Ubuntu 16.04?"  >&2; exit 1; }

# CHARS is used for the loading animation further down.
CHARS="/-\|"
if [ -z "$EXTERNALIP" ]; then
EXTERNALIP=`dig +short myip.opendns.com @resolver1.opendns.com`
fi
clear

if [ -z "$ADVANCED" ]; then
echo "

    ___T_
   | o o |
   |__-__|
   /| []|\\
 ()/|___|\()
    |_|_|
    /_|_\  ------- MASTERNODE INSTALLER v2 -------+
 |                                                  |
 | You can choose between two installation options: |::
 |              default and advanced.               |::
 |                                                  |::
 |  The advanced installation will install and run  |::
 |   the masternode under a non-root user. If you   |::
 |   don't know what that means, use the default    |::
 |               installation method.               |::
 |                                                  |::
 |  Otherwise, your masternode will not work, and   |::
 | the NORT Team CANNOT assist you in repairing  |::
 |         it. You will have to start over.         |::
 |                                                  |::
 +------------------------------------------------+::
   ::::::::::::::::::::::::::::::::::::::::::::::::::

"

sleep 5
fi

if [ -z "$ADVANCED" ]; then
read -e -p "Use the Advanced Installation? [N/y] : " ADVANCED
fi

if [[ ("$ADVANCED" == "y" || "$ADVANCED" == "Y") ]]; then

USER=northern

adduser $USER --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password > /dev/null

INSTALLERUSED="#Used Advanced Install"

echo "" && echo 'Added user "northern"' && echo ""
sleep 1

else

USER=root
FAIL2BAN="y"
UFW="y"
BOOTSTRAP="n"
INSTALLERUSED="#Used Basic Install"
fi

USERHOME=`eval echo "~$USER"`

if [ -z "$ARGUMENTIP" ]; then
read -e -p "Server IP Address: " -i $EXTERNALIP -e IP
fi

if [ -z "$KEY" ]; then
read -e -p "Masternode Private Key (e.g. 7edfjLCUzGczZi3JQw8GHp434R9kNY33eFyMGeKRymkB56G4324h # THE KEY YOU GENERATED EARLIER) : " KEY
fi

if [ -z "$FAIL2BAN" ]; then
read -e -p "Install Fail2ban? [Y/n] : " FAIL2BAN
fi

if [ -z "$UFW" ]; then
read -e -p "Install UFW and configure ports? [Y/n] : " UFW
fi

if [ -z "$BOOTSTRAP" ]; then
read -e -p "Do you want to use our bootstrap file to speed the syncing process? [Y/n] : " BOOTSTRAP
fi

clear

# Generate random passwords
RPCUSER=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 12 | head -n 1)
RPCPASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

# update packages and upgrade Ubuntu
echo "Installing dependencies..."
apt-get -qq update
apt-get -qq upgrade
apt-get -qq autoremove
apt-get -qq install wget htop unzip
apt-get -qq install build-essential && apt-get -qq install libtool autotools-dev autoconf libevent-pthreads-2.0-5 automake && apt-get -qq install libssl-dev && apt-get -qq install libboost-all-dev && apt-get -qq install software-properties-common && add-apt-repository -y ppa:bitcoin/bitcoin && apt update && apt-get -qq install libdb4.8-dev && apt-get -qq install libdb4.8++-dev && apt-get -qq install libminiupnpc-dev && apt-get -qq install libqt4-dev libprotobuf-dev protobuf-compiler && apt-get -qq install libqrencode-dev && apt-get -qq install git && apt-get -qq install pkg-config && apt-get -qq install libzmq3-dev
apt-get -qq install aptitude
apt-get -qq install libevent-dev

# Install Fail2Ban
if [[ ("$FAIL2BAN" == "y" || "$FAIL2BAN" == "Y" || "$FAIL2BAN" == "") ]]; then
  aptitude -y -q install fail2ban
  service fail2ban restart
fi

# Install UFW
if [[ ("$UFW" == "y" || "$UFW" == "Y" || "$UFW" == "") ]]; then
  apt-get -qq install ufw
  ufw default deny incoming
  ufw default allow outgoing
  ufw allow ssh
  ufw allow 6942/tcp
  yes | ufw enable
fi

# Install NORT daemon
wget $TARBALLURL
tar -xzvf $TARBALLNAME 
rm $TARBALLNAME
mv ./northernd /usr/local/bin
mv ./northern-cli /usr/local/bin
mv ./northern-tx /usr/local/bin
rm -rf $TARBALLNAME

# Create .northern directory
mkdir $USERHOME/.northern

# Install bootstrap file
if [[ ("$BOOTSTRAP" == "y" || "$BOOTSTRAP" == "Y" || "$BOOTSTRAP" == "") ]]; then
  echo "skipping"
fi

# Create northern.conf
touch $USERHOME/.northern/northern.conf
cat > $USERHOME/.northern/northern.conf << EOL
${INSTALLERUSED}
rpcuser=${RPCUSER}
rpcpassword=${RPCPASSWORD}
rpcallowip=127.0.0.1
listen=1
server=1
daemon=1
logtimestamps=1
maxconnections=256
externalip=${IP}
bind=${IP}:6942
masternodeaddr=${IP}
masternodeprivkey=${KEY}
masternode=1
addnode=194.182.67.186
addnode=194.182.67.220
addnode=194.182.73.25
addnode=195.48.84.229
addnode=195.48.84.232
addnode=195.48.84.233
addnode=212.237.58.223
addnode=217.61.107.234
addnode=217.61.5.225
addnode=31.14.139.25
addnode=5.139.208.59
addnode=5.189.160.164
addnode=72.130.139.9
addnode=80.211.131.213
addnode=80.211.144.204
addnode=80.211.155.28
addnode=80.211.160.88
addnode=80.211.224.43
addnode=80.211.230.21
addnode=80.211.38.65
addnode=80.211.58.63
addnode=80.211.58.90
addnode=80.211.59.195
addnode=80.211.8.9
addnode=85.255.11.132
addnode=94.177.160.237
addnode=94.177.163.100
addnode=94.177.229.74
addnode=94.177.239.158
addnode=94.177.240.238
addnode=94.177.242.66
addnode=94.177.245.67
addnode=94.177.246.185
addnode=149.28.187.6
addnode=155.138.213.33
addnode=212.237.30.81
addnode=212.237.43.237
addnode=80.211.54.6
addnode=81.25.55.49
addnode=94.177.202.249
addnode=95.179.154.9
addnode=159.65.94.166
addnode=164.68.107.241
addnode=164.68.123.179
addnode=164.68.124.106
addnode=164.68.124.239
addnode=164.68.124.240
addnode=164.68.125.187
addnode=164.68.125.188
addnode=167.86.109.94
addnode=167.86.110.212
addnode=167.86.111.61
addnode=173.249.12.232
addnode=173.249.48.92
addnode=176.223.134.27
addnode=178.238.229.171
addnode=185.33.145.239
addnode=188.213.170.160
addnode=188.213.175.34
addnode=193.71.126.42
addnode=194.182.64.200
addnode=194.182.73.25
addnode=217.61.107.234
addnode=217.61.5.225
addnode=31.128.229.146
addnode=80.211.131.213
addnode=80.211.155.28
addnode=80.211.224.43
addnode=80.211.230.21
addnode=80.211.58.63
addnode=80.211.58.90
addnode=80.211.8.9
addnode=94.177.160.237
addnode=94.177.163.100
addnode=94.177.229.74
addnode=94.177.239.158
addnode=94.177.240.238
addnode=94.177.242.66
addnode=94.177.245.67
addnode=94.177.246.185
addnode=98.181.208.51
addnode=101.166.44.156
addnode=104.248.32.122
addnode=147.135.86.76
addnode=155.138.213.33
addnode=155.138.229.116
addnode=178.112.176.178
addnode=185.62.81.138
addnode=194.182.67.186
addnode=212.237.30.81
addnode=212.237.43.237
addnode=5.249.147.191
addnode=73.211.188.13
addnode=77.120.109.39
addnode=80.211.148.181
addnode=80.211.165.251
addnode=80.211.54.11
addnode=80.211.54.117
addnode=80.211.54.233
addnode=80.211.98.37
addnode=81.25.55.49
addnode=85.59.15.79
addnode=85.72.57.101
addnode=94.158.93.121
addnode=94.177.202.249
addnode=95.179.154.9

EOL
chmod 0600 $USERHOME/.northern/northern.conf
chown -R $USER:$USER $USERHOME/.northern

sleep 1

cat > /etc/systemd/system/northern.service << EOL
[Unit]
Description=northernd
After=network.target
[Service]
Type=forking
User=${USER}
WorkingDirectory=${USERHOME}
ExecStart=/usr/local/bin/northernd -conf=${USERHOME}/.northern/northern.conf -datadir=${USERHOME}/.northern
ExecStop=/usr/local/bin/northern-cli -conf=${USERHOME}/.northern/northern.conf -datadir=${USERHOME}/.northern stop
Restart=on-abort
[Install]
WantedBy=multi-user.target
EOL
sudo systemctl enable northern.service
sudo systemctl start northern.service

clear

cat << EOL

Now, you need to start your masternode. Please go to your desktop wallet
Click the Masternodes tab
Click Start all at the bottom 
EOL

read -p "Press Enter to continue after you've done that. " -n1 -s

clear

echo "" && echo "Masternode setup completed." && echo ""
