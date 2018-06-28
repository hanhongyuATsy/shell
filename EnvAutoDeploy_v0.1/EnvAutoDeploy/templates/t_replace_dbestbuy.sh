#!/bin/bash

BASE={{FARE_DIRRUN}}/
BASE_C={{FARE_DIRCODE}}/dbestbuy/
BACKUP=${BASE_C}backup/
APP=${BASE}app/
PLUGIN=${BASE}plugin/{{OUTER_SVR_NAME}}/
PAT_C=libpat.so.3.8 
PAT_A=libpat.so.3.8
PNR_C=liberr.so.1.0
PNR_A=liberr.so.1.0
FRONT_C=libfarefront.so.3.7
FRONT_A=libfarefront.so.3.7
MNG_C=fare_cache_mng
SER_C=fare_cache_ser
MNG_A=old_bestbuy_cache_mng
SER_A=old_bestbuy_cache_ser
CACHE_DIR={{FARE_DIRRUN}}/cache/{{OUTER_SVR_NAME}}/

ShowUesage()
{
    echo "must have 1 argument and be limited to string list below:"
    echo "cover					:compile and replace"
	echo "compile_only				:backup base"
	echo "cover_without_compile	:replace without compile"
    echo "recover				:replace with backups"
	echo "backup				:backup base"
}

ResetCache()
{
	rm -rfv ${CACHE_DIR}A
	rm -rfv ${CACHE_DIR}B
	rm -rfv ${CACHE_DIR}C
	
	mkdir -pv ${CACHE_DIR}A
	mkdir -pv ${CACHE_DIR}B
	mkdir -pv ${CACHE_DIR}C
}

Backup()
{
	rm -rfv ${BASE_C}backup
	mkdir -pv ${BASE_C}backup
	
	cp -v ${APP}${MNG_A}        ${BACKUP}${MNG_A} 		
	cp -v ${APP}${SER_A}        ${BACKUP}${SER_A} 		
	cp -v ${PLUGIN}${PAT_A}     ${BACKUP}${PAT_A}	 	
	cp -v ${PLUGIN}${PNR_A}     ${BACKUP}${PNR_A} 	
	cp -v ${PLUGIN}${FRONT_A}   ${BACKUP}${FRONT_A} 	
}

Cover()
{
	tsshutdown -yc
	
	rm -fv ${APP}${MNG_A}
	rm -fv ${APP}${SER_A}
	rm -fv ${PLUGIN}${PAT_A}
	rm -fv ${PLUGIN}${PNR_A}
	rm -fv ${PLUGIN}${FRONT_A}
	
	cp -v ${BASE_C}bin/${MNG_C} ${APP}${MNG_A}
	cp -v ${BASE_C}bin/${SER_C} ${APP}${SER_A}
	cp -v ${BASE_C}${PAT_C} ${PLUGIN}${PAT_A}
	cp -v ${BASE_C}${PNR_C} ${PLUGIN}${PNR_A}
	cp -v ${BASE_C}${FRONT_C} ${PLUGIN}${FRONT_A}
	cp -v ${BASE_C}${FRONT_C} ${PLUGIN}${FRONT_A}
	cp -v ${BASE_C}bin/lib* ${PLUGIN}.

	chmod 755 ${APP}${MNG_A}
	chmod 755 ${APP}${SER_A}

}

Compile()
{
	make -f makefile_tode -j8 clear
    make -f makefile_tode -j8

}

Recover()
{
	tsshutdown -yc
	rm -fv ${APP}${MNG_A}
	rm -fv ${APP}${SER_A}
	rm -fv ${PLUGIN}${PAT_A}
	rm -fv ${PLUGIN}${PNR_A}
	rm -fv ${PLUGIN}${FRONT_A}
	cp -v ${BACKUP}${MNG_A} ${APP}${MNG_A}
	cp -v ${BACKUP}${SER_A} ${APP}${SER_A}
	cp -v ${BACKUP}${PAT_A} ${PLUGIN}${PAT_A}
	cp -v ${BACKUP}${PNR_A} ${PLUGIN}${PNR_A}
	cp -v ${BACKUP}${FRONT_A} ${PLUGIN}${FRONT_A}

}

if [ $# -gt 0 ];then
	cd ${0%/*}
    if [ "$1" == "cover" ];then
		Compile
        Cover
		ResetCache
    elif [ "$1" == "compile_only" ];then
		Compile
	elif [ "$1" == "recover" ];then
        Recover
		ResetCache
	elif [ "$1" == "cover_without_compile" ];then
        Cover
		ResetCache
	elif [ "$1" == "backup" ];then
		Backup
    else 
        ShowUesage;
    fi
else 
    ShowUesage;
fi
