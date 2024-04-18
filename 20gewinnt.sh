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
	echo -e "\033[2J"
	tput cup 40 70
	for ((i = 0; i < 20; i++)); do
		if [[ $i -le 10 ]]; then
			tput cuu 2
			drawPixel $i
		else
			tput cud 2
			drawPixel $i
		fi
        done
	clear
}

# Funktion um * zu zeichen und wieder zu löschen
drawPixel () {
	# Parameter definieren
	i=$1

    # Cursor Position speichern
    tput sc

    # Funktionen aufrufen, 5 Partikel und das i von Feuerwerk mitgeben
	yellowPixel 5 $i
	redPixel 5 $i

	sleep 0.1

    # Alles auf dem Screen löschen
	echo -en "\033[2J"

    # Cursor Position laden
	tput rc
}

yellowPixel () {
	i=$2

    # For Loop um gelbe * an "zufälliger" Stelle zu zeichnen
	for ((j=$1; j > 0; j--)); do
		tput sc

        # Cursor "zufällig" nach Links bewegen
		echo -en "\033[$(($[RANDOM % 2] + 1))D"

        # Cursor "zufällig" nach oben bewegen
		tput cuu $(($[RANDOM % 2] + 1))

        # Gelber * zeichnen
		tput setaf 3; echo -n "*"; tput sgr0
        
		tput rc
	done
}

redPixel () {
	i=$2

    # For Loop um rote * an "zufälliger" Stelle zu zeichnen 
	for ((j=$1; j > 0; j--)); do
		tput sc

        # Cursor immer weiter von Ursprungsposition nach Links bewegen
		echo -en "\033[$(((${i} + ${j}) + ${i}))D"

        # Cursor "zufällig" nach oben bewegen
		tput cuu $(($[RANDOM % 2] + 1))

        # Roter * zeichnen
		tput setaf 1; echo -n "*"; tput sgr0

		tput rc
	done
}
done
