#!/bin/awk  -f 
BEGIN{FS=",";}

{
gsub(/\"|\{|\}/,"")
gsub(/\:/,"	")
a[$1]=$0
}
END{
FS=" "
for (key in a)	{
		split(a[key],b[$1],\ )
		}
for (key in b) {print}
}
