#!/usr/bin/env bash
#
# pos-install-linux.sh - Instala e configura programas no Linux (Base Debian)
#
# Autor:        Diolinux
# Editado por:	Jhonatanrs
#
# ------------------------------------------------------------------------ #
#
# COMO USAR?
#   $ Colocar arquivo no diretorio onde deseja instalar.
#   $ bash ./pos-install-lubuntu.sh
#
# ----------------------------- VARIÁVEIS ----------------------------- #
export DIRETORIO_INSTALL="wget"

baixawget(){
	echo -e "[INFO] - BAIXANDO PACOTES WGET - [INFO]"
	pasta

	URL_GOOGLE_CHROME="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
	wget -c "$URL_GOOGLE_CHROME" -O "$DIRETORIO_INSTALL/chrome.deb"
	
	URL_VS_CODE="https://go.microsoft.com/fwlink/?LinkID=760868"
	wget -c "$URL_VS_CODE" -O "$DIRETORIO_INSTALL/vscode.deb"
	
	URL_ANKI="https://apps.ankiweb.net/downloads/archive/anki-2.1.54-linux-qt6.tar.zst"
	wget -c "$URL_ANKI" -O "$DIRETORIO_INSTALL/anki.tar.zst"
}

teste_internet(){
	echo -e "[INFO] - VERIFICANDO CONEXAO COM A REDE - [INFO]"
	if ! ping -c 1 8.8.8.8 -q &> /dev/null; 
	then
	  echo -e "[INFO] - SEM CONEXAO COM INTERNET - [INFO]"
	  exit 1
	else
	  echo -e "[INFO] - CONEXAO COM INTERNET FUNCIONANDO NORMALMENTE - [INFO]"
	fi
}

pasta(){
	if [ -d "$DIRETORIO_INSTALL" ]
	then
		echo -e ""
	else
		mkdir "$DIRETORIO_INSTALL"
	fi
}

apt_update(){
	echo -e "[INFO] - ATUALIZANDO REPOSITORIO E FAZENDO ATUALIZACAO DO SISTEMA - [INFO]"
	sudo apt update && sudo apt dist-upgrade -y
}

add_archi386(){
	echo -e "[INFO] - ADCIONANDO ARQUITETURA DE 32 BITS - [INFO]"
	sudo dpkg --add-architecture i386
}

just_apt_update(){
	echo -e "[INFO] - ATUALIZANDO O REPOSITORIO - [INFO]"
	sudo apt update -y
}

install_apt(){
	echo -e "[INFO] - INSTALANDO PROGRAMAS NO APT - [INFO]"
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
	for nome_do_programa in ${PROGRAMAS_PARA_INSTALAR[@]}; 
	do
	  if ! dpkg -l | grep -q $nome_do_programa; 
	  then
	    sudo apt install "$nome_do_programa" -y
	  else
	    echo "[JA INSTALADO] - $nome_do_programa"
	  fi
	done
}

install_debs(){
	echo -e "[INFO] - INSTALANDO PACOTES DEB - [INFO]"
	sudo dpkg -i $DIRETORIO_INSTALL/*.deb
}

anki_install(){
	echo -e "[INFO] - INSTALANDO ANKI - [INFO]"
	tar xaf $DIRETORIO_INSTALL/anki.tar.zst -C $DIRETORIO_INSTALL
	cd $DIRETORIO_INSTALL/anki-2.1.54-linux-qt6
	sudo ./install.sh
	cd ../..
}

pop_share_folder(){
	echo -e "[INFO] - POP-OS SHARE FOLDER - [INFO]"
	sudo apt install samba nautilus-share
	sudo gpasswd -a $USER sambashare
	sudo chmod 777 /var/lib/samba/usershares
}

java_17(){
	echo -e "[INFO] - INSTALANDO JAVA - [INFO]"
	java -version
	sudo apt install openjdk-17-jre-headless -y
	sudo apt install openjdk-8-jdk -y
	sudo apt install openjdk-11-jdk -y
}

system_clean(){
	echo -e "[INFO] - FINALIZACAO, ATUALIZACAO E LIMPEZA - [INFO]"
	sudo apt autoclean -y
	sudo apt autoremove -y
	rm -r $DIRETORIO_INSTALL
	echo -e "[INFO] - SCRIPT FINALIZADO - [INFO]"
}

fullexec(){ 
	##SELECT EXEC 
	testes_internet
	apt_update
	add_archi386
	just_apt_update
	baixawget
	install_debs
	apt_update
	anki_install
	pop_share_folder
	java_17
	system_clean
}

fullexec
