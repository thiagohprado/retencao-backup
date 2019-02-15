#!/bin/bash
#
# Programa: retencao-backup
# Autor: Thiago Prado
# E-mail: thiago_prado@outlook.com
# Criação: 24/01/2017
#
# Este programa faz backups na máquina local e mantem a retenção necessária;
#
###Versão 1.0.0 - Versão Inicial
###Versão 1.0.1 - Adiciona suporte a opções --help e --version
###Versão 1.0.2 - Corrige Bug que não deletava os tar.gz antigos 
###Versão 1.0.3 - Adiciona suporte a opção --interactive
###Versão 1.0.4 - Corrige Bug que não cancelava a execução do programa no dialog yesno
#
########################### Variaveis ############################
data=$( /bin/date +%Y-%m-%d )
dir_origem="ORIGEM"
dir_destino="DESTINO"
qtd_dia=3
qtd_bkp=$( /bin/ls ${dir_destino} | grep tar.gz | /usr/bin/wc -l )
flag_modointerativo=0 # Default é 0 (desligado)
##################################################################

# Verifica se foi passado o parâmetro posicional $1
case "$1" in
	-h | --help)
		echo "Modo de uso: PROGRAMA [OPCAO]"
		echo "Este programa faz backups na máquina local e mantem a retenção necessária;"
		echo ""
		echo "-h, --help \t Mostra essa ajuda e sai"
		echo "-V, --version \t Mostra a versão do programa e sai"
		echo "-i, --interactive \t Entra no modo interativo"
		echo ""
		exit 0
	;;
	-V | --version)
		# Busca a versão atual, filtrando pela ultima ocorrência da linha que começa com o termo "###Versão "
		grep "^###Vers[a|ã]o " "$0" | tail -1 | cut -f1 -d "-" | tr -d "#" 
		exit 0
	;;
	-i | --interactive)
		# Liga a flag do modo interativo
		flag_modointerativo="1"
	;;
	*)
		if [ -n "$1" ]; then
			echo "Parâmetro inválido!"
			exit 1 

		fi
	;;
esac	

# Executa o modo interativo
if [ "$flag_modointerativo" = 1  ]; then
	dialog --title "Bem Vindo ao retencao-backup" --yesno "Tem certeza que deseja fazer o backup ?" 5 50
	if [ "$?" = 1 ]; then
	 	clear
		exit 0
	fi
	(echo 20 ; sleep 1
	 echo 40 ; sleep 1
	 echo 75 ; sleep 1
	 echo 99 ; sleep 1
	 echo 100 ; sleep 1 ) | 
	dialog --title "Barra de progresso" --gauge "\nFazendo backup.." 8 40 60	
	dialog --msgbox "Concluído" 0 0
	clear
fi	

# Cria backup local dos arquivos
cd "$dir_destino" || exit 1
tar -czf retencao-"$data".tar.gz -C ../ "$dir_origem"
cd ../ || exit 1

# Apaga backups antigos, mantendo retencao mínima de 72 horas (3 dias)
if [ "${qtd_bkp}" -gt "${qtd_dia}" ]; then
   /usr/bin/find "${dir_destino}" -name '*.tar.gz' -mtime +2 -delete
fi

exit 0
