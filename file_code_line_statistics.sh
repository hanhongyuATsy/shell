#!/bin/bash

echo "###################################"
echo "########2018-04-18#################"
echo "########write_by_hhy###############"
echo "########code_compare_start#########"
echo "###################################"

echo "###########traversal dir##############"

PATH_BESTBUY="/mnt/d/git_code/Dbestbuy/src/Engine/PricingEngine"


function read_dir(){
    for file in `ls $1`
    do
        if [ -d $1"/"$file ]
        then
            read_dir $1"/"$file
        else
            PATH_BESTBUY_FULL_NAME=`echo $1"/"$file`
            #echo $PATH_BESTBUY_FULL_NAME
            FULL_NAME=`echo ${PATH_BESTBUY_FULL_NAME:39}`
            FILE_NAME=`echo ${FULL_NAME##*/}`
            DIR_NAME=`echo ${FULL_NAME%/*}`
            #echo $FULL_NAME
            FILE_LINES=`wc -l $PATH_BESTBUY_FULL_NAME | cut -f1 -d' '`
            printf "%-40s,%-40s,%-10d,%-10s\n" $DIR_NAME $FILE_NAME $FILE_LINES "type2"
        fi
    done
}

read_dir $1

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
