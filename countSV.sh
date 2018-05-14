#!/bin/bash 

filename=/home/tuyet/ShearWater/test.log # This is file log 


name=$(awk -F\" '{print $2}' $filename ) 

# Lấy phần chuỗi ngay giữa dấu ""  ==>  name này  cũng là 1  mảng nhưng k  hỉu sao độ dài của nó chỉ =  1  thoai ????? 


array=() 

# Tạo mảng để đếm số lượng các students ban đầu (gồm cả những students trùng lặp nhau) 


for line in $name 

do 


ID=$(echo $line|awk -F, '{print $NF}') 

  array+=( "$ID" ) 

done 

 

total=${#array[@]} 

# số lượng ban đầu 


sorted_array=($(echo "${array[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' ')) 

# Mục đích:  Xóa các phần tử trùng lặp trong mảng hoy ==>  Tạo ra mẳng chỉ chứa các phần tử duy nhất hoy nà  

 #  Tiếp theo chỉ  cần đếm số lượng của từng student hoy(do mảng đã được sort thành duy nhất cho mối student) 

#  Total thì chỉ cần trừ số phần tử lặp là đc 

echo ${sorted_array[@]} 

  

for i in "${sorted_array[@]}" 

do  

  

    c=$(grep -c "$i" $filename) 

  

    echo "So lan student $i la $c" 

  

    total=`expr $total - $c + 1 ` 

  

done 

  

echo " Tong so student truy cap la: $total" 
