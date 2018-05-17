#!/bin/bash

# url=https://Haukk@bitbucket.org/Haukk/test_bitbucket3.git # đường dẫn tới repository để download source từ github về.

path="/home/tuyet/Git" # Đường dẫn tới thư mục mà tại đó ta thực hiện lệnh git clone

File_for_customer="$path/For_customer.txt" # f
rm -rf $File_for_customer 

# Ý tưởng nếu để 1 đống url vào 1 file, mỗi hàng là 1 câu lệnh git clone url

file_url="/home/tuyet/Git/file_url.txt"
sed -i '/^$/d' $file_url # Xóa tất cả các dòng trắng có tồn tại trong file 

while IFS= read -r origin_url|| [ -n "$origin_url" ];  # Thay cho while read -r origin_url # Đọc file này để đọc từng hàng trong file, mỗi câu lệnh git clone là 1 giá trị

do

echo $origin_url
url=`echo $origin_url |cut -d " " -f3` # Lấy mỗi cái url thôi, bỏ chữ git clone đi


name_project=$(basename "$url" ".${url##*.}") # Lấy mỗi tên của project về, bỏ đi các kí tự không cần thiết. Cụ thể nó sẽ lấy được tên là tét_bucket3
echo $name_project


cd $path
file_log_ID="$path/$name_project/log_ID_$name_project.txt" # file này chứa id của nó khi git log oneline về

file_log="$path/logID.txt" # file này chứ name và id cần đối chiếu để thay thế

if [ ! -f "$file_log" ]
then
	echo "name=id">$file_log
fi

if [ -d "$path/$name_project" ]; then rm -rf $path/$name_project; fi # thwujc hiện xóa thư mục trùng tên với project đi, vì nếu trùng sẽ k clone về được nữa.


git clone $url --quiet # Kiểm tra coi clone về có thành công không
success=$?
if [[ $success -eq 0 ]]; then
		echo "Repository $name_project successfully cloned."
	else
        	echo "Something went wrong clone $name_project, clone fail!"
		continue
        fi
cd $name_project
git log --oneline --pretty=format:%h -n 1 > $file_log_ID # ghi ID của project vào đây
git log --pretty=format:'%h %<(20)%an %s'| awk -F '|' '{ printf "%s %-20s %s\n", $1, $2, $3 }' > temp_log.txt
id=$(cat $file_log_ID) # id mới nhất vừa clone về
echo "This is information for $name_project:" >> $File_for_customer
while read -r line_temp
	do
	id_old=`echo $line_temp|cut -d " " -f1`
	if [[ $id_old != $id ]]; then
	      echo $line_temp >> $File_for_customer
	else
	       echo "$id_old is nearest id that you commit" >> $File_for_customer
	       break
    fi

done <"temp_log.txt"

for line in $(cat $file_log)
	do
	  NAME_PROJECT=$(echo $line|awk -F '=' '{print $1}') # Lấy name của project trong file đối chiếu
	  ID_PROJECT=$(echo $line|awk -F '=' '{print $2}') # Lấy ID của project trong file đối chiếu
	  echo $NAME_PROJECT

     if [[( "$name_project" = "$NAME_PROJECT") && ("$ID_PROJECT" != "$id")]];then
		 ##  sed -i 's/$ID_PROJECT/$id/g' $line
		   str_replace="$name_project=$id"
		    sed -i 's/'"$line"'/'"$str_replace"'/g' $file_log # câu lệnh if này so sánh được rồi nhưng chưa thay thế được.

		    # sed -i -e 's/'"$var1"'/'"$var2"'/g' /tmp/file.txt
		fi
		if ! grep -q "$name_project=" $file_log ; then
		    echo "$name_project=$id" >> $file_log
		fi
    done
rm -rf temp_log.txt
rm -rf $file_log_ID
done < "$file_url"
