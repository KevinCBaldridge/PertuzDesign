#!/bin/gawk -f

BEGIN{totalcount=0}
/\/DI/	{array[totalcount]=$2
totalcount++
	}
/wt/	{array["wt"]=$2
	for (j=1;j<=length($2);j++)
		A[j]=0+0
		C[j]=0+0
		D[j]=0+0
		E[j]=0+0
		F[j]=0+0
		G[j]=0+0
		H[j]=0+0
		I[j]=0+0
		K[j]=0+0
		L[j]=0+0
		M[j]=0+0
		N[j]=0+0
		P[j]=0+0
		Q[j]=0+0
		R[j]=0+0
		S[j]=0+0
		T[j]=0+0
		V[j]=0+0
		W[j]=0+0
		Y[j]=0+0
	}
END	{PROCINFO["sorted_in"] = "@val_num_desc"
#	OFS=" ";
#	for(m=1;m<=j;m++) print m+0,A[m]+0,C[m]+0,D[m]+0,E[m]+0,F[m]+0,G[m]+0,H[m]+0,I[m]+0,K[m]+0,L[m]+0,M[m]+0,N[m]+0,P[m]+0,Q[m]+0,R[m]+0,S[m]+0,T[m]+0,V[m]+0,W[m]+0,Y[m]+0
#	OFS="	"
	for (seq in array) 	{
		for (i=1;i<=length(array[seq]);i++) 	{
			if (substr(array[seq],i,1)=="-")
				continue
#				[21,i]++
			else if (substr(array[seq],i,1)=="A")
				A[i]++
			else if (substr(array[seq],i,1)=="C")
				C[i]++
			else if (substr(array[seq],i,1)=="D")
				D[i]++
			else if (substr(array[seq],i,1)=="E")
				E[i]++
			else if (substr(array[seq],i,1)=="F")
				F[i]++
			else if (substr(array[seq],i,1)=="G")
				G[i]++
			else if (substr(array[seq],i,1)=="H")
				H[i]++
			else if (substr(array[seq],i,1)=="I")
				I[i]++
			else if (substr(array[seq],i,1)=="K")
				K[i]++
			else if (substr(array[seq],i,1)=="L")
				L[i]++
			else if (substr(array[seq],i,1)=="M")
				M[i]++
			else if (substr(array[seq],i,1)=="N")
				N[i]++
			else if (substr(array[seq],i,1)=="P")
				P[i]++
			else if (substr(array[seq],i,1)=="Q")
				Q[i]++
			else if (substr(array[seq],i,1)=="R")
				R[i]++
			else if (substr(array[seq],i,1)=="S")
				S[i]++
			else if (substr(array[seq],i,1)=="T")
				T[i]++
			else if (substr(array[seq],i,1)=="V")
				V[i]++
			else if (substr(array[seq],i,1)=="W")
				W[i]++
			else if (substr(array[seq],i,1)=="Y")
				Y[i]++
			else 
				print "seems like noncanonical amino acid? value is:	substr(array[seq],i,1)"

							}
				}
	for (k=1;k<j;k++)	{

		if(A[k]>0) count["A"]=A[k]-1; else count["A"]=A[k]+0
		if(C[k]>0) count["C"]=C[k]-1; else count["C"]=C[k]+0
		if(D[k]>0) count["D"]=D[k]-1; else count["D"]=D[k]+0
		if(E[k]>0) count["E"]=E[k]-1; else count["E"]=E[k]+0
		if(F[k]>0) count["F"]=F[k]-1; else count["F"]=F[k]+0
		if(G[k]>0) count["G"]=G[k]-1; else count["G"]=G[k]+0
		if(H[k]>0) count["H"]=H[k]-1; else count["H"]=H[k]+0
		if(I[k]>0) count["I"]=I[k]-1; else count["I"]=I[k]+0
		if(K[k]>0) count["K"]=K[k]-1; else count["K"]=K[k]+0
		if(L[k]>0) count["L"]=L[k]-1; else count["L"]=L[k]+0
		if(M[k]>0) count["M"]=M[k]-1; else count["M"]=M[k]+0
		if(N[k]>0) count["N"]=N[k]-1; else count["N"]=N[k]+0
		if(P[k]>0) count["P"]=P[k]-1; else count["P"]=P[k]+0
		if(Q[k]>0) count["Q"]=Q[k]-1; else count["Q"]=Q[k]+0
		if(R[k]>0) count["R"]=R[k]-1; else count["R"]=R[k]+0
		if(S[k]>0) count["S"]=S[k]-1; else count["S"]=S[k]+0
		if(T[k]>0) count["T"]=T[k]-1; else count["T"]=T[k]+0
		if(V[k]>0) count["V"]=V[k]-1; else count["V"]=V[k]+0
		if(W[k]>0) count["W"]=W[k]-1; else count["W"]=W[k]+0
		if(Y[k]>0) count["Y"]=Y[k]-1; else count["Y"]=Y[k]+0
#		n=asort(count,countsorted)
		q=1
		for (aa in count) 	{
					rankorder[k][q]=aa
					rankpct[k][q]=(count[aa]/totalcount)
					q++
					}
		for(p=1;p<=q;p++) if(substr(array["wt"],k,1)==rankorder[k][p]) {if(rankpct[k][p]==0) ranktop[k]=20;	else ranktop[k]=p}
		print "k=" k ",wt=" substr(array["wt"],k,1) ", ranktop[k]=" ranktop[k]
		
#print substr(rankorder[k],2,length(rankorder[k])),substr(rankpct[k][p],2,length(rankpct[k][p]))
#		for (r=n;r>0;r--) if(countsorted[r] in count) print "k=" k, "r=" r, "countsorted[r]=" countsorted[r]
#		sortme["-"]=[21,k]
#		for (aa in sortme) print "k=" k, "count=" aa, "aa=" sortme[aa]
#		for (r=n;r>0; r--) print "k=" k, "r=" r, "sortme[sorted[r]],aa=	" sortme[sorted[r]]
#		for (r=1;r<21;r++) print "k=" k, "r=" r, "[r,k]=" [r,k]
#		print sorted[1],sortme[sorted[1]]
#		print "ition:	" k "		sortme[wt[k]]:	" sortme[wt[k]]
#		seqident[k]=([k]-1)/(totalcount)
#		print substr(array["wt"],k,1),k, seqident[k]
				}
	}

