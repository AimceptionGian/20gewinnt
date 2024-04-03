#!/bin/bash
#title: 20 Gewinnt
#description: Ein Spiel bei dem man abwechselnd hochzählt. Wer als erster 20 sagt gewinnt.
#date: 03.04.24
#author: Gian Oechslin
#usage: -

# Spiel beginnt mit 1
spielstand=1
echo "Der Computer beginnt das Spiel mit $spielstand."

# Eingabe prüfen
while true; do
    read -p "Geben Sie eine gültige Zahl ein: " eingabe
    if [[ $eingabe -gt 20 ]]; then
        echo "Ihre Eingabe ist zu gross."
    elif [[ $eingabe -eq $(($spielstand + 1))]] \
      || [[ $eingabe -eq $(($spielstand + 2))]]; then
        break
    else
        echo "Geben Sie eine gültige Zahl ein. Entweder meine Zahl + 1 oder + 2."
    fi
done