Como – Instalar o Vicidial no Alma Linux 9 com meu novo instalador automático
Baseado: https://dialer.one/how-to-install-vicidial-on-alma-linux-9-with-my-new-auto-installer/
Alterado para uso sem Dynportal e Cyberphone
Alma 9 ISO – https://repo.almalinux.org/almalinux/9/isos/x86_64/AlmaLinux-9-latest-x86_64-dvd.iso

Passo 1 – Baixe as dependências
timedatectl set-timezone America/Sao_Paulo

yum check-update
yum update -y
yum -y install epel-release
yum update -y
yum install git -y
yum install -y kernel*

#Disable SELINUX
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config    

reboot

Passo 2 – Baixe os arquivos GitHub
cd /usr/src
git clone https://github.com/interviatecnologia/vicidial-install-scripts.git
cd vicidial-install-scripts
Passo 3 – Execute o instalador
Agora, sim, este é um instalador automático, mas você precisa pressionar Enter algumas vezes e também adicionar o IP do servidor, para não se afastar por muito tempo.

chmod +x alma-rocky9-ast16.sh
./alma-rocky9-ast16.sh
