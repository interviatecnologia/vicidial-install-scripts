Como – Instalar o Vicidial no OPEN SUSE 


Passo 1 – Baixe as dependências

timedatectl set-timezone America/Sao_Paulo

zypper update

zypper in git

#Disable SELINUX

sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config 

reboot

Passo 2 – Baixe os arquivos GitHub

cd /usr/src

git clone https://github.com/interviatecnologia/vicidial-install-scripts.git

cd vicidial-install-scripts

Passo 3 – Execute o instalador

Agora, sim, este é um instalador automático, mas você precisa pressionar Enter algumas vezes e também adicionar o IP do servidor, para não se afastar por muito tempo.

chmod +x opensuse15_5-vicibox-bootstrap.sh

./opensuse15_5-vicibox-bootstrap.sh
