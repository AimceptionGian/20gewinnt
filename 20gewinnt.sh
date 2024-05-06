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

# Variablen definieren
width=$(tput cols)
height=$(tput lines)

row=$(($height - 1))
column=$(($width / 2))

# Funktion um ein animiertes Feuerwerk zu zeigen
feuerwerk () {
    offset=$1

    startx=$row
    starty=$(($column + offset))

    echo -e "\033[2J"
	
    tput cup $startx $starty

	for ((i = 0; i < 10; i++)); do
		startx=$(($startx - 2))
		drawPixel 3 $startx $starty

        # 0.1s warten
        sleep 0.1

        # Alles auf dem Screen löschen
	    echo -en "\033[2J"
	done
    for ((i = 0; i < 10; i++)); do
        for ((j = 0; j < 4; j++)); do
            if [[ $j -eq 0 ]]; then
                currRow=$(($startx - $i))
                currColumn=$starty
            elif [[ $j -eq 1 ]]; then
                currRow=$startx
                currColumn=$(($starty + $i))
            elif [[ $j -eq 2 ]]; then
                currRow=$(($startx + $i))
                currColumn=$starty
            elif [[ $j -eq 3 ]]; then
                currRow=$startx
                currColumn=$(($starty - $i))
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

# Funktion um ein * an einer bestimmten Stelle zu zeichnen
drawPixel () {
    # Parameter definieren
    # yellow = 3, red = 1
    color=$1
    x=$2
    y=$3

    # Cursor Position speichern
	tput sc

    # Cursor Position setzen
    tput cup $x $y

    # * zeichnen
	tput setaf $color; echo -n "*"; tput sgr0

    # Cursor Position laden
	tput rc
}

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
	    feuerwerk 0
        feuerwerk 10
        feuerwerk -10
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
done
