#!/bin/bash

#@Autor: Luis Lema / lemaedu@gmail.com
#@Version 1.0.0 / 3-12-2021
#Realiza Backup de una BD mysql

#DECLARA VARIABLES 

USER=usuario #usuario de la BD
HOST=localhost #server donde se ejecuta
PASSWORD='contrasenia' #clave
export DATABASE=nombre_base_de_datos # nombre de base de datos

export DATE=`date +%Y_%m_%d`
export BACKUP_NAME=${DATABASE}_backup_${DATE}.sql
export DIR=/opt/backup/database #path donde se almacenara los backups

cd $DIR
> ${BACKUP_NAME}
chmod 777 ${BACKUP_NAME}
#COMANDO QUE REALIZA UN BACKUP
mysqldump --user=$USER --password=$PASSWORD --host=$HOST ${DATABASE} > ${DIR}/$BACKUP_NAME

return_code=$?
if [ $return_code -ne 0 ]
then
	echo 'Error en el backup. Compruebe: usuario y permisos'
else
		#COMPRIME RESPALDO
    	gzip -f *.backup
        printf "\nARCHIVO RESPALDO: "${BACKUP_NAME} >> ${DIR}/${DATE}.txt
        printf "\tPESO: "$size >> ${DIR}/${DATE}.txt
        echo 'Backup realizado correctamente. Archivo' ${DIR}/${BACKUP_NAME}
fi

#ELIMINA ARCHIVOS CON MAS DE 30 DIAS
find ${DIR}/* -mtime +30 -exec rm {} \;

