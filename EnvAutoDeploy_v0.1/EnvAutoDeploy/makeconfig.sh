#!/bin/bash

## some string variables need to config
FARE_DIRRUN=/DATA/test/todefare       #这是运行环境的安装路径
FARE_DIRCODE=/home/rdtfare/test2/src  #这是代码的保存路径
INTER_SVR_NAME=PRIC_PF35              #内部服务名，可随意修改
OUTER_SVR_NAME_PRICE=ODP              #对外暴露的Price服务名，不得超过6个字符
OUTER_SVR_NAME_BESTBUY=ODB            #对外暴露的Bestbuy服务名，不得超过6个字符，且不得与Price重名
PORT_OUTER_WSL=43000                  #WSL的端口号，一般无需修改
PORT_OUTER_JSL=44000                  #JSL的端口号，一般无需修改
PORT_INTER_TSMA=22222                 #tsma内部使用的端口号，一般无需修改
PORT_INTER_TSMC=22221                 #tsmc内部使用的端口号，一般无需修改
PORT_INTER_MPNODE=53000               #内部使用的端口号，一般无需修改

## some private string variables
_MNAME=`hostname`
_IP=`hostname -I| rev | awk '{ result=gensub(/ /,"",1); print result }' | rev| awk '{ result=gensub(/ /,"",1); print result }'`
_UID=`id|awk '{print substr($1,index($1,"=")+1,index($1,"(")-index($1,"=")-1)}'`
_GID=`id|awk '{print substr($2,index($2,"=")+1,index($2,"(")-index($2,"=")-1)}'`
cd `dirname $0`
_PWD=`pwd`
_TEMPLATES=${_PWD}/templates
_OUTER_SVR_NAME_LEN_MAX=6

## ShowUesage
ShowUesage()
{
    echo "must have 1 argument and be limited to string list below:"
    echo "install_old_price          :install old price"
	echo "install_old_bestbuy        :install old bestbuy"
	echo "install_old_all            :install old price and old bestbuy"
    echo "uninstall                  :uninstall all"
}

_CreateDirForRun()
{
    ## mkdir for todefare
    mkdir -pv ${FARE_DIRRUN}/lib
    mkdir -pv ${FARE_DIRRUN}/app
    mkdir -pv ${FARE_DIRRUN}/config
    mkdir -pv ${FARE_DIRRUN}/plugin
    mkdir -pv ${FARE_DIRRUN}/shell
    mkdir -pv ${FARE_DIRRUN}/log
    mkdir -pv ${FARE_DIRRUN}/log/ULOG
}
_InstallLibrary()
{

    ## download libevn
    LIB_EVN_VERSION=('boost' 'icu' 'tode_2.2.1_linux64_rhel6.3' 'tosf_4.1.5_linux64_rhel6.3' 'xerces')

    for item in ${LIB_EVN_VERSION[@]};do
    
     curl -o ${FARE_DIRRUN}/lib/$item.tar.gz ftp://pricFtp:pricFtp2018@10.221.148.94:21/C++/env/lib/$item.tar.gz

     tar -xzvf ${FARE_DIRRUN}/lib/$item.tar.gz -C ${FARE_DIRRUN}/lib

     rm -v ${FARE_DIRRUN}/lib/$item.tar.gz
    done

    ln -s ${FARE_DIRRUN}/lib/tode_2.2.1_linux64_rhel6.3 ${FARE_DIRRUN}/lib/tode
    ln -s ${FARE_DIRRUN}/lib/tosf_4.1.5_linux64_rhel6.3 ${FARE_DIRRUN}/lib/tosf

    LIB_EVN_ORA11G=('ora11g.tar.gz_aa' 'ora11g.tar.gz_ab' 'ora11g.tar.gz_ac' 'ora11g.tar.gz_ad' 'ora11g.tar.gz_ae' 'ora11g.tar.gz_af' 'ora11g.tar.gz_ag' 'ora11g.tar.gz_ah' 'ora11g.tar.gz_ai' 'ora11g.tar.gz_aj' 'ora11g.tar.gz_ak' 'ora11g.tar.gz_al' 'ora11g.tar.gz_am' 'ora11g.tar.gz_an' )
    for item in ${LIB_EVN_ORA11G[@]};do
    
     curl -o ${FARE_DIRRUN}/lib/$item ftp://pricFtp:pricFtp2018@10.221.148.94:21/C++/env/lib/ora11g/$item

    done
    cat ${FARE_DIRRUN}/lib/ora11g.tar.gz_a* | tar -C ${FARE_DIRRUN}/lib -xzv 
    rm -fv   ${FARE_DIRRUN}/lib/ora11g.tar.gz_a*
}

_LinkAPP_Price()
{
    #dprice soft link
    ln -s ${FARE_DIRRUN}/lib/tosf/bin/app_ver_mng ${FARE_DIRRUN}/app/old_price_ver_mng
    ln -s ${FARE_DIRRUN}/lib/tosf/bin/app_ver_ctl ${FARE_DIRRUN}/app/old_price_ver_ctl
    ln -s ${FARE_DIRRUN}/lib/tosf/bin/app_trc_mng ${FARE_DIRRUN}/app/old_price_trc_mng
    ln -s ${FARE_DIRRUN}/lib/tosf/bin/app_ctx_svr ${FARE_DIRRUN}/app/old_price_ctx_svr
    ln -s ${FARE_DIRRUN}/lib/tosf/bin/app_ctx_mng ${FARE_DIRRUN}/app/old_price_ctx_mng
    ln -s ${FARE_DIRRUN}/lib/tosf/bin/app_comm_out ${FARE_DIRRUN}/app/old_price_comm_out
    ln -s ${FARE_DIRRUN}/lib/tosf/bin/app_comm ${FARE_DIRRUN}/app/old_price_comm
    ln -s ${FARE_DIRRUN}/lib/tosf/bin/app_svr ${FARE_DIRRUN}/app/old_price_pfd_svr
    ln -s ${FARE_DIRRUN}/lib/tosf/bin/app_svr ${FARE_DIRRUN}/app/old_price_pat_svr
    ln -s ${FARE_DIRRUN}/lib/tosf/bin/app_svr ${FARE_DIRRUN}/app/old_price_oc_svr
    ln -s ${FARE_DIRRUN}/lib/tosf/bin/app_svr ${FARE_DIRRUN}/app/old_price_nfd_svr
    ln -s ${FARE_DIRRUN}/lib/tosf/bin/app_svr ${FARE_DIRRUN}/app/old_price_err_svr
}

_LinkAPP_BestBuy()
{
    #dprice soft link
    ln -s ${FARE_DIRRUN}/lib/tosf/bin/app_ver_mng ${FARE_DIRRUN}/app/old_bestbuy_ver_mng
    ln -s ${FARE_DIRRUN}/lib/tosf/bin/app_ver_ctl ${FARE_DIRRUN}/app/old_bestbuy_ver_ctl
    ln -s ${FARE_DIRRUN}/lib/tosf/bin/app_trc_mng ${FARE_DIRRUN}/app/old_bestbuy_trc_mng
    ln -s ${FARE_DIRRUN}/lib/tosf/bin/app_comm_out ${FARE_DIRRUN}/app/old_bestbuy_comm_out
    ln -s ${FARE_DIRRUN}/lib/tosf/bin/app_comm ${FARE_DIRRUN}/app/old_bestbuy_comm
    ln -s ${FARE_DIRRUN}/lib/tosf/bin/app_svr ${FARE_DIRRUN}/app/old_bestbuy_pat_svr
    ln -s ${FARE_DIRRUN}/lib/tosf/bin/app_svr ${FARE_DIRRUN}/app/old_bestbuy_err_svr
}

_MakeConfig_Common()
{
    #database tnsnames.ora
    cp -v ${_TEMPLATES}/t_tnsnames.ora ${FARE_DIRRUN}/config/tnsnames.ora
    ln -s ${FARE_DIRRUN}/config/tnsnames.ora ${FARE_DIRRUN}/lib/ora11g/product/11.2.0/network/admin/tnsnames.ora
    
    #t_setenv.tosf.sh
    sed "s#{{RUNTIME_DIR}}#${FARE_DIRRUN}#;s#{{IP}}#${_IP}#;s#{{PORT_OUTER_WSL}}#${PORT_OUTER_WSL}#" ${_TEMPLATES}/t_setenv.tosf.sh > ${FARE_DIRRUN}/shell/setenv.tosf.sh
    chmod u+x ${FARE_DIRRUN}/shell/setenv.tosf.sh

    #start.sh
    sed "s#{{INTER_SVR_NAME}}#${INTER_SVR_NAME}#;s#{{IP}}#${_IP}#;s#{{PORT_INTER_TSMA}}#${PORT_INTER_TSMA}#" ${_TEMPLATES}/t_start.sh > ${FARE_DIRRUN}/shell/start.sh
    chmod u+x ${FARE_DIRRUN}/shell/start.sh

    #stop.sh
    cp -v ${_TEMPLATES}/t_stop.sh ${FARE_DIRRUN}/shell/stop.sh
    chmod u+x ${FARE_DIRRUN}/shell/stop.sh

    #tsmc.conf
    sed "s#{{MNAME}}#${_MNAME}#;s#{{INTER_SVR_NAME}}#${INTER_SVR_NAME}#;s#{{IP}}#${_IP}#;s#{{PORT_INTER_TSMC}}#${PORT_INTER_TSMC}#;s#{{PORT_INTER_TSMA}}#${PORT_INTER_TSMA}#" ${_TEMPLATES}/t_tsmc.conf > ${FARE_DIRRUN}/config/tsmc.conf

    #city.tsv
    cp -v ${_TEMPLATES}/t_city.tsv ${FARE_DIRRUN}/config/city.tsv

    #PARAMETER.cfg
    cp -v ${_TEMPLATES}/t_PARAMETER.cfg ${FARE_DIRRUN}/config/PARAMETER.cfg
}
_MakeConfig_Price()
{
    #tsconfig.xml
    sed "s#{{MNAME}}#${_MNAME}#;s#{{INTER_SVR_NAME}}#${INTER_SVR_NAME}#;s#{{UID}}#${_UID}#;s#{{GID}}#${_GID}#;s#{{IP}}#${_IP}#;s#{{PORT_INTER_MPNODE}}#${PORT_INTER_MPNODE}#;s#{{PORT_OUTER_WSL}}#${PORT_OUTER_WSL}#;s#{{PORT_OUTER_JSL}}#${PORT_OUTER_JSL}#;s#{{OUTER_SVR_NAME_PRICE}}#${OUTER_SVR_NAME_PRICE}#" ${_TEMPLATES}/t_tsconfig_dprice.xml > ${FARE_DIRRUN}/config/tsconfig.xml

    ##just for old dprice
    ##{{OUTER_SVR_NAME_PRICE}}.cfg
    sed "s#{{FARE_DIRRUN}}#${FARE_DIRRUN}#;s#{{OUTER_SVR_NAME_PRICE}}#${OUTER_SVR_NAME_PRICE}#" ${_TEMPLATES}/t_dprice.cfg > ${FARE_DIRRUN}/config/${OUTER_SVR_NAME_PRICE}.cfg
    ln -s ${FARE_DIRRUN}/config/${OUTER_SVR_NAME_PRICE}.cfg ${FARE_DIRRUN}/app/${OUTER_SVR_NAME_PRICE}.cfg
}

_MakeConfig_BestBuy()
{
    #tsconfig.xml
    sed "s#{{MNAME}}#${_MNAME}#;s#{{INTER_SVR_NAME}}#${INTER_SVR_NAME}#;s#{{UID}}#${_UID}#;s#{{GID}}#${_GID}#;s#{{IP}}#${_IP}#;s#{{PORT_INTER_MPNODE}}#${PORT_INTER_MPNODE}#;s#{{PORT_OUTER_WSL}}#${PORT_OUTER_WSL}#;s#{{PORT_OUTER_JSL}}#${PORT_OUTER_JSL}#;s#{{OUTER_SVR_NAME_BESTBUY}}#${OUTER_SVR_NAME_BESTBUY}#" ${_TEMPLATES}/t_tsconfig_dbestbuy.xml > ${FARE_DIRRUN}/config/tsconfig.xml

    ##just for old bestbuy
    ##{{OUTER_SVR_NAME_BESTBUY}}.cfg
    sed "s#{{FARE_DIRRUN}}#${FARE_DIRRUN}#;s#{{OUTER_SVR_NAME_BESTBUY}}#${OUTER_SVR_NAME_BESTBUY}#" ${_TEMPLATES}/t_dbestbuy.cfg > ${FARE_DIRRUN}/config/${OUTER_SVR_NAME_BESTBUY}.cfg
    ln -s ${FARE_DIRRUN}/config/${OUTER_SVR_NAME_BESTBUY}.cfg ${FARE_DIRRUN}/app/${OUTER_SVR_NAME_BESTBUY}.cfg
}
_MakeConfig_ALL()
{
    #tsconfig.xml
    sed "s#{{MNAME}}#${_MNAME}#;s#{{INTER_SVR_NAME}}#${INTER_SVR_NAME}#;s#{{UID}}#${_UID}#;s#{{GID}}#${_GID}#;s#{{IP}}#${_IP}#;s#{{PORT_INTER_MPNODE}}#${PORT_INTER_MPNODE}#;s#{{PORT_OUTER_WSL}}#${PORT_OUTER_WSL}#;s#{{PORT_OUTER_JSL}}#${PORT_OUTER_JSL}#;s#{{OUTER_SVR_NAME_PRICE}}#${OUTER_SVR_NAME_PRICE}#;s#{{OUTER_SVR_NAME_BESTBUY}}#${OUTER_SVR_NAME_BESTBUY}#" ${_TEMPLATES}/t_tsconfig_all.xml > ${FARE_DIRRUN}/config/tsconfig.xml


    ##just for old dprice
    ##{{OUTER_SVR_NAME_PRICE}}.cfg
    sed "s#{{FARE_DIRRUN}}#${FARE_DIRRUN}#;s#{{OUTER_SVR_NAME_PRICE}}#${OUTER_SVR_NAME_PRICE}#" ${_TEMPLATES}/t_dprice.cfg > ${FARE_DIRRUN}/config/${OUTER_SVR_NAME_PRICE}.cfg
    ln -s ${FARE_DIRRUN}/config/${OUTER_SVR_NAME_PRICE}.cfg ${FARE_DIRRUN}/app/${OUTER_SVR_NAME_PRICE}.cfg

    ##just for old bestbuy
    ##{{OUTER_SVR_NAME_BESTBUY}}.cfg
    sed "s#{{FARE_DIRRUN}}#${FARE_DIRRUN}#;s#{{OUTER_SVR_NAME_BESTBUY}}#${OUTER_SVR_NAME_BESTBUY}#" ${_TEMPLATES}/t_dbestbuy.cfg > ${FARE_DIRRUN}/config/${OUTER_SVR_NAME_BESTBUY}.cfg
    ln -s ${FARE_DIRRUN}/config/${OUTER_SVR_NAME_BESTBUY}.cfg ${FARE_DIRRUN}/app/${OUTER_SVR_NAME_BESTBUY}.cfg
}
_DoWithSRC_Price()
{
    mkdir -pv ${FARE_DIRRUN}/log/${OUTER_SVR_NAME_PRICE}
    mkdir -pv ${FARE_DIRRUN}/log/${OUTER_SVR_NAME_PRICE}/XMLTraceLog
    mkdir -pv ${FARE_DIRRUN}/log/${OUTER_SVR_NAME_PRICE}/CacheLog
    mkdir -pv ${FARE_DIRRUN}/cache/${OUTER_SVR_NAME_PRICE}/A
    mkdir -pv ${FARE_DIRRUN}/cache/${OUTER_SVR_NAME_PRICE}/B
    mkdir -pv ${FARE_DIRRUN}/cache/${OUTER_SVR_NAME_PRICE}/C
    mkdir -pv ${FARE_DIRRUN}/plugin/${OUTER_SVR_NAME_PRICE}


    ## src
    SRC_DPRICE=dprice_2018_02_08_master
    mkdir -pv ${FARE_DIRCODE}
    curl -o ${FARE_DIRCODE}/${SRC_DPRICE}.tar.gz ftp://pricFtp:pricFtp2018@10.221.148.94:21/C++/env/src/${SRC_DPRICE}.tar.gz
    tar -xzf ${FARE_DIRCODE}/${SRC_DPRICE}.tar.gz -C ${FARE_DIRCODE}/
    rm -rf ${FARE_DIRCODE}/${SRC_DPRICE}.tar.gz

    #ToshDefine.h in dprice

    rm -f ${FARE_DIRCODE}/dprice/include/TosfDefine.h
    sed "s#{{OUTER_SVR_NAME_PRICE}}#${OUTER_SVR_NAME_PRICE}#" ${_TEMPLATES}/t_TosfDefine_dprice.h >  ${FARE_DIRCODE}/dprice/include/TosfDefine.h
    #(cat ${FARE_DIRCODE}/dprice/include/TosfDefine.h |sed "s&#define TOSFAPPID \"T_FARE\"&#define TOSFAPPID \"${OUTER_SVR_NAME_PRICE}\"&")>${FARE_DIRCODE}/dprice/include/TosfDefine.h

    #replace.sh in dprice
    rm -f ${FARE_DIRCODE}/dprice/replace.sh
    sed "s#{{FARE_DIRCODE}}#${FARE_DIRCODE}#;s#{{FARE_DIRRUN}}#${FARE_DIRRUN}#;s#{{OUTER_SVR_NAME}}#${OUTER_SVR_NAME_PRICE}#;" ${_TEMPLATES}/t_replace_dprice.sh >  ${FARE_DIRCODE}/dprice/replace.sh
    chmod u+x ${FARE_DIRCODE}/dprice/replace.sh
}

_DoWithSRC_BestBuy()
{
    mkdir -pv ${FARE_DIRRUN}/log/${OUTER_SVR_NAME_BESTBUY}
    mkdir -pv ${FARE_DIRRUN}/log/${OUTER_SVR_NAME_BESTBUY}/XMLTraceLog
    mkdir -pv ${FARE_DIRRUN}/log/${OUTER_SVR_NAME_BESTBUY}/TOSF
    mkdir -pv ${FARE_DIRRUN}/log/${OUTER_SVR_NAME_BESTBUY}/CacheLog
    mkdir -pv ${FARE_DIRRUN}/cache/${OUTER_SVR_NAME_BESTBUY}/A
    mkdir -pv ${FARE_DIRRUN}/cache/${OUTER_SVR_NAME_BESTBUY}/B
    mkdir -pv ${FARE_DIRRUN}/cache/${OUTER_SVR_NAME_BESTBUY}/C
    mkdir -pv ${FARE_DIRRUN}/plugin/${OUTER_SVR_NAME_BESTBUY}


    ## src
    SRC_DBESTBUY=dbestbuy_2018_02_08_master
    mkdir -pv ${FARE_DIRCODE}
    curl -o ${FARE_DIRCODE}/${SRC_DBESTBUY}.tar.gz ftp://pricFtp:pricFtp2018@10.221.148.94:21/C++/env/src/${SRC_DBESTBUY}.tar.gz
    tar -xzf ${FARE_DIRCODE}/${SRC_DBESTBUY}.tar.gz -C ${FARE_DIRCODE}/
    rm -rf ${FARE_DIRCODE}/${SRC_DBESTBUY}.tar.gz

    #ToshDefine.h in dprice
    rm -f ${FARE_DIRCODE}/dbestbuy/src/include/TosfDefine.h
    sed "s#{{OUTER_SVR_NAME_BESTBUY}}#${OUTER_SVR_NAME_BESTBUY}#" ${_TEMPLATES}/t_TosfDefine_dbestbuy.h >  ${FARE_DIRCODE}/dbestbuy/src/include/TosfDefine.h
    #(cat ${FARE_DIRCODE}/dbestbuy/src/include/TosfDefine.h |sed "s&#define TOSFAPPID \"T_FARE\"&#define TOSFAPPID \"${OUTER_SVR_NAME_PRICE}\"&")>${FARE_DIRCODE}/dbestbuy/src/include/TosfDefine.h
    
    #replace.sh in dprice
    rm -f ${FARE_DIRCODE}/dbestbuy/replace.sh
    sed "s#{{FARE_DIRCODE}}#${FARE_DIRCODE}#;s#{{FARE_DIRRUN}}#${FARE_DIRRUN}#;s#{{OUTER_SVR_NAME}}#${OUTER_SVR_NAME_BESTBUY}#;" ${_TEMPLATES}/t_replace_dbestbuy.sh >  ${FARE_DIRCODE}/dbestbuy/replace.sh
    chmod u+x ${FARE_DIRCODE}/dbestbuy/replace.sh
}
Install_old_price()
{

    _CreateDirForRun
    _InstallLibrary
    _LinkAPP_Price

    ## output config
    _MakeConfig_Common
    _MakeConfig_Price
    
    ## Do with SRC
    _DoWithSRC_Price

}

Install_old_bestbuy()
{
    _CreateDirForRun
    _InstallLibrary
    _LinkAPP_BestBuy

    ## output config
    _MakeConfig_Common
    _MakeConfig_BestBuy
    
    ## Do with SRC
    _DoWithSRC_BestBuy
}

Install_old_all()
{
    _CreateDirForRun
    _InstallLibrary
    _LinkAPP_Price
    _LinkAPP_BestBuy

    ## output config
    _MakeConfig_Common
    _MakeConfig_ALL

    ## Do with SRC
    _DoWithSRC_Price
    _DoWithSRC_BestBuy
}
Uninstall()
{
    tsshutdown -yc
    ${FARE_DIRRUN}/shell/stop.sh
    rm -rfv ${FARE_DIRRUN}
    rm -rfv ${FARE_DIRCODE}
}

if [ $# -gt 0 ];then
    if [ "$1" == "install_old_price" ];then
        if [ ${#OUTER_SVR_NAME_PRICE} -gt ${_OUTER_SVR_NAME_LEN_MAX} ];then
            echo "{{OUTER_SVR_NAME_PRICE}} must be a string that contains characters less than 7"
        else
            Install_old_price
        fi
    elif [ "$1" == "install_old_bestbuy" ];then
        if [ ${#OUTER_SVR_NAME_BESTBUY} -gt ${_OUTER_SVR_NAME_LEN_MAX} ];then
            echo "{{OUTER_SVR_NAME_BESTBUY}} must be a string that contains characters less than 7"
        else
            Install_old_bestbuy
        fi
	elif [ "$1" == "install_old_all" ];then
        if [ ${#OUTER_SVR_NAME_PRICE} -gt ${_OUTER_SVR_NAME_LEN_MAX} ];then
            echo "{{OUTER_SVR_NAME_PRICE}} must be a string that contains characters less than 7"
        elif [ ${#OUTER_SVR_NAME_BESTBUY} -gt ${_OUTER_SVR_NAME_LEN_MAX} ];then
            echo "{{OUTER_SVR_NAME_BESTBUY}} must be a string that contains characters less than 7"
        elif [ "$OUTER_SVR_NAME_PRICE" = "$OUTER_SVR_NAME_BESTBUY" ];then
            echo "{{OUTER_SVR_NAME_PRICE}} and {{OUTER_SVR_NAME_BESTBUY}} masy be different"
        else
            Install_old_all
        fi
	elif [ "$1" == "uninstall" ];then
        Uninstall
    else 
        ShowUesage;
    fi
else 
    ShowUesage;
fi
