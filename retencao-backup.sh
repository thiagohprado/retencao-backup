#!/bin/bash
# Thiago Prado 24/01/2017

# Script testado em redhat

######################## Variaveis ########################
DATA=$( /bin/date +%Y-%m-%d )
DIR_ORIGEM="ORIGEM"
DIR_DESTINO="DESTINO"
QTD_DIA=3
QTD_BKP=$( /bin/ls ${DIR_DESTINO} | grep tar.gz | /usr/bin/wc -l )
###########################################################

# Cria backup local dos arquivos
cd $DIR_DESTINO
tar -czf retencao-$DATA.tar.gz -C ../ $DIR_ORIGEM

# Apaga backups antigos, mantendo retencao de 3 dias
if [ ${QTD_BKP} -gt ${QTD_DIA} ]; then
   /usr/bin/find ${DIR_DESTINO} -name '*.tar.gz' -mtime +2 -delete
fi

exit 0
