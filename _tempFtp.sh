#================================================================================:
DDIR=/DATA/_temp
SDIR=/DATA/_ftp
DATE=`date +%Y%m%d`
DELT=`date -d -2day +%Y%m%d`
USER=pricFtp
DAYS=1

tar zcvf $DDIR/tempFtp$DATE.tar.gz $SDIR
chown -R $USER:$USER $DDIR
find $DDIR -name "tempFtp*" -type f -mtime +$DAYS -exec rm {} \;

ftp -n<<!
open 10.221.149.34 21
user pricBackups pricBackups2018
binary
lcd /DATA/_temp
prompt
mput tempFtp$DATE.tar.gz   tempFtp$DATE.tar.gz
mdelete tempFtp$DELT.tar.gz  tempFtp$DELT.tar.gz
close
bye
!

