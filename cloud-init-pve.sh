#! /bin/bash
#tworzenie nowego template na proxmoxie z wykorzystaniem obrazu cloud-init

#znajdywanie pierwszego wolnego id zaczynajacego sie od 9000
#pierw warunek czy w ogole sa tam jakies id, potem znajdz ostatni i sprawdz czy jest wiekszy lub rowny
#jeden jestli prawdziwy warunek do dodaj do niego jeden po prostu
#! /bin/bash
start_id=9000 #przyjmuje ze id maszyn template beda sie zaczynac od 9000
if [ ! -n "`qm list | tail -n 1`" ] # -n sprawdza czy cos sie wyswietlilo a ! n znaczy ze nic sie nie wyswietlilo
then
    echo "nie ma zadnych id"
    echo "jako poczatkowy id przyjmuje 9000"
    exit 0
else
    last_id=`qm list |tail -n 1 | awk '{print $1}'` #znajduje ostatni id na liscie
    if [ $last_id -ge 9000 ] # sprawdzam czy jest wiekszy lub rowny 9000
    then
    new_id=$(($last_id+1))
    echo "kolejne id to $new_id"
    else
    echo "jako poczatkowy id przyjme 9000" #byly jakies id ale sa mniejsze niz 9000 wiec zaczne od 9000
    fi
fi
