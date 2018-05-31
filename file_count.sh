#!/bin/bash

echo "###################################"
echo "########2018-04-18#################"
echo "########write_by_hhy###############"
echo "########code_compare_start#########"
echo "###################################"

echo "###########traversal dir##############"

PATH_BESTBUY="/mnt/d/git_code_new/Dbestbuy/src"
PATH_DPRICE="/mnt/d/git_code_new/Dprice_Merge"


function read_dir(){
    for file in `ls $1`
    do
        if [ -d $1"/"$file ];then
            read_dir $1"/"$file
        else
            NAME_HEAD=`echo ${file:4}`
            echo $NAME_HEAD 
            if [ "$DIFF_LINES" -ne "0" ]; then
            fi

        fi
    done
}

read_dir $PATH_BESTBUY 

