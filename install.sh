# sudo apt-get update 
# sudo apt-get install -y node
# sudo apt-get install -y npm
# sudo npm install hexo-cli -g
sudo apt-get install -y xz-utils
wget https://nodejs.org/dist/v4.4.5/node-v4.4.5-linux-x64.tar.xz
sudo tar -C /usr/local --strip-components 1 -xJf node-v4.4.5-linux-x64.tar.xz 
ls -l /usr/local/bin/node
ls -l /usr/local/bin/npm

sudo npm install hexo-cli -g
cd blog
npm install
npm install hexo-deployer-git --save

