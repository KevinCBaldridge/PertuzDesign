#!/bin/awk -f

BEGIN{totalcount=0}
/\/DI/	{array[totalcount]=$2
totalcount++
	}
/wt/	{array["wt"]=$2
	for (j=1;j<=length($2);j++)
		pos[j]=0
	}
END	{for (seq in array) 	{
		for (i=1;i<=length(array[seq]);i++) 	{
			if (substr(array[seq],i,1)=="-")
				continue
			else if (substr(array[seq],i,1)==substr(array["wt"],i,1))
				pos[i]++
							}
				}
	for (k=1;k<j;k++)	{
		seqident[k]=(pos[k]-1)/(totalcount)
		print substr(array["wt"],k,1),k, seqident[k]
				}
	}

