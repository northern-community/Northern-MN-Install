#!/bin/bash

#Setup Variables
GREEN='\033[0;32m'
YELLOW='\033[0;93m'
RED='\033[0;31m'
NC='\033[0m'



echo -e ${YELLOW}"Welcome to the Northern Automated Install, Durring this Process Please Hit Enter or Input What is Asked."${NC}
echo
echo -e ${YELLOW}"You Will See alot of code flashing across your screen, don't be alarmed it's supposed to do that. This process can take up to an hour and may appear to be stuck, but I can promise you it's not."${NC}
echo
echo -e ${GREEN}"Are you sure you want to install a Northern Masternode? type y/n followed by [ENTER]:"${NC}
read AGREE

if [[ $AGREE =~ "y" ]] ; then
echo -e ${GREEN}"Please Enter Your Masternodes Private Key for the first node:"${NC}
read privkey
echo -e ${GREEN}"Please Enter Your Masternodes Private Key for second node:"${NC}
read privkey2
echo -e ${GREEN}"Please Enter Your Masternodes Private Key for the third node:"${NC}
read privkey3
echo -e ${GREEN}"Please Enter Your Masternodes Private Key for 4th node:"${NC}
read privkey4
echo "Creating 4 Northern system users with no-login access:"
sudo adduser --system --home /home/northern northern
sudo adduser --system --home /home/northern2 northern2
sudo adduser --system --home /home/northern3 northern3
sudo adduser --system --home /home/northern4 northern4
sudo apt-get -y update 
sudo apt-get -y upgrade
sudo apt-get -y install software-properties-common 
sudo apt-get -y install build-essential  
sudo apt-get -y install libtool autotools-dev autoconf automake  
sudo apt-get -y install libssl-dev 
sudo apt-get -y install libevent-dev 
sudo apt-get -y install libboost-all-dev 
sudo apt-get -y install pkg-config  
sudo add-apt-repository ppa:bitcoin/bitcoin 
sudo apt-get update 
sudo apt-get -y install libdb4.8-dev 
sudo apt-get -y install libdb4.8++-dev 
sudo apt-get -y install libminiupnpc-dev libzmq3-dev libevent-pthreads-2.0-5 
sudo apt-get -y install libqt5gui5 libqt5core5a libqt5dbus5 qttools5-dev qttools5-dev-tools libprotobuf-dev
sudo apt-get -y install libqrencode-dev bsdmainutils unzip
#sudo apt install git 
cd /var 
sudo touch swap.img 
sudo chmod 600 swap.img 
sudo dd if=/dev/zero of=/var/swap.img bs=1024k count=2000 
sudo mkswap /var/swap.img 
sudo swapon /var/swap.img 
sudo echo ' /var/swap.img none swap sw 0 0 ' >> /etc/fstab
cd ~ 
sudo mkdir /root/nort
cd /root/nort
wget https://github.com/northern-community/Northern/releases/download/2.6.2/northern_linux.2_6_2.tar.gz
tar -xzvf northern_linux.2_6_2.tar.gz
sudo mv /root/nort/northernd /root/nort/northern-cli /root/nort/northern-tx /usr/local/bin
sudo chmod 755 -R  /usr/local/bin/northern*
sudo mkdir /home/northern/.northern
sudo touch /home/northern/.northern/northern.conf
echo -e "${GREEN}Configuring Wallet for first node${NC}"
echo "rpcuser=user"`shuf -i 100000-10000000 -n 1` >> /home/northern/.northern/northern.conf
echo "rpcpassword=pass"`shuf -i 100000-10000000 -n 1` >> /home/northern/.northern/northern.conf
echo "rpcallowip=127.0.0.1" >> /home/northern/.northern/northern.conf
echo "server=1" >> /home/northern/.northern/northern.conf
echo "daemon=1" >> /home/northern/.northern/northern.conf
echo "maxconnections=250" >> /home/northern/.northern/northern.conf
echo "masternode=1" >> /home/northern/.northern/northern.conf
echo "rpcport=6943" >> /home/northern/.northern/northern.conf
echo "listen=0" >> /home/northern/.northern/northern.conf
echo "externalip=$(hostname  -I | cut -f1 -d' '):6942" >> /home/northern/.northern/northern.conf
echo "masternodeprivkey=$privkey" >> /home/northern/.northern/northern.conf
echo "addnode=209.250.233.104" >> /home/northern/.northern/northern.conf
echo "addnode=45.77.82.101" >> /home/northern/.northern/northern.conf
echo "addnode=138.68.167.127" >> /home/northern/.northern/northern.conf
echo "addnode=207.246.86.118" >> /home/northern/.northern/northern.conf
echo "addnode=149.56.4.247" >> /home/northern/.northern/northern.conf
echo "addnode=149.56.4.246" >> /home/northern/.northern/northern.conf
echo "addnode=149.56.4.245" >> /home/northern/.northern/northern.conf
echo "addnode=149.56.4.244" >> /home/northern/.northern/northern.conf
echo "addnode=149.56.4.243" >> /home/northern/.northern/northern.conf
echo "addnode=149.56.4.242" >> /home/northern/.northern/northern.conf
echo "addnode=149.56.4.241" >> /home/northern/.northern/northern.conf
sleep 5
echo -e "${GREEN}Configuring Wallet for second node${NC}"
sudo mkdir /home/northern2/.northern
sudo touch /home/northern2/.northern/northern.conf
echo "rpcuser=user"`shuf -i 100000-10000000 -n 1` >> /home/northern2/.northern/northern.conf
echo "rpcpassword=pass"`shuf -i 100000-10000000 -n 1` >> /home/northern2/.northern/northern.conf
echo "rpcallowip=127.0.0.1" >> /home/northern2/.northern/northern.conf
echo "server=1" >> /home/northern2/.northern/northern.conf
echo "daemon=1" >> /home/northern2/.northern/northern.conf
echo "maxconnections=250" >> /home/northern2/.northern/northern.conf
echo "masternode=1" >> /home/northern2/.northern/northern.conf
echo "rpcport=6944" >> /home/northern2/.northern/northern.conf
echo "listen=0" >> /home/northern2/.northern/northern.conf
echo "externalip=$(hostname  -I | cut -f1 -d' '):6942" >> /home/northern2/.northern/northern.conf
echo "masternodeprivkey=$privkey2" >> /home/northern2/.northern/northern.conf
echo "addnode=209.250.233.104" >> /home/northern2/.northern/northern.conf
echo "addnode=45.77.82.101" >> /home/northern2/.northern/northern.conf
echo "addnode=138.68.167.127" >> /home/northern2/.northern/northern.conf
echo "addnode=207.246.86.118" >> /home/northern2/.northern/northern.conf
echo "addnode=149.56.4.247" >> /home/northern2/.northern/northern.conf
echo "addnode=149.56.4.246" >> /home/northern2/.northern/northern.conf
echo "addnode=149.56.4.245" >> /home/northern2/.northern/northern.conf
echo "addnode=149.56.4.244" >> /home/northern2/.northern/northern.conf
echo "addnode=149.56.4.243" >> /home/northern2/.northern/northern.conf
echo "addnode=149.56.4.242" >> /home/northern2/.northern/northern.conf
echo "addnode=149.56.4.241" >> /home/northern2/.northern/northern.conf
sleep 5 
echo -e "${GREEN}Configuring Wallet for third node${NC}"
sudo mkdir /home/northern3/.northern
sudo touch /home/northern3/.northern/northern.conf
echo "rpcuser=user"`shuf -i 100000-10000000 -n 1` >> /home/northern3/.northern/northern.conf
echo "rpcpassword=pass"`shuf -i 100000-10000000 -n 1` >> /home/northern3/.northern/northern.conf
echo "rpcallowip=127.0.0.1" >> /home/northern3/.northern/northern.conf
echo "server=1" >> /home/northern3/.northern/northern.conf
echo "daemon=1" >> /home/northern3/.northern/northern.conf
echo "maxconnections=250" >> /home/northern3/.northern/northern.conf
echo "masternode=1" >> /home/northern3/.northern/northern.conf
echo "rpcport=6945" >> /home/northern3/.northern/northern.conf
echo "listen=0" >> /home/northern3/.northern/northern.conf
echo "externalip=$(hostname  -I | cut -f1 -d' '):6942" >> /home/northern3/.northern/northern.conf
echo "masternodeprivkey=$privkey3" >> /home/northern3/.northern/northern.conf
echo "addnode=209.250.233.104" >> /home/northern3/.northern/northern.conf
echo "addnode=45.77.82.101" >> /home/northern3/.northern/northern.conf
echo "addnode=138.68.167.127" >> /home/northern3/.northern/northern.conf
echo "addnode=207.246.86.118" >> /home/northern3/.northern/northern.conf
echo "addnode=149.56.4.247" >> /home/northern3/.northern/northern.conf
echo "addnode=149.56.4.246" >> /home/northern3/.northern/northern.conf
echo "addnode=149.56.4.245" >> /home/northern3/.northern/northern.conf
echo "addnode=149.56.4.244" >> /home/northern3/.northern/northern.conf
echo "addnode=149.56.4.243" >> /home/northern3/.northern/northern.conf
echo "addnode=149.56.4.242" >> /home/northern3/.northern/northern.conf
echo "addnode=149.56.4.241" >> /home/northern3/.northern/northern.conf
sleep 5 
echo -e "${GREEN}Configuring Wallet for 4th node${NC}"
sudo mkdir /home/northern4/.northern
sudo touch /home/northern4/.northern/northern.conf
echo "rpcuser=user"`shuf -i 100000-10000000 -n 1` >> /home/northern4/.northern/northern.conf
echo "rpcpassword=pass"`shuf -i 100000-10000000 -n 1` >> /home/northern4/.northern/northern.conf
echo "rpcallowip=127.0.0.1" >> /home/northern4/.northern/northern.conf
echo "server=1" >> /home/northern4/.northern/northern.conf
echo "daemon=1" >> /home/northern4/.northern/northern.conf
echo "maxconnections=250" >> /home/northern4/.northern/northern.conf
echo "masternode=1" >> /home/northern4/.northern/northern.conf
echo "rpcport=6946" >> /home/northern4/.northern/northern.conf
echo "listen=0" >> /home/northern4/.northern/northern.conf
echo "externalip=$(hostname  -I | cut -f1 -d' '):6942" >> /home/northern4/.northern/northern.conf
echo "masternodeprivkey=$privkey4" >> /home/northern4/.northern/northern.conf
echo "addnode=209.250.233.104" >> /home/northern4/.northern/northern.conf
echo "addnode=45.77.82.101" >> /home/northern4/.northern/northern.conf
echo "addnode=138.68.167.127" >> /home/northern4/.northern/northern.conf
echo "addnode=207.246.86.118" >> /home/northern4/.northern/northern.conf
echo "addnode=149.56.4.247" >> /home/northern4/.northern/northern.conf
echo "addnode=149.56.4.246" >> /home/northern4/.northern/northern.conf
echo "addnode=149.56.4.245" >> /home/northern4/.northern/northern.conf
echo "addnode=149.56.4.244" >> /home/northern4/.northern/northern.conf
echo "addnode=149.56.4.243" >> /home/northern4/.northern/northern.conf
echo "addnode=149.56.4.242" >> /home/northern4/.northern/northern.conf
echo "addnode=149.56.4.241" >> /home/northern4/.northern/northern.conf
sleep 5 
fi
echo "Syncing first node, please wait...";
northernd -datadir=/home/northern/.northern -daemon
sleep 10 
until northern-cli -datadir=/home/northern/.northern mnsync status | grep -m 1 '"IsBlockchainSynced": true,'; do sleep 1 ; done > /dev/null 2>&1
echo -e ${GREEN}"First node is fully synced. You 1st masternode is running!"${NC}
sleep 10
echo "Syncing second node, please wait...";
northernd -datadir=/home/northern2/.northern -daemon
sleep 10 
until northern-cli -datadir=/home/northern2/.northern mnsync status | grep -m 1 '"IsBlockchainSynced": true,'; do sleep 1 ; done > /dev/null 2>&1
echo -e ${GREEN}"Second node is fully synced. You second masternode is running!"${NC}
sleep 10
echo "Syncing third node, please wait...";
northernd -datadir=/home/northern3/.northern -daemon
sleep 10 
until northern-cli -datadir=/home/northern3/.northern mnsync status | grep -m 1 '"IsBlockchainSynced": true,'; do sleep 1 ; done > /dev/null 2>&1
echo -e ${GREEN}"Third node is fully synced. You third masternode is running!"${NC}
sleep 10
echo "Syncing fourth node, please wait...";
northernd -datadir=/home/northern4/.northern -daemon
sleep 10 
until northern-cli -datadir=/home/northern4/.northern mnsync status | grep -m 1 '"IsBlockchainSynced": true,'; do sleep 1 ; done > /dev/null 2>&1
echo -e ${GREEN}"Last node is fully synced. You fourth masternode is running!"${NC}
echo ""
echo -e ${GREEN}"Congrats! Your NORT Masternodes are now installed and started. Please wait from 10-20 minutes in order to give the masternode enough time to sync, then start the node from your wallet, Debug console option"${NC}
echo "The END. You can close now the SSH terminal session";
