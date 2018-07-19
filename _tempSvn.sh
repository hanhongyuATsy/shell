#================================================================================:
DDIR=/DATA/_temp
SDIR=/DATA/_svn
DATE=`date +%Y%m%d`
DELT=`date -d -2day +%Y%m%d`
USER=pricFtp
DAYS=1

tar zcvf $DDIR/tempSvn$DATE.tar.gz $SDIR
chown -R $USER:$USER $DDIR
find $DDIR -name "tempSvn*" -type f -mtime +$DAYS -exec rm {} \;

ftp -n<<!
open 10.221.149.34 21
user pricBackups pricBackups2018
binary
lcd /DATA/_temp
prompt
mput tempSvn$DATE.tar.gz   tempSvn$DATE.tar.gz
mdelete tempSvn$DELT.tar.gz  tempSvn$DELT.tar.gz
close
bye
!

