<h1>Ubuntu Touch/Phone with Mir Display Server</h1>

Erlang ex11 is tested on BQ Aquaris E4.5 Ubuntu Phone

First you have to install an additional root FS on the phone

wget http://cdimage.ubuntu.com/ubuntu-touch/vivid/daily-preinstalled/current/vivid-preinstalled-touch-armhf.tar.gz

mkdir myRoot

cd myRoot

sudo tar -zxvf ../vivid-preinstalled-touch-armhf.tar.gz

cd ..

sudo mount --bind /tmp myRoot/tmp

cd myRoot

sudo chroot .

echo "nameserver 127.0.1.1" > /etc/resolv.conf

apt-get install xauth

xauth

add :0 . ab12cd34ef56fe78dc90ba1a2b3c4d5e6f

exit

exit

From now on, every time you want to start an erlang app start an Xmir window session

Xmir :0 --desktop_file_hint=/usr/share/applications/unity8.desktop &

cd myRoot

sudo chroot .

cd

cd ex11/util

erl -noshell -pa '../lib' -s clock init