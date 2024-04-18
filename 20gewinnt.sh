#!/bin/bash
#title: 20 Gewinnt
#description: Ein Spiel bei dem man abwechselnd hochzählt. Wer als erster 20 sagt gewinnt.
#date: 03.04.24
#author: Gian Oechslin
#usage: -

# Farben definieren
Blue="\033[34;40m"
BlueBlinking="\033[34;5m"
Red="\033[31;40m"
White="\033[37;40m"

# Spiel beginnt mit 1
spielstand=1
echo "Der Computer beginnt das Spiel." 
echo -e "${Blue}$spielstand${White}"

# Endlosschleife
while true; do

    # Eingabe prüfen
    while true; do
        read -p "Geben Sie eine gültige Zahl ein: " eingabe
        if [[ $eingabe -gt 20 ]]; then
            echo -e "${Red}Ihre Eingabe ist zu gross.${White}"
        elif [[ $eingabe -eq $(($spielstand + 1)) ]] \
        || [[ $eingabe -eq $(($spielstand + 2)) ]]; then
            break
        else
            echo -e "${Red}Geben Sie eine gültige Zahl ein. Entweder die Zahl des Computers + 1 oder + 2.${White}"
        fi
    done

    # Eingabe ist gültig, also wird der Spielstand angepasst
    spielstand=$eingabe

    # Prüfen ob das Spiel gewonnen wurde
    if [[ $spielstand -eq 20 ]]; then
        echo -e "${BlueBlinking}Sie haben das Spiel gewonnen.${White}"
        exit 0
    fi

    # Prüfen ob der Computer das Spiel gewinnen kann
    if [[ $spielstand -gt 17 ]]; then
        spielstand=20
        echo -e "${Blue}$spielstand${White}" 
        echo "Der Computer hat das Spiel gewonnen"
        exit 1
    # Computer wählt ideale Zahl
    elif [[ $(((($spielstand + 1) % 3) - 1)) -eq 1 ]]; then
        spielstand=$(($spielstand + 1))
    elif [[ $(((($spielstand + 2) % 3) - 1)) -eq 1 ]]; then
        spielstand=$(($spielstand + 2))
    else
        spielstand=$(($spielstand + $[RANDOM % 2] + 1))
    fi
    echo -e "${Blue}$spielstand${White}"

    feuerwerk () {
        for ((i = 0; i < 10; i++)); do
            echo -en "\033[${i}A"
            echo -en "\033[93;49m*${White}"
            sleep 1
            echo -en "\033[2K"
        done
    }
done