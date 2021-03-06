URL=http://download.kiwix.org/bin/0.9/kiwix-server-0.9-linux-armv5tejl.tar.bz2
ARCHIVE=kiwix-server-0.9-linux-armv5tejl.tar.bz2
BIN=kiwix-serve
FROM_BIN="$BIN"
TO_BIN="/usr/local/bin/$BIN"
LOG_FILE=install.log

. res/check.sh

mkdir -p tmp
cd tmp
if [ ! -f "$ARCHIVE" ]
then
    echo "Downloading $URL"
    wget $URL -O $ARCHIVE
fi
tar xjvf $ARCHIVE
sudo cp $FROM_BIN $TO_BIN

# Create data dir
sudo mkdir -p /usr/local/share/kiwix/

# Install service script
cd ..
sudo cp kiwix/kiwix.init /etc/init.d/kiwix

# add kiwix as service
if [[ -z "$VERBOSE" ]]; then
        echo -n "Add kiwix to services: "
        sudo update-rc.d kiwix defaults &>> $LOG_FILE
        check
else
        sudo update-rc.d kiwix defaults 2>&1 | tee -a $LOG_FILE
        echo -n "Add kiwix to services: `check`"
fi

# Install Nginx vhost
sudo cp kiwix/nginx.vhost /etc/nginx/sites-available/kiwix
sudo ln -fs /etc/nginx/sites-available/kiwix /etc/nginx/sites-enabled/kiwix
sudo service nginx restart


