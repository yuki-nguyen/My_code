#!/bin/bash

url=https://Haukk@bitbucket.org/Haukk/test_bitbucket3.git 

name_project=$(basename "$url" ".${url##*.}")
echo $name_project

path="/home/tuyet/Git"
cd $path
file_log_ID="$path/$name_project/log_ID_$name_project.txt"

file_log="$path/logID.txt"


if [ -d "$path/$name_project" ]; then rm -rf $path/$name_project; fi


git clone $url --quiet
success=$?
if [[ $success -eq 0 ]]; then
		echo "Repository test_bitbucket3 successfully cloned."
	else
        	echo "Something went wrong clone test_bitbucket3, clone fail!"
        fi

git log --oneline --pretty=format:%h -n 1 > $file_log_ID

for line in $(cat $file_log)
	do
	  NAME_PROJECT=$(echo $line|awk -F '=' '{print $1}')
	  ID_PROJECT=$(echo $line|awk -F '=' '{print $2}')
	  echo $NAME_PROJECT

	for id in $(cat $file_log_ID)
	  do
		if [[( "$name_project" = "$NAME_PROJECT") && ("$ID_PROJECT" != "$id")]];then
			echo "hahahahahahah"
		 ##  sed -i 's/$ID_PROJECT/$id/g' $line
		   str_replace="$name_project=$id"
		    sed -i 's/"$line"/"$str_replace"/g' $file_log
		fi
	  done
done
