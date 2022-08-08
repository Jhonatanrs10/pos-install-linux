#!/usr/bin/env bash
#
# pos-install-lubuntu.sh - Instala e configura programas no Lubuntu 22.04
#
# Autor:         Jhonatanrs
#
# ------------------------------------------------------------------------ #
#
# COMO USAR?
#   $ Colocar arquivo no diretorio onde deseja instalar.
#   $ bash ./pos-install-lubuntu.sh
#
# ----------------------------- VARIÁVEIS ----------------------------- #
set -e

##SUDO APT SOFTWARES TO INSTALL

PROGRAMAS_PARA_INSTALAR=(
  flatpak
  screenfetch
  anki
  net-tools
  blueman
  gparted
  synaptic
  mpv
  vlc
  libxcb-xinerama0
  zstd
  git
  wget
)

##URLS

URL_GOOGLE_CHROME="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
URL_VS_CODE="https://go.microsoft.com/fwlink/?LinkID=760868"
URL_ANKI="https://apps.ankiweb.net/downloads/archive/anki-2.1.54-linux-qt6.tar.zst"

##DIRETÓRIOS E ARQUIVOS

DIRETORIO_INSTALL="pos-install-jhonatanrs"
ANKI="anki.tar.zst"

# -------------------------------TESTES E REQUISITOS----------------------------------------- #

# Internet conectando?

testes_internet(){
if ! ping -c 1 8.8.8.8 -q &> /dev/null; then
  echo -e "${VERMELHO}[ERROR] - Seu computador não tem conexão com a Internet. Verifique a rede.${SEM_COR}"
  exit 1
else
  echo -e "${VERDE}[INFO] - Conexão com a Internet funcionando normalmente.${SEM_COR}"
fi
}

# Atualizando repositório e fazendo atualização do sistema

apt_update(){
  sudo apt update && sudo apt dist-upgrade -y
}

## Adicionando/Confirmando arquitetura de 32 bits ##

add_archi386(){
sudo dpkg --add-architecture i386
}

## Atualizando o repositório ##
just_apt_update(){
sudo apt update -y
}

## Download e instalaçao de programas externos ##

install_debs(){

echo -e "${VERDE}[INFO] - Baixando pacotes .deb${SEM_COR}"

if [ -d "$DIRETORIO_INSTALL" ]
then
	echo -e "JA EXISTE"
else
	mkdir "$DIRETORIO_INSTALL"
fi

wget -c "$URL_GOOGLE_CHROME" -O "$DIRETORIO_INSTALL/chrome.deb" 
wget -c "$URL_VS_CODE" -O "$DIRETORIO_INSTALL/vscode.deb"
wget -c "$URL_ANKI" -O "$DIRETORIO_INSTALL/$ANKI"

## Instalando pacotes .deb baixados na sessão anterior ##
echo -e "${VERDE}[INFO] - Instalando pacotes .deb baixados${SEM_COR}"
sudo dpkg -i $DIRETORIO_INSTALL/*.deb

# Instalar programas no apt
echo -e "${VERDE}[INFO] - Instalando pacotes apt do repositório${SEM_COR}"

for nome_do_programa in ${PROGRAMAS_PARA_INSTALAR[@]}; do
  if ! dpkg -l | grep -q $nome_do_programa; then # Só instala se já não estiver instalado
    sudo apt install "$nome_do_programa" -y
  else
    echo "[JA INSTALADO] - $nome_do_programa"
  fi
done

}

## Instalando ANKI

anki_install(){

    cd $DIRETORIO_INSTALL
    tar xaf $ANKI
    cd anki-2.1.54-linux-qt6
    sudo ./install.sh
	
}

# ----------------------------- PÓS-INSTALAÇÃO ----------------------------- #

## Finalização, atualização e limpeza##

system_clean(){
apt_update -y
sudo apt autoclean -y
sudo apt autoremove -y
}

# -------------------------------EXECUÇÃO----------------------------------------- #

testes_internet
apt_update
add_archi386
just_apt_update
install_debs
apt_update
anki_install
system_clean

## finalização

  echo -e "${VERDE}[INFO] - Script finalizado, instalação concluída! :)${SEM_COR}"
