#!/bin/bash

echo "###################################"
echo "########2018-04-18#################"
echo "########write_by_hhy###############"
echo "########code_compare_start#########"
echo "###################################"

echo "###########traversal dir##############"

PATH_BESTBUY="/mnt/d/git_code_new/Dbestbuy/src"
PATH_DPRICE="/mnt/d/git_code_new/Dprice_Merge"

function wc_code_diff_lines()
{
    #echo "###########diff file##############"
    #echo "s1"$1
    #echo "s2"$2
    diff -B $1 $2 > ./diff_test.txt
    
    #echo "###########wc line##############"
    FILE2_LINE_MORE=`sed -n '/>/p' ./diff_test.txt | wc -l`
    #echo $FILE2_LINE_MORE
    FILE2_LINE_LESS=`sed -n '/</p' ./diff_test.txt | wc -l`
    #echo $FILE2_LINE_LESS
    DIFF_LINES=`expr $FILE2_LINE_MORE + $FILE2_LINE_LESS`
}


function read_dir(){
    for file in `ls $1`
    do
        if [ -d $1"/"$file ];then
            PATH_BESTBUY_FULL_NAME="$1"/"$file"
            FULL_NAME=`echo ${PATH_BESTBUY_FULL_NAME:32}`
            PATH_DPRICE_FULL_NAME="$PATH_DPRICE$FULL_NAME"/""
            if [ ! -d $PATH_DPRICE_FULL_NAME ];then
                #cp $1"/"$file $2"/" -rvp  
                #echo "diff dir: $PATH_DPRICE_FULL_NAME"
                cp $PATH_BESTBUY_FULL_NAME $PATH_DPRICE_FULL_NAME -rvp 
            else
                read_dir $1"/"$file
            fi
        else
            PATH_BESTBUY_FULL_NAME="$1"/"$file"
            FULL_NAME=`echo ${PATH_BESTBUY_FULL_NAME:32}`
            PATH_DPRICE_FULL_NAME="$PATH_DPRICE$FULL_NAME"
            DIR_NAME=`echo ${PATH_DPRICE_FULL_NAME%/*}`
            DIR_NAME=$DIR_NAME"/"
            echo $DIR_NAME
            if [ ! -f $PATH_DPRICE_FULL_NAME ];then
                #echo "diff file: $PATH_DPRICE_FULL_NAME "
                cp $PATH_BESTBUY_FULL_NAME $PATH_DPRICE_FULL_NAME 
            else
                wc_code_diff_lines  $PATH_BESTBUY_FULL_NAME $PATH_DPRICE_FULL_NAME 
                if [ "$DIFF_LINES" -ne "0" ]; then
                    #echo "change name: $file"
                    NEW_FILE_NAME="dbb_"$file 
                    #echo $DIR_NAME
                    cp $PATH_BESTBUY_FULL_NAME "$DIR_NAME$NEW_FILE_NAME"  
                fi
            fi
        fi
    done
}

read_dir $PATH_BESTBUY 

