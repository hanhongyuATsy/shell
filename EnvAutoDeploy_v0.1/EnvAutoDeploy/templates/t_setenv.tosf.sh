############################################################### init

# for deploying
DEPLOY_DIR={{RUNTIME_DIR}}

############################################################### lib

# oracle
export ORACLE_HOME=$DEPLOY_DIR/lib/ora11g/product/11.2.0
# export ORA_NLS33=$ORACLE_HOME/ocommon/nls/admin/data
export NLS_LANG=AMERICAN_AMERICA.ZHS16GBK

# tuxedo (only for afpp_svr)
# export TUXDIR=$DEPLOY_DIR/lib/tuxedo9.1
export ULOGPFX=$DEPLOY_DIR/log/ULOG

# tode
export TODEHOMEDIR=$DEPLOY_DIR/lib/tode
export TODECFGDIR=$DEPLOY_DIR/config
export TODELOGDIR=$DEPLOY_DIR/log
export TODEAPPDIR=$DEPLOY_DIR/app
export MCCFGDIR=$DEPLOY_DIR/config
export MCLOGDIR=$DEPLOY_DIR/log
export HTPXRUNDIR=$TODELOGDIR
export WSLADDR=//{{IP}}:{{PORT_OUTER_WSL}}

# tosf
export TOSF_HOME=$DEPLOY_DIR/lib/tosf
export TOSFTOOLS_HOME=$DEPLOY_DIR/lib/tosf/tosftools

# tlh
export TSCAGENT=$DEPLOY_DIR/app

# icu
export ICU_HOME=$DEPLOY_DIR/lib/icu

# boost
export BOOST_HOME=$DEPLOY_DIR/lib/boost

# xerces
export XERCES_HOME=$DEPLOY_DIR/lib/xerces

############################################################### system

export CC=g++
export LC_CTYPE=zh_CN.GBK
export PATH=$TODEHOMEDIR/bin:$TODEAPPDIR:$TSCAGENT/bin:/sbin:$PATH
export LD_LIBRARY_PATH=$TUXDIR/lib:$TODEHOMEDIR/lib:$TOSFTOOLS_HOME:$ICU_HOME/lib:$ORACLE_HOME/lib:$BOOST_HOME/lib:$XERCES_HOME/lib:$TOSF_HOME/lib

############################################################### done

unset DEPLOY_DIR

alias pwds='echo $USER@$IP:`pwd`'
