
#ifndef TOSFDEFINE_H
#define TOSFDEFINE_H
static char _tosf_define_h_ID[]="@(#) $Id: TosfDefine.h,v 1.2 2007/06/06 01:39:07 tosf Exp $";

#define TOSFAPPID "{{OUTER_SVR_NAME_BESTBUY}}"
#define TOSFLOGID "4100"
#define RDLOGID "04"
#define CWANUM 5
#define MAXSERIALNO 10000000
#define MAXAPPMACHINE 50
#define MAXAPPIDLEN 20
#define MAXVERSIONLEN 1024
#define MAXAPP 50
#define MAXPLUGINOPTLEN 50

#define TOSFSYNREQMSG        1
#define TOSFASYNREQMSGCLNT   2
#define TOSFSYNREPMSG        3
#define TOSFASYNREQMSGOLTP   4
#define TOSFASYNREPMSG       5
#define TOSFNOREPMSG         6
#define TOSFTIMEOUTMSG       7


#define TAGLEN          10
#define VERSIONLEN      10
#define SYSLEN          15
#define SQIDLEN         30
#define GDSLEN          20
#define SYSIDLEN        10
#define PIDLEN          50
#define CWALEN          1
#define SESSIONIDLEN    60
#define LANGLEN         10
#define ROUTINFOLEN     15
#define SERIALNOLEN     50
#define APPVERSIONLEN   100

#define SVCNAMELEN      15

#define SUCCESS         0
#define CTXNOTEXIST     1
#define ERRSERIALNO     2
#define NONEEDTOFORWARD 3  // ����Ҫ����������, ֱ��tpreturn TPSUCCESS, APP_FE_RCV����APP_CTX_GETʱ���ܵõ����, ��ʾ�첽Ӧ�������һ�������Ƕ����

#define NOCTXT          0
#define CTXTTEMP        1
#define CTXTPERM        2

#define CMGCLRALL       1
#define CMGCLRONE       2

#define CTXMGCLRALL     3
#define CTXMGCLRONE     2
#define CTXMGTIMEOUT    1

#define CTXUPDATE       0
#define CTXRESET        1

#define DBRTMGCLRONE    1

#define UPGRADEAPP      1
#define ROLLBACKAPP     2

#define USRPLUGNODEF    "NODEFINE"

typedef struct tosf_header{
    char tag[TAGLEN + 1];
    char version[VERSIONLEN + 1];
    char oriSys[SYSLEN + 1];
    char desSys[SYSLEN + 1];
    char callBackSys[SYSLEN + 1];
    int msgType;
    char sequenceID[SQIDLEN + 1];
    char sysID[SYSIDLEN + 1];
    char gds[GDSLEN + 1];
    char cwa[CWALEN + 1];
    char pid[PIDLEN + 1];
    int ctxType;
    char lang[LANGLEN + 1];
    int traceLevel;
    char resHdr[TAGLEN + 1];
    long resLen;
}tosf_hdr_t;

#endif

