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
            echo "Ihre Eingabe ist zu gross."
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
        echo -e "${BlueBlinking}Sie haben das Spiel gewonnen.\033[0m"
	    feuerwerk
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

# Funktion um ein animiertes Feuerwerk zu zeigen
feuerwerk () {
    width=$(tput cols)
    height=$(tput lines)

    row=$(($height - 1))
    column=$(($width / 2))

	echo -e "\033[2J"

	tput cup $row $column

	for ((i = 0; i < 10; i++)); do
		row=$(($row - 2))
		drawPixel 3 $row $column

        # 0.1s warten
        sleep 0.1

        # Alles auf dem Screen löschen
	    echo -en "\033[2J"
	done
    for ((i = 0; i < 10; i++)); do
        for ((j = 0; j < 4; j++)); do
            if [[ $j -eq 0 ]]; then
                currRow=$(($row + $i))
                currColumn=$column
            elif [[ $j -eq 1 ]]; then
                currRow=$row
                currColumn=$(($column + $i))
            elif [[ $j -eq 2 ]]; then
                currRow=$(($row - $i))
                currColumn=$column
            elif [[ $j -eq 3 ]]; then
                currRow=$row
                currColumn=$(($column - $i))
            fi
            drawPixel 1 $currRow $currColumn
        done

        # 0.1s warten
        sleep 0.1
        
        # Alles auf dem Screen löschen
	    echo -en "\033[2J"
    done
	clear
}

drawPixel () {
    # Parameter definieren
    # yellow = 3, red = 1
    color=$1
    row=$2
    column=$3

    # Cursor Position speichern
	tput sc

    # Cursor Position setzen
    tput cup $row $column

    # * zeichnen
	tput setaf $color; echo -n "*"; tput sgr0

    # Cursor Position laden
	tput rc
}
done
