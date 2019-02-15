#!/bin/bash
#
# Programa: retencao-backup
# Autor: Thiago Prado
# E-mail: thiago_prado@outlook.com
# Criação: 24/01/2017
#
# Este programa faz backups na máquina local e mantem a retenção necessária;
#
###Versao 1.0.0 - Versão Inicial
###Versão 1.0.1 - Adiciona suporte a opções --help e --version
###Versão 1.0.2 - Corrige Bug que não deletava os tar.gz antigos 
#
########################### Variaveis ############################
data=$( /bin/date +%Y-%m-%d )
dir_origem="ORIGEM"
dir_destino="DESTINO"
qtd_dia=3
qtd_bkp=$( /bin/ls ${dir_destino} | grep tar.gz | /usr/bin/wc -l )
##################################################################

# Verifica se foi passado o parâmetro posicional $1
case "$1" in
	-h | --help)
		echo "Modo de uso: PROGRAMA [OPCAO]"
		echo "Este programa faz backups na máquina local e mantem a retenção necessária;"
		echo ""
		echo "-h, --help \t Mostra essa ajuda e sai"
		echo "-V, --version \t Mostra a versão do programa e sai"
		echo ""
		exit 0
	;;
	-V | --version)
		# Busca a versão atual, filtrando pela ultima ocorrência da linha que começa com o termo "###Versão "
		grep "^###Vers[a|ã]o " "$0" | tail -1 | cut -f1 -d "-" | tr -d "#" 
		exit 0
	;;
	*)
		if [ -n "$1" ] ; then
			echo "Parâmetro inválido!"
			exit 1

		fi
	;;
esac	

# Cria backup local dos arquivos
cd "$dir_destino" || exit 1
tar -czf retencao-"$data".tar.gz -C ../ "$dir_origem"
cd ../ || exit 1

# Apaga backups antigos, mantendo retencao de 3 dias
if [ "${qtd_bkp}" -gt "${qtd_dia}" ]; then
   /usr/bin/find "${dir_destino}" -name '*.tar.gz' -mtime +2 -delete
fi

exit 0
