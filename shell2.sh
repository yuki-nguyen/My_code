#!/bin/bash

TEMP_FOLDER="/home/tuyet/shell"
LOG_FOLDER="/home/tuyet/shell/CPALOG"

#Check if directory $LOG_FOLDER is exist, if not create new: 

 if [ ! -d "$LOG_FOLDER" ]; then
  echo "Directory $LOG_FOLDER does not exist; create new one"
  mkdir -p $LOG_FOLDER
 fi

#Check if file #/tmp/cpa_183_all.log is exist, if not create temp file: 

 if [ ! -f "$TEMP_FOLDER/cpa_test.log" ]; then
  echo "create temp datafile file $TEMP_FOLDER/cpa_test.log"
  echo "1148040323,20180310" > $TEMP_FOLDER/cpa_test.log
  
 fi 

cd $TEMP_FOLDER

#Define Variable 
LOG_PATH="/home/tuyet/shell/CPALOG/"
LOG_NAME="soap_nohup_"


for line in $(cat cpa_test.log)
  do
    MEMBER_ID=$(echo $line|awk -F, '{print $1}')
    DATE_TEST=$(echo $line|awk -F, '{print $2}')

  for i in $(ls $LOG_PATH${LOG_NAME}${DATE_TEST}*)
    do
      GZ_NAME=$(echo "$i" | awk -F/ '{print $NF}')
      cp $i $TEMP_FOLDER
      gunzip $GZ_NAME
      LOG_NAME_UNZIP=$(echo $GZ_NAME|sed 's/\.gz//g')
      echo $LOG_NAME_UNZIP
      grep "<membershipId>${MEMBER_ID}</membershipId>" -A14 -B37 $LOG_NAME_UNZIP >> $LOG_FOLDER/${MEMBER_ID}_${DATE_TEST}.log
      grep ",membershipId=${MEMBER_ID}"  $LOG_NAME_UNZIP >> $LOG_FOLDER/${MEMBER_ID}_${DATE_TEST}.log
      #grep ",\"membershipId\"\:\"${MEMBER_ID}\""  $LOG_NAME_UNZIP >> $LOG_FOLDER/${MEMBER_ID}_${DATE_TEST}.log
      sed -i 's/^[[:digit:]]*:[[:digit:]]*:[[:digit:]]*\.[[:digit:]]*[ \t]*//g'  $LOG_FOLDER/${MEMBER_ID}_${DATE_TEST}.log 
      sed -i 's/Payload://g' $LOG_FOLDER/${MEMBER_ID}_${DATE_TEST}.log
      sed -i 's/[ \t]*$//g' $LOG_FOLDER/${MEMBER_ID}_${DATE_TEST}.log
      sed -i 's/^[ \t]*//g' $LOG_FOLDER/${MEMBER_ID}_${DATE_TEST}.log
      sed -i 's/[ \t]*<\/messageBody>/ <\/messageBody>/g' $LOG_FOLDER/${MEMBER_ID}_${DATE_TEST}.log
      rm -f $LOG_NAME_UNZIP
    
  done
done
