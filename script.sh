#!/usr/bin/env bash

echo -e "\e[95mBonjour cher utilisateur !"
sleep 1
#Installation (ou pas) de Vagrant
echo -e "\e[97mSouhaitez-vous installer Vagrant ?"
echo "1: Oui, je veux l'installer"
echo "2: Non, je l'ai déjà installé"
read answer
if [ $answer == 1 ]
then
    wget -i https://releases.hashicorp.com/vagrant/2.1.1/vagrant_2.1.1_linux_amd64.zip	
    sudo apt-get install vagrant
    echo -e "\e[32mInstallation de Vagrant effectuée"
elif [ $answer == 2 ]
then
    echo -e "\e[32mOk. Pas d'installation de Vagrant"
else
    echo -e "\e[31mChoix invalide. Relancez le script"
    exit
fi

#Installation (ou pas) de VirtualBox
echo -e "\e[97mSouhaitez-vous installer Virtualbox ?"
echo "1: Oui, je veux l'installer"
echo "2: Non, je l'ai déjà installé"
read answer
if [ $answer == 1 ]
then
    wget -i https://download.virtualbox.org/virtualbox/5.2.12/virtualbox-5.2_5.2.12-122591~Debian~jessie_amd64.deb 	
    sudo apt-get update
    sudo apt-get install virtualbox-5.2
    echo -e "\e[32mInstallation de VirtualBox effectuée"
elif [ $answer == 2 ]
then
    echo -e "\e[32mOk. Pas d'installation de Virtualbox"
else
    echo -e "\e[31mChoix invalide. Relancez le script"
    exit
fi

#Création de la VagrantBox
boxInit() {
    echo -e "\e[97mChoisir une machine: "
    echo "1. Xenial64"
    echo "2. Xenial64"
    echo "3. Xenial64"
    read boxChoice
    vagrant init ubuntu/xenial64
    echo -e "\e[32mVotre machine sera créé sous Xenial64"
    sleep 1

    echo -e "\e[97mNom du dossier synchronisé: "
    read dirSync
    mkdir $dirSync
    sed -i "s/..\/data/.\/$dirSync/" 'Vagrantfile'
    sed -i 's/vagrant_data/var\/www\/html/' 'Vagrantfile'
    echo -e "\e[32mLe dossier $dirSync a bien été créé"
    sleep 1

    echo -e "\e[97mTaper une adresse IP: "
    read ipAddress
    sed -i s/192.168.33.10/$ipAddress/ 'Vagrantfile'
    sed -i '35 s/#//; 46 s/#//' 'Vagrantfile'
    echo -e "\e[32mL'adresse IP que vous avez choisi est: $ipAddress"
    sleep 1

    vagrant up
}

#MENU PRINCIPAL
mainNav() {
    echo -e "\e[104m\e[97mVAGRANT BOX MENU\033[0m"
    echo -e "\e[97mQue souhaitez-vous faire ?"
    echo "1. Créer une VagrantBox"
    echo "2. Afficher les box en cours d'exécution"
    echo "3. Sauvegarder une box"
    echo "4. Arrêter une box"
    echo "5. Mettre en pause une box"
    echo "6. Relancer une box"
    echo "7. Réinitialiser une box"
    echo "8. Quitter"
}

while [ -z $opt ] || [ $opt != 8 ]
do
mainNav
read -p "Choisir une option: " opt;
    case $opt in
    1)
        echo -e "\e[97mCréation d'une VagrantBox en cours..."
        sleep 1
        boxInit
        echo -e "\e[32mLa VagrandBox a bien été créé"
        ;;
    2)
        echo -e "\e[97mListe des box en cours d'exécution: "
        VBoxManage list runningvms
        ;;
    3)
        echo -e "\e[97mEcrire ou coller le uuid/vmname: "
        read vmCode
        VBoxManage controlvm $vmCode savestate
        echo -e "\e[32mLa VagrandBox a bien été sauvegardé"
        ;;
    4)
        echo -e "\e[97mEcrire ou coller le uuid/vmname: "
        read vmCode
        VBoxManage controlvm $vmCode poweroff
        echo -e "\e[32mLa VagrandBox a bien été arrêté"
        ;;
    5)
        echo -e "\e[97mEcrire ou coller le uuid/vmname: "
        read vmCode
        VBoxManage controlvm $vmCode pause
        echo -e "\e[32mLa VagrandBox a bien été suspendu"
        ;;
    6)
        echo -e "\e[97mEcrire ou coller le uuid/vmname: "
        read vmCode
        VBoxManage controlvm $vmCode resume
        echo -e "\e[32mReprise de la VagrandBox effectué"
        ;;
    7)
        echo -e "\e[97mEcrire ou coller le uuid/vmname: "
        read vmCode
        VBoxManage controlvm $vmCode reset
        echo -e "\e[32mLa VagrandBox a bien été réinitialisé"
        ;;
    8)
        echo -e "\e[95mA bientôt !"
        ;;
    *)
        echo -e "\e[31mChoix invalide."
        ;;
    esac
done


