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
    count=$1
    
    if [[ $count -eq 1 ]]; then
        startx=$column
    else
        startx=$(($width / $count))
    fi
    starty=$row

    echo -e "\033[2J"
	
    tput cup $starty $startx

	for ((i = 0; i < 10; i++)); do
		starty=$(($starty - 2))
        for ((j = $count; j > 0; j--)); do
		    drawPixel 3 $starty $startx
            if [[ $count -gt 1 ]]; then
                startx=$(($startx + ($width / ($count + 1))))
            fi
        done

        # 0.1s warten
        sleep 0.1

        # Alles auf dem Screen löschen
	    echo -en "\033[2J"

        if [[ $count -gt 1 ]]; then
            startx=$(($width / ($count + 1)))
        fi
	done
    for ((i = 0; i < 10; i++)); do
        explosionFrame 3 $i

        if [[ $count -gt 1 ]]; then
            startx=$(($width / ($count + 1)))
        fi        

        # 0.1s warten
        sleep 0.1
        
        # Alles auf dem Screen löschen
	    echo -en "\033[2J"
    done
	clear
}

# Funktion um einen * an einer bestimmten Stelle zu zeichnen
drawPixel () {
    # Parameter definieren
    # yellow = 3, red = 1
    color=$1
    y=$2
    x=$3

    # Cursor Position speichern
	tput sc

    # Cursor Position setzen
    tput cup $y $x

    # * zeichnen
	tput setaf $color; echo -n "*"; tput sgr0

    # Cursor Position laden
	tput rc
}

# Funktion um eine explosion mit * zu zeichnen
explosionFrame () {
    intensity=$1
    frame=$2

    currIntensity=$intensity
    currFrame=$frame

    for ((k = $count; k > 0; k--)); do
        for ((j = 0; j < 8; j++)); do
            if [[ $j -eq 0 ]]; then
                currColumn=$startx
                currRow=$(($starty - $currFrame))
            elif [[ $j -eq 1 ]]; then
                currColumn=$(($startx + $currFrame))
                currRow=$(($starty - $currFrame))
            elif [[ $j -eq 2 ]]; then
                currColumn=$(($startx + $currFrame))
                currRow=$starty
            elif [[ $j -eq 3 ]]; then
                currColumn=$(($startx + $currFrame))
                currRow=$(($starty + $currFrame))
            elif [[ $j -eq 4 ]]; then
                currColumn=$startx
                currRow=$(($starty + $currFrame))
            elif [[ $j -eq 5 ]]; then
                currColumn=$(($startx - $currFrame))
                currRow=$(($starty + $currFrame))
            elif [[ $j -eq 6 ]]; then
                currColumn=$(($startx - $currFrame))
                currRow=$starty
            elif [[ $j -eq 7 ]]; then
                currColumn=$(($startx - $currFrame))
                currRow=$((starty - $currFrame))
            fi
            drawPixel 1 $currRow $currColumn
            if [[ $currFrame -gt 0 ]]; then
                currIntensity=$(($currIntensity - 1))
                currFrame=$(($currFrame - 1))
            fi
            if [[ $currFrame -eq 0  ]]; then #Need to fix
                j=0
            fi
        done
        if [[ $count -gt 1 ]]; then
            startx=$(($startx + ($width / $count)))
        fi
        currIntensity=$intensity
        currFrame=$frame
    done
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
	    feuerwerk 3
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
