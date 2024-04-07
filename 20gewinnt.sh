#!/bin/bash
#title: 20 Gewinnt
#description: Ein Spiel bei dem man abwechselnd hochzählt. Wer als erster 20 sagt gewinnt.
#date: 03.04.24
#author: Gian Oechslin
#usage: -

# Spiel beginnt mit 1
spielstand=1
echo "Der Computer beginnt das Spiel mit $spielstand."

# Endlosschleife
while true; do

    # Eingabe prüfen
    while true; do
        read -p "Geben Sie eine gültige Zahl ein: " eingabe
        if [[ $eingabe -gt 20 ]]; then
            echo "Ihre Eingabe ist zu gross."
        elif [[ $eingabe -eq $(($spielstand + 1)) ]] \
        || [[ $eingabe -eq $(($spielstand + 2)) ]]; then
            break
        else
            echo "Geben Sie eine gültige Zahl ein. Entweder meine Zahl + 1 oder + 2."
        fi
    done

    # Eingabe ist gültig, also wird der Spielstand angepasst
    spielstand=$eingabe

    # Prüfen ob das Spiel gewonnen wurde
    if [[ $spielstand -eq 20 ]]; then
        echo "Sie haben das Spiel gewonnen."
        exit 0
    fi

    # Prüfen ob der Computer das Spiel gewinnen kann
    if [[ $spielstand -gt 17 ]]; then
        spielstand=20
        echo "$spielstand" 
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
    echo "$spielstand"

done