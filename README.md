Este Script foi criado pois ao longo dos meus estudos em WI-FI deauth passei um "leve" stress
com o fato do meu cabo ficar desconectando do roteador e com isso perdendo toda a configuração
do modo monitor, exigindo que tivesse que ser novamente rodado os comandos de forma manual
me tomando um tempo que poderia ser aliviado com algo "Automatizado".

*O Script foi criado para facilitar a execução de ataques de deautenticação Wi-Fi,* **usando de ferramenta aircrack-ng.** 
*Ele auxilia nos comandos de ativação do modo monitor, varredura de redes, seleção do alvo e execução do ataque.*

---
**⚠️ Aviso Legal**

Este script foi desenvolvido para fins educacionais e de auditoria de segurança em redes autorizadas. O uso indevido pode violar leis locais e resultar em penalidades legais. O autor não se responsabiliza por qualquer uso ilegal deste software.

---

**🔧 Requisitos**

- aircrack-ng
- net-tools -> ifconfig
- iw

*Atualizando os Pacotes:*

    sudo apt update && sudo apt upgrade -y

*Instalando as Ferramentas Necessárias:*

    sudo apt install -y aircrack-ng net-tools iw

*Verificando se as Ferramentas foram instaladas corretamente:*

    airmon-ng --help
    iw dev
    ifconfig
---

**🚀 Rodando o Script**

*Dê permissão de execução:*

    chmod +x Catapimbas_NetXploit.sh

*Execute o script como* **root**

    sudo ./Catapimbas_NetXploit.sh

**Ou** *estar previamente como root* **(particularmente acho mais "prático" pra voltar onde parou caso router caia)**

    sudo su
    ./Catapimbas_NetXploit.sh
---

**Imagens do MENU**

![1](https://github.com/user-attachments/assets/dd3ca763-ca75-453c-a21d-dc207d2acc6e)

![2](https://github.com/user-attachments/assets/f392c00f-1a8d-4705-a97d-7ef70b9b3724)

![3](https://github.com/user-attachments/assets/4ae12900-693f-41b0-8a56-0a8d0927186a)

![4](https://github.com/user-attachments/assets/ee9c467e-bf17-454f-ab41-71f6ec0e0955)

**Dispositivo que uso**

![6](https://github.com/user-attachments/assets/f6635486-3c4b-49ec-8752-764b7e18e82a) 

**Especificações:**

|   Chipset: RT3070L <br>
|   Padrão: ieee 802.11b/g/n <br>
|   Taxa de Transferência: 150mbps <br>
|   Distância de Transmissão: 100-300 metros <br>
|   Frequência: 2.4Ghz <br>


