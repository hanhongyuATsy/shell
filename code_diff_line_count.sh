#!/bin/bash

echo "###################################"
echo "########2018-04-18#################"
echo "########write_by_hhy###############"
echo "########code_compare_start#########"
echo "###################################"

echo "###########traversal dir##############"

PATH_BESTBUY="/mnt/d/git_code/Dbestbuy/src/Engine/PricingEngine"
PATH_DPRICE="/mnt/d/git_code/DPrice/Engine/PricingEngine"

function wc_code_diff_lines()
{
    #echo "###########diff file##############"
    diff -B $1 $2 > ./diff_test.txt
    
    #echo "###########wc line##############"
    FILE2_LINE_MORE=`sed -n '/>/p' ./diff_test.txt | wc -l`
    #echo $FILE2_LINE_MORE
    FILE2_LINE_LESS=`sed -n '/</p' ./diff_test.txt | wc -l`
    #echo $FILE2_LINE_LESS
    DIFF_LINES=`expr $FILE2_LINE_MORE + $FILE2_LINE_LESS`
}

function diff_dir(){
    for file in `ls $1`
    do
        if [ -d $1"/"$file ] 
        then
            diff_dir $1"/"$file
        else
            DIFF_PATH_DPRICE_FULL_NAME=`echo $1"/"$file`
            DIFF_FULL_NAME=`echo ${DIFF_PATH_DPRICE_FULL_NAME:43}`
            DIFF_FILE_NAME=`echo ${DIFF_FULL_NAME##*/}`
            DIFF_DIR_NAME=`echo ${DIFF_FULL_NAME%/*}`
            DIFF_PATH_BESTBUY_FULL_NAME=`echo $PATH_BESTBUY"/"$DIFF_FULL_NAME`
            #echo $DIFF_FULL_NAME
            if [ ! -f $DIFF_PATH_BESTBUY_FULL_NAME ];then
                FILE_LINES=`wc -l $DIFF_PATH_DPRICE_FULL_NAME | cut -f1 -d' '`
                #printf "%-40s %-10d %-10s\n" $DIFF_FILE_NAME $FILE_LINES "type1"
                #printf "%-40s %-40s %-10d %-10s\n" $DIFF_DIR_NAME $DIFF_FILE_NAME $FILE_LINES "type1"
                printf "%-40s,%-40s,%-10d,%-10s\n" $DIFF_DIR_NAME $DIFF_FILE_NAME $FILE_LINES "type1"
            fi
            OLD_DIFF_FULL_NAME=$DIFF_FULL_NAME
        fi
    done
}

diff_dir $PATH_DPRICE

function read_dir(){
    for file in `ls $1`
    do
        if [ -d $1"/"$file ]
        then
            read_dir $1"/"$file
        else
            PATH_BESTBUY_FULL_NAME=`echo $1"/"$file`
            #echo $PATH_BESTBUY_FULL_NAME
            FULL_NAME=`echo ${PATH_BESTBUY_FULL_NAME:49}`
            FILE_NAME=`echo ${FULL_NAME##*/}`
            DIR_NAME=`echo ${FULL_NAME%/*}`
            #echo $FULL_NAME
            PATH_DPRICE_FULL_NAME=`echo $PATH_DPRICE$FULL_NAME`             
            if [ ! -f $PATH_DPRICE_FULL_NAME ];then
                FILE_LINES=`wc -l $PATH_BESTBUY_FULL_NAME | cut -f1 -d' '`
                #echo  $FILE_NAME"  "$FILE_LINES"  ""type2"
                #printf "%-40s %-10d %-10s\n" $FILE_NAME $FILE_LINES "type2"
                #printf "%-40s %-40s %-10d %-10s\n" $DIR_NAME $FILE_NAME $FILE_LINES "type2"
                printf "%-40s,%-40s,%-10d,%-10s\n" $DIR_NAME $FILE_NAME $FILE_LINES "type2"
            else
                wc_code_diff_lines $PATH_BESTBUY_FULL_NAME $PATH_DPRICE_FULL_NAME  
                if [ "$DIFF_LINES" -eq "0" ]
                then
                    #printf "%-40s %-10d %-10s\n" $FILE_NAME $DIFF_LINES "type4"
                    #printf "%-40s %-40s %-10d %-10s\n" $DIR_NAME $FILE_NAME $DIFF_LINES "type4"
                    printf "%-40s,%-40s,%-10d,%-10s\n" $DIR_NAME $FILE_NAME $DIFF_LINES "type4"
                else
                    #printf "%-40s %-10d %-10s\n" $FILE_NAME $DIFF_LINES "type3"
                    #printf "%-40s %-40s %-10d %-10s\n" $DIR_NAME $FILE_NAME $DIFF_LINES "type3"
                    printf "%-40s,%-40s,%-10d,%-10s\n" $DIR_NAME $FILE_NAME $DIFF_LINES "type3"
                fi
            fi
        fi
    done
}

read_dir $PATH_BESTBUY

#function dir_rake()
#{
#    for file in $PATH_BESTBUY/*
#    do 
#        if test -f $file
#        then
#            echo "$file" 
#            #echo "$PATH_DPRICE/$1/$file" 
#        fi
#        if test -d $file
#        then
#            echo "$file is dir" 
#        fi
#    done
#    exit
#}

#diff -B dfsqargument.cc /mnt/d/git_code/Dbestbuy/src/Engine/PricingEngine/Argument/dfsqargument.cc > ./diff_test.txt
