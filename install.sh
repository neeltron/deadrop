 #!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

echo "Please enter your Deaddrop Type!"
echo "1. MarketDrop "
echo "2. CryptoDrop"

read num

mkdir /opt/deadrop

if [[ "$num" -eq 1 ]]; then
    cp marketdrop /opt/deadrop
elif [[ "$num" -eq 2 ]]; then
    cp cryptodrop /opt/deadrop
else 
    echo " Please choose correct option and retry"
    exit
fi

apt install python3 nginx python3-pip -y
snap install --classic certbot
ln -s /snap/bin/certbot /usr/bin/certbot

wget https://gist.githubusercontent.com/themayankjha/a1ce7e0d9358ea39ea912a9cb9f3a400/raw/434c03aec373b8ad625fdc5883b77a8e8d1ffb99/auth.py
chmod +x auth.py
mkdir /etc/letsencrypt
mv auth.py /etc/letsencrypt/


pip3 install flask gunicorn

if [[ "$num" -eq 1 ]]; then
    cd /opt/deadrop/marketdrop
    gunicorn -b :8081  app:app&
elif [[ "$num" -eq 2 ]]; then
    cd /opt/deadrop/cryptodrop
    gunicorn -b :8081  app:app&
fi

