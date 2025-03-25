#!/bin/bash

echo "
██████╗  ██████╗ ██████╗ ████████╗   ███████╗ ██████╗ █████╗ ███╗   ██╗
██╔══██╗██╔═══██╗██╔══██╗╚══██╔══╝   ██╔════╝██╔════╝██╔══██╗████╗  ██║
██████╔╝██║   ██║██████╔╝   ██║█████╗███████╗██║     ███████║██╔██╗ ██║
██╔═══╝ ██║   ██║██╔══██╗   ██║╚════╝╚════██║██║     ██╔══██║██║╚██╗██║
██║     ╚██████╔╝██║  ██║   ██║      ███████║╚██████╗██║  ██║██║ ╚████║
╚═╝      ╚═════╝ ╚═╝  ╚═╝   ╚═╝      ╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═══╝
                                                     by: 4NTR4xX
"
while true; do
    echo
    echo "Elige tu escaneo:"
    echo
    echo "A) Enumerar Puertos"
    echo "B) Versión de Puertos"
    echo "C) Analizar Vulnerabilidades"
    echo "D) Salir"
    echo

    read -p ": " opcion

    if [[ "$opcion" =~ ^[Dd]$ ]]; then
        echo "Saliendo..."
        break
    fi

    read -p "Ingresa la IP o red (Por ejemplo: 192.168.0.0/24): " IP

    echo  

    case $opcion in
        A|a)
            sudo nmap -p- --open -sS -Pn -n "$IP" -oG AllPorts.txt
            
            puertos=$(grep -oP '\d{1,5}/open' AllPorts.txt | awk '{print $1}' FS='/' | xargs | tr ' ' ',')

            if [ -n "$puertos" ]; then
                echo "[*] Puertos abiertos encontrados: $puertos"

                if command -v xclip &> /dev/null; then
                    echo "$puertos" | tr -d '\n' | xclip -sel clip
                    echo "[*] Puertos copiados al portapapeles."
                else
                    echo "[!] xclip no está instalado. No se copiarán los puertos al portapapeles."
                fi
            else
                echo "[!] No se encontraron puertos abiertos."
            fi
            ;;
        
        B|b)
            read -p "Puertos abiertos (ejemplo: 22,80,443): " ports
            sudo nmap -p"$ports" -sS -sV -Pn -n "$IP" -oN VersionPorts.txt
            ;;
        
        C|c)
            read -p "Puertos abiertos (ejemplo: 22,80,443): " ports
            sudo nmap -p"$ports" --script "vuln and intrusive" -sS -sV -Pn -n "$IP" -oN VulnScan.txt
            ;;
        
        *)
            echo "Opción no válida."
            ;;
    esac
done
