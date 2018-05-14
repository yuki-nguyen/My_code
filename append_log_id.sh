#!/bin/bash

# url=https://Haukk@bitbucket.org/Haukk/test_bitbucket3.git # đường dẫn tới repository để download source từ github về.

# Ý tưởng nếu để 1 đống url vào 1 file, mỗi hàng là 1 url

file_url="/home/tuyet/Git/file_url.txt"

for origin_url in $file_url

do 

echo "$url" | sed -e 's/"git clone "//'


name_project=$(basename "$url" ".${url##*.}") # Lấy mỗi tên của project về, bỏ đi các kí tự không cần thiết. Cụ thể nó sẽ lấy được tên là tét_bucket3
echo $name_project

path="/home/tuyet/Git" # Đường dẫn tới thư mục mà tại đó ta thực hiện lệnh git clone
cd $path
file_log_ID="$path/$name_project/log_ID_$name_project.txt" # file này chứa id của nó khi git log oneline về

file_log="$path/logID.txt" # file này chứ name và id cần đối chiếu để thay thế


if [ -d "$path/$name_project" ]; then rm -rf $path/$name_project; fi # thwujc hiện xóa thư mục trùng tên với project đi, vì nếu trùng sẽ k clone về được nữa.


git clone $url --quiet # Kiểm tra coi clone về có thành công không
success=$?
if [[ $success -eq 0 ]]; then
		echo "Repository test_bitbucket3 successfully cloned."
	else
        	echo "Something went wrong clone test_bitbucket3, clone fail!"
        fi

git log --oneline --pretty=format:%h -n 1 > $file_log_ID # ghi ID của project vào đây

for line in $(cat $file_log)
	do
	  NAME_PROJECT=$(echo $line|awk -F '=' '{print $1}') # Lấy name của project trong file đối chiếu
	  ID_PROJECT=$(echo $line|awk -F '=' '{print $2}') # Lấy ID của project trong file đối chiếu
	  echo $NAME_PROJECT

	for id in $(cat $file_log_ID)
	  do
	  # so sánh nếu name project giống nhau và id chúng khác nhau thì thay id vô, không thì thêm vào cả name và id vào cuối file
		if [[( "$name_project" = "$NAME_PROJECT") && ("$ID_PROJECT" != "$id")]];then 
			echo "hahahahahahah"
		 ##  sed -i 's/$ID_PROJECT/$id/g' $line
		   str_replace="$name_project=$id"
		    sed -i 's/'"$line"'/'"$str_replace"'/g' $file_log # câu lệnh if này so sánh được rồi nhưng chưa thay thế được.
		    
		    # sed -i -e 's/'"$var1"'/'"$var2"'/g' /tmp/file.txt
		fi
		if ! grep -q "$name_project=" $file_log ; then
		    echo "$name_project=$id" >> $file_log
		fi
	  done
done
done 
