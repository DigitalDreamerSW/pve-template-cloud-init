#! /bin/bash
#tworzenie nowego template na proxmoxie z wykorzystaniem obrazu cloud-init
#dodac w przyszlosci opcje dodawania nazwy jako parametr i moze innych opcji

#parametry maszyny wzorcowej do ewentualnej zmiany
memory=2048
cpu=2
image_path="/mnt/cloud-init/Rocky-9-GenericCloud.latest.x86_64.qcow2"
name="debian-11"
bridge_type="vmbr1"
storage="local-zfs"

#sprawdzanie czy podano parametr, parametrem powinien byc obraz
if [ $# -eq 1 ] 
then
    if [ $1 == "--help" ]
    then
        echo "Skrypt mozna uruchomic z parametrem, jako parametr prosze podac obraz w formacie qcow2"
        echo "Przyklad: $0 xyz.qcow2"
        exit 0
    else
    image_path=$1
        if [ ! -n "`file -b $image_path  |grep QCOW`" ]
        then
            echo "obraz nie jest w formacie qcow2 lub podano zly parametr"
            exit 1
        else
            image_path=$(realpath $1) #musi byc pelna sciezka do pliku
        fi
    fi
else
    if [ -f $image_path ]
    then
        if [ ! -n "`file -b $image_path  |grep QCOW`" ]
        then
            echo "obraz nie jest w formacie qcow2"
            exit 1
        fi
    else
        echo "obraz nie istnieje lub podana zostala zla sciezka"
        exit 1
    fi
fi

#walidacja danych

if [ $memory -ge 512 -a $memory -le 10240 ]
then
    if [ $cpu -lt 1 -o $cpu -ge 4 ]
    then
    echo "Podano bledna wartosc cpu"
    exit 1 
    fi
else
echo "bledna wartosc ram"
exit 1
fi

#funkcja to tworzenia maszyny
create_vm()
{
    echo "nowe id to: $1"
    qm create $1 --memory $memory --cores $cpu --net0 virtio,bridge=$bridge_type --name $name --scsihw virtio-scsi-pci
}

adjust_vm()
{
    sleep 2
    qm set $1 --scsi0 $storage:0,import-from=$image_path #importowanie dysku
    qm set $1 --ide2 $storage:cloudinit ## cd-rom cloud init
    qm set $1 --boot order=scsi0 
    qm template $1

}

#znalezienie wolnego id 
#new_id=0
start_id=9000 #przyjmuje ze id maszyn template beda sie zaczynac od 9000
if [ ! -n "`qm list | tail -n 1`" ] # -n sprawdzanie czy sa jakies wiersze czy nie 
then
    create_vm $start_id
    adjust_vm $start_id
    exit 0
else
    last_id=`qm list |tail -n 1 | awk '{print $1}'` #znajduje ostatni id na liscie
    if [ $last_id -ge 9000 ] # sprawdzam czy jest wiekszy lub rowny 9000
    then
    new_id=$(($last_id+1))
    create_vm $new_id
    adjust_vm $new_id
    else
    create_vm $start_id
    adjust_vm $start_id
    fi
fi
