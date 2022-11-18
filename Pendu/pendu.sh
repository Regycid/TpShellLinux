#!/usr/bin/bash

faux1 (){
    echo
    echo                       
    echo
    echo
    echo
    echo
    echo  " _________ "
    echo
}
faux2 (){
    echo
    echo                       
    echo
    echo
    echo
    echo  "        |  "
    echo  " _______|_ "
    echo
}
faux3 (){
    echo
    echo                       
    echo
    echo  "        |  "
    echo  "        |  "
    echo  "        |  "
    echo  " _______|_ "
    echo
}
faux4 (){
    echo
    echo  "        |  "                     
    echo  "        |  " 
    echo  "        |  "
    echo  "        |  "
    echo  "        |  "
    echo  " _______|_ "
    echo
}
faux5 (){
    echo  " _________ "
    echo  "        |  "                     
    echo  "        |  " 
    echo  "        |  "
    echo  "        |  "
    echo  "        |  "
    echo  " _______|_ "
    echo
}
faux6 (){
    echo  " _________ "
    echo  "   |    |  "                     
    echo  "   O    |  " 
    echo  "        |  "
    echo  "        |  "
    echo  "        |  "
    echo  " _______|_ "
    echo
}
faux7 (){
    echo  " _________ "
    echo  "   |    |  "                     
    echo  "   O    |  " 
    echo  "        |  "
    echo  "        |  "
    echo  "        |  "
    echo  " _______|_ "
    echo
}
faux7 (){
    echo  " _________ "
    echo  "   |    |  "                     
    echo  "   O    |  " 
    echo  "   |    |  "
    echo  "        |  "
    echo  "        |  "
    echo  " _______|_ "
    echo
}
faux8 (){
    echo  " _________ "
    echo  "   |    |  "                     
    echo  "   O    |  " 
    echo  "  /|\   |  "
    echo  "        |  "
    echo  "        |  "
    echo  " _______|_ "
    echo
}
faux9 (){
    echo -e  " _________ "
    echo -e  "   |    |  "                     
    echo -e  "\033[;36m   0 \033[0m   |  " 
    echo -e  "  /|\   |  "
    echo -e  "  / \   |  "
    echo -e  "        |  "
    echo -e  " _______|_ "
    echo
}

display () {
    DATA[0]=" __________ "     
    DATA[1]="     |   |  "
    DATA[2]="    \O   |  "   
    DATA[3]="     |\  |  "
    DATA[4]="    / \  |  "
    DATA[5]="         |  "
    DATA[6]=" ________|_ "
    DATA[7]="|          |"  
    DATA[8]="| LE PE_DU |" 
    DATA[9]="|__________|"   
    echo



    REAL_OFFSET_X=$(($((`tput cols` - 20)) / 2))
    REAL_OFFSET_Y=$(($((`tput lines` - 5)) / 2))

    draw_char() {
        V_COORD_X=$1
        V_COORD_Y=$2

        tput cup $((REAL_OFFSET_Y + V_COORD_Y)) $((REAL_OFFSET_X + V_COORD_X))

        printf %c ${DATA[V_COORD_Y]:V_COORD_X:1}
    }

    trap 'exit 1' INT TERM

    tput civis
    clear
    tempp=15
    while :; do
        tempp=`expr $tempp - 8`
        for ((c=1; c <= 15; c++)) do
            tput setaf $c
            for ((x=0; x<${#DATA[0]}; x++)); do
                for ((y=0; y<=9; y++)); do
                    draw_char $x $y
                done
            done
        done
        sleep 1.5
        clear
        break
    done
}
display


 main() {

    readarray -t a <PetitLarousse.txt
    randind=`expr $RANDOM % ${#a[@]}`
    mot=${a[$randind]}

    essais=()
    essaislist=()
    guin=0

    mot=`echo $mot | tr -dc '[:alnum:] \n\r' | tr '[:upper:]' '[:lower:]'`
    long=${#mot}

    for ((i=0;i<$long;i++)); do
        essais[$i]="_"
    done

    mo=()

    for ((i=0;i<$long;i++)); do
        mo[$i]=${mot:$i:1}

    done

    for ((j=0;j<$long;j++)); do
        if [[ ${mo[$j]} == " " ]]; then
            essais[$j]=" "
        fi
    done

rejouer(){
    echo
    echo -n "Rejouer? (o/n) "
    read -n 1 choix
    case $choix in
        [oO]) clear
              main 
        ;;
    esac
    exit
}
    
faux=0

    while [[ $faux -lt 9 ]]; do
        case $faux in
            0)echo " "
            ;;
            1)faux1
            ;;
            2)faux2
            ;;
            3)faux3
            ;;
            4)faux4
            ;;
            5)faux5
            ;;
            6)faux6
            ;;
            7)faux7
            ;;
            8)faux8
            ;;
        esac

        if [[ faux -eq 0 ]]; then
            for i in {1..9}
            do
                echo
            done
        fi

        bon=0
        for ((j=0;j<$long;j++)); do
            if [[ ${essais[$j]} == "_" ]]; then
                bon=1
            fi
        done

        echo Essais: ${essaislist[@]}
        echo Erreurs: $faux / 9
        for ((k=0;k<$long;k++)); do
            echo -n "${essais[$k]} "
        done
        echo
        echo

        if [[ bon -eq 1 ]]; then
            echo -n "Tapez une lettre : "
            read -n 1 -e lettre
            lettre=$(echo $lettre | tr [A-Z] [a-z])
            essaislist[$guin]=$lettre
            guin=`expr $guin + 1`
        fi

        f=0;
        for ((i=0;i<$long;i++)); do
            if [[ ${mo[$i]} == $lettre ]]; then
                essais[$i]=$lettre
                f=1
            fi
        done
        if [[ f -eq 0 ]]; then
            faux=`expr $faux + 1`
        fi

        if [[ bon -eq 0 ]]; then
            echo
            echo Victoire!
            echo $mot
            echo
            rejouer
        fi
        clear
    done

    faux9
    echo -e "\033[0;31mEchec!\033[0m"
    echo -e "Le mot est \033[0;32m$mot\033[0m bien sur !"
    rejouer
}

ops=("Jouer" "Quitter")
select op in "${ops[@]}"; do
    case $op in 

"Jouer")
    main
    exit ;;
     
"Quitter")
    exit ;;
     
        *) 
echo "invalide :("
        ;;
      
    esac
done