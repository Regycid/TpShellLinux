#!/usr/bin/bash

	read -p "Entre quoi ( minimum ) ? " min
	read -p "Entre et quoi ( maximum ) ? " max
	num=$(shuf -i $min-$max -n 1)

for((;;))  
    do
	read -p "Devine ? " dev

    if
	[ $dev -lt $num ]
    then
	echo " + ! "
	i=-1; continue;
    elif
	[ $dev -gt $num ]
    then
	echo " - ! "
	i=-1; continue
    elif
	[ $dev == $num ]
    then
	echo " Bien joué, c'est bien $num ! "
        
    fi
	
    break
done
