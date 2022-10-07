#need to pass as an argument a file containing list of scorefiles to analyze additionally, need to have a file colKeys1.tsv that specifies order and exactly the score 
#names (i.e. dG_separated/dSASAx100)
#separated by having one per line

import scipy
import numpy as np
import pandas as pd
import sys
import os
import matplotlib as mpl
import matplotlib.pyplot as plt
import seaborn
#define the little function for getting seq from pdb so I can use a proper apply instead of looping over rows
#note that this contains conditionals that are dependent on this-run specific filename formatting, so must be adjusted for different filename starts
seaborn.set(style='ticks')
#read in universal data and initialize things for counting
keydf = pd.read_csv(r'colKeys1.tsv',sep = '	', header = None)
dfAvRR = pd.DataFrame(index=['Ptz_H','Tsz_H','Ptz_L','Tsz_L'],dtype=float)
dfTops = pd.DataFrame()
colList1 = list(keydf[0])
argScorefileList = sys.argv[1]
i = 1

#initialize an empty dataframe so I can avoid decision later about whether to copy/create or append the first loop
dftot = pd.DataFrame()
#loop over the lines in the passed file of scorefiles
with open(argScorefileList) as scorelistF:
 for line in scorelistF:
  line1 = line.rstrip('\n')
  with open(line1) as f1:
   jsonobj = f1.read()
   trial = pd.read_json(jsonobj, lines = 'true')
   #subset the data by pulling out the scores we care about 
   triala = trial.loc[:,colList1]
   #set the line1 string and add it as a column for all the included data
   pathname, line2 = os.path.split(line1)
   triala['scFilename'] = line2
   #this subsets the data into relaxed and unrelaxed by adding a column with that label accordingly
   #this method was chosen from this post https://stackoverflow.com/questions/50375985/pandas-add-column-with-value-based-on-condition-based-on-other-columns
   triala['rlxBool'] = False
   triala.loc[triala['decoy'].str.startswith("DII"),'rlxBool']= True
   triala['decoy'] = triala['decoy'].str.replace('pre_model_1','pre_model_1_')
   triala['decoyFilename'] = f'{pathname}/'
   triala['decoyFilename'] = triala['decoyFilename']+triala['decoy']+'.pdb'
   dfSeq = pd.read_csv(f'dfSeq.{line2[0:-6]}.csv', header=0)
   triala = pd.merge(triala,dfSeq,how='outer',on='decoyFilename')

   #this adds a column indicating the mutant 
   #this method was chosen from this post https://stackoverflow.com/questions/50375985/pandas-add-column-with-value-based-on-condition-based-on-other-columns
#   triala = triala.assign('mutant'=None)
   triala['mutant']=None
#   print(triala)
   print(triala.head())
   triala.loc[triala['decoy'].str.contains("Ptz"),'mutant'] = 'Ptz'
   triala.loc[triala['decoy'].str.contains("Tsz"),'mutant'] = 'Tsz'

   #let's go ahead and count the instances of WT seq in each CDR for each mutant and for the total dataframe
#   dict1 = {'H1seq' : 'AASGFTFTDYTMD', 'H2seq' : 'DVNPNSGGSI', 'H4seq' : 'VDRSKNTL'}
#   print( dict1['H1wt'])
#   print(f'dict1 = {dict1}')
#   listindex1 = pd.Series(['Ptz_H','Tsz_H','Ptz_L','Tsz_L'])
 # AvRR = pd.DataFrame(index=listindex1)
   #now append the dataframe to the total dataset
   dftot = dftot.append(triala)
   i += 1
#fix duplicate index problems
 dftot.set_index(dftot['decoyFilename'],drop=False,inplace=True,verify_integrity=True)
 sortdict = {'dG_separated/dSASAx100':True,'sc_value':False,'hbonds_int':False,'dG_cross/dSASAx100':True,'delta_unsatHbonds':True}
 listlevels = ['dG_separated/dSASAx100','dG_cross/dSASAx100', 'delta_unsatHbonds','sc_value','total_score','side1_normalized','side2_normalized','hbonds_int']
 maxs=pd.Series(index=listlevels,dtype=float)
 mins=pd.Series(index=listlevels,dtype=float)
 maxsy=pd.Series(index=listlevels,dtype=float)
 minsy=pd.Series(index=listlevels,dtype=float)
#rearrange columns, specifically move the last 3 columns to the front
 collist=dftot.columns.to_list()
 #print(f'collist={collist}')
 collist=collist[0:1] + collist[-4:-1] + collist[1:-4] + collist[-1:]
 #print(f'collist={collist}')
 #print(dftot)
 dftot=dftot[collist]
 #print(dftot)
#write out to file 
 dftot.to_csv(f'dftot.wSeq.csv')
#set up a dictionary for CDR and the wt seq
 CDRwtseq = {'H1seq':'AASGFTFTDYTMD', 'H2seq':'DVNPNSGGSI','H4seq':'VDRSKNTL','H3seq':'ARNLGPSFYFDY'}
	#'L1seq':'KASQDVSIGVA','L2seq':'YSASYRYT','L4seq':'GFGTDF','L3seq':'QQYYIYPYT'}
#initialize a dataframe for DRR for CDR lengths
 DRR_CDRlength = pd.DataFrame(dtype=float)

#loop over the listlevels to plot overall KDE and set the axes for later
 for level1 in listlevels:
  totKDEax=dftot[level1].plot.kde()
  plt.savefig(f'KDE.allsets.{str(level1)[0:8]}.png')
  plt.savefig(f'KDE.allsets.{str(level1)[0:8]}.png')
  plt.close()
  totScatterax = seaborn.scatterplot(x=dftot['dG_separated/dSASAx100'],y=dftot[level1],hue=dftot['scFilename'])
  Rvalue1 = dftot['dG_separated/dSASAx100'].corr(dftot[level1])
  R2value1 = Rvalue1*Rvalue1
#  totScatterax.text(1,1,f'R^2 = {R2value1}')
  dummy1 = totScatterax.get_xlim()
  mins[level1] = dummy1[0]
  maxs[level1] = dummy1[1]
  dummy2 = totScatterax.get_ylim()
  minsy[level1] = dummy2[0]
  maxsy[level1] = dummy2[1]
  axdummy1 =plt.plot([], [], ' ', label=f'R^2 = {R2value1}')
  plt.savefig(f'allsets.{str(level1)[0:8]}_dG_separ.scatter.png')
  plt.close()
#initialize a dataframe for holding calculated AvRRs
 for scfile in dftot['scFilename'].unique():
  dfsubset2 = dftot.loc[dftot['scFilename']==str(scfile),:]
  for boolval in [False,True]:
   dfsubset1 = dfsubset2.loc[dfsubset2['rlxBool']==boolval,:]
   trialaS = dfsubset1.loc[(dfsubset1['mutant']=='Ptz_H'),:]
   trialaA = dfsubset1.loc[(dfsubset1['mutant']=='Tsz_H'),:]
   trialaF = dfsubset1.loc[(dfsubset1['mutant']=='Ptz_L'),:]
   trialaY = dfsubset1.loc[(dfsubset1['mutant']=='Tsz_L'),:]

#for  each scorefile and each relax+- dfsubset1, plot logo for top 10% of sequences
#loop also over mutants for this part, and I'll calculated DRR also here at least for native seq feature
   for feature in sortdict:
    Slen = len(trialaS.index)
    Stoplen = int(round(0.1*Slen))
#    print(f'Slen={Slen}')
#    print(f'Stoplen={Stoplen}')
    StopFeature = trialaS.sort_values(by=feature,ascending=sortdict[feature]).head(Stoplen)
    StopFeature['rankMetric']=str(feature)[0:8]
#    print(StopFeature)
    Alen = len(trialaA.index)
    Atoplen = int(round(0.1*Alen))
    AtopFeature = trialaA.sort_values(by=feature,ascending=sortdict[feature]).head(Atoplen)
    AtopFeature['rankMetric']=str(feature)[0:8]
    Flen = len(trialaF.index)
    Ftoplen = int(round(0.1*Flen))
    FtopFeature = trialaF.sort_values(by=feature,ascending=sortdict[feature]).head(Ftoplen)
    FtopFeature['rankMetric']=str(feature)[0:8]
    Ylen = len(trialaY.index)
    Ytoplen = int(round(0.1*Ylen))
    YtopFeature = trialaY.sort_values(by=feature,ascending=sortdict[feature]).head(Ytoplen)
    YtopFeature['rankMetric']=str(feature)[0:8]
    dfTops = dfTops.append(StopFeature)
    dfTops = dfTops.append(AtopFeature)
    dfTops = dfTops.append(FtopFeature)
    dfTops = dfTops.append(YtopFeature)
#    print(dfTops)



#for each scorefile and for only pre-relax models since seqs are same, calc AvRR for each mutant
   dfWTSeqCounts = pd.DataFrame(index=['Ptz_H','Tsz_H','Ptz_L','Tsz_L','all'],dtype=float)
   for cdrnum in CDRwtseq:
#decision to apply wtseq counting if the current boolval iterator is false
#     print(f'scorefile is {scfile}')
    if boolval == False:
     dfWTSeqCounts.loc['Ptz_H',cdrnum]=len(trialaS[trialaS[cdrnum].str.match(CDRwtseq[cdrnum])])
     dfWTSeqCounts.loc['Tsz_H',cdrnum]=len(trialaA[trialaA[cdrnum].str.match(CDRwtseq[cdrnum])])
     dfWTSeqCounts.loc['Ptz_L',cdrnum]=len(trialaF[trialaF[cdrnum].str.match(CDRwtseq[cdrnum])])
     dfWTSeqCounts.loc['Tsz_L',cdrnum]=len(trialaY[trialaY[cdrnum].str.match(CDRwtseq[cdrnum])])
     dfWTSeqCounts.loc['all',cdrnum]=len(dfsubset1[dfsubset1[cdrnum].str.match(CDRwtseq[cdrnum])])
     denom = dfWTSeqCounts.loc['all',cdrnum] / len(dfsubset1.index)
     Sfreq = dfWTSeqCounts.loc['Ptz_H',cdrnum] / len(trialaS.index)
     Afreq = dfWTSeqCounts.loc['Tsz_H',cdrnum] / len(trialaA.index)
     Ffreq = dfWTSeqCounts.loc['Ptz_L',cdrnum] / len(trialaF.index)
     Yfreq = dfWTSeqCounts.loc['Tsz_L',cdrnum] / len(trialaY.index)
#if block to avoid divide by zero error, assigning negative 1 as the avrr if this is the case to differentiate 
     if denom == 0:
      Savrr = -1
      Aavrr = -1
      Favrr = -1
      Yavrr = -1
     else:
      Savrr = Sfreq/denom
      Aavrr = Afreq/denom
      Favrr = Ffreq/denom
      Yavrr = Yfreq/denom
     dfAvRR[f'{str(cdrnum)[0:2]}_{str(scfile)[:-3]}'] = pd.Series([Savrr, Aavrr, Favrr, Yavrr],index=['Ptz_H','Tsz_H','Ptz_L','Tsz_L'])
     if cdrnum == 'H4seq':
      continue
     else:
#      print(f'len(CDRwtseq[cdrnum])={len(CDRwtseq[cdrnum])}')
      Snativelen = trialaS.loc[trialaS[cdrnum].str.len()==len(CDRwtseq[cdrnum]),cdrnum]
      Anativelen = trialaA.loc[trialaA[cdrnum].str.len()==len(CDRwtseq[cdrnum]),cdrnum]
      Fnativelen = trialaF.loc[trialaF[cdrnum].str.len()==len(CDRwtseq[cdrnum]),cdrnum]
      Ynativelen = trialaY.loc[trialaY[cdrnum].str.len()==len(CDRwtseq[cdrnum]),cdrnum]
#      Anativelen = dfsubset2.loc['Tsz_H' & (dfsubset2[cdrnum].str.len() == len(CDRwtseq[cdrnum])),cdrnum]
#      Aall = dfsubset2.loc['Tsz_H',cdrnum]
      Snum = Snativelen.count()
      Anum = Anativelen.count()
      Fnum = Fnativelen.count()
      Ynum = Ynativelen.count()
      DRRs=Snum/trialaS[cdrnum].count()
      DRRa=Anum/trialaA[cdrnum].count()
      DRRf=Fnum/trialaF[cdrnum].count()
      DRRy=Ynum/trialaY[cdrnum].count()
      
#      SnumDRR = dfsubset2.loc[(dfsubset2[cdrnum].str.len()==len(str(CDRwtseq[cdrnum]))) & (dfsubset2['mutant'=='Ptz_H']),cdrnum].count()
     # SdenomDRR = dfsubset2.loc[dfsubset2['mutant']=='Ptz_H',cdrnum].count()
    #  AnumDRR = dfsubset2.loc[(dfsubset2[cdrnum].str.len()==len(CDRwtseq[cdrnum])) & (dfsubset2['mutant'=='Tsz_H']),cdrnum].count()
   #   AdenomDRR = dfsubset2.loc[dfsubset2['mutant']=='Tsz_H',cdrnum].count()
  #    DRRa=AnumDRR/AdenomDRR
 #     FnumDRR = dfsubset2.loc[(dfsubset2[cdrnum].str.len()==len(CDRwtseq[cdrnum])) & (dfsubset2['mutant'=='Ptz_L']),cdrnum].count()
    #  FdenomDRR = dfsubset2.loc[dfsubset2['mutant']=='Ptz_L',cdrnum].count()
   #   DRRf=FnumDRR/FdenomDRR
  #    YnumDRR = dfsubset2.loc[(dfsubset2[cdrnum].str.len()==len(CDRwtseq[cdrnum])) & (dfsubset2['mutant'=='Tsz_L']),cdrnum].count()
 #     YdenomDRR = dfsubset2.loc[dfsubset2['mutant']=='Tsz_L',cdrnum].count()
#      DRRy=YnumDRR/YdenomDRR
      DRR_CDRlength[f'{str(cdrnum)[0:2]}_{str(scfile)[:-3]}'] = pd.Series([DRRs,DRRa,DRRf,DRRy],index=['Ptz_H','Tsz_H','Ptz_L','Tsz_L'])



   for trylooper1 in listlevels:
    trialaSdG = trialaS.loc[:,f'{trylooper1}']
    trialaSdG.reset_index(drop=True,inplace=True)
    trialaAdG = trialaA.loc[:,f'{trylooper1}']
    trialaAdG.reset_index(drop=True,inplace=True)
    trialaFdG = trialaF.loc[:,f'{trylooper1}']
    trialaFdG.reset_index(drop=True,inplace=True)
    trialaYdG = trialaY.loc[:,f'{trylooper1}']
    trialaYdG.reset_index(drop=True,inplace=True)
    dGdf = pd.concat([trialaSdG,trialaAdG,trialaFdG,trialaYdG], axis=1, keys=['Ptz_H','Tsz_H','Ptz_L','Tsz_L'])
   #drop any columns with constant value to avoid KDE plot errors
    dGdf  = dGdf.loc[:,(dGdf != dGdf.iloc[0]).any()]
    ax1 = dGdf.plot.kde()
#   ax1.set_xlim(left=float(mins[trylooper1]), right=float(maxs[trylooper1]))
    ax1.set_title(f'{scfile}')
    ax1.set_xlabel(f'{trylooper1}')
    trylooper1a = trylooper1[0:8]
    if boolval == True:
     plt.savefig(f'KDE.{scfile}.{trylooper1a}.rlx.png')
    else :
     plt.savefig(f'KDE.{scfile}.{trylooper1a}.unrlx.png')
    plt.close()






# do scatterplots
    ax2 = seaborn.scatterplot(x=dfsubset1['dG_separated/dSASAx100'],y=dfsubset1[trylooper1],hue=dfsubset1['mutant'],hue_order=['Ptz_H','Tsz_H','Ptz_L','Tsz_L'])
    ax2.set_xlim(left=float(mins[trylooper1]),right=float(maxs[trylooper1]))
    ax2.set_ylim(bottom=float(minsy[trylooper1]),top=float(maxsy[trylooper1]))
    Rvalue2 = dfsubset1['dG_separated/dSASAx100'].corr(dfsubset1[trylooper1])
    R2value2 = Rvalue2*Rvalue2
    axdummy =plt.plot([], [], ' ', label=f'R^2 = {R2value2}')
    #fg.map(plt.scatter,'dG_separated/dSASAx100', trylooper1).addlegend()
    plt.savefig(f'{trylooper1a}-dG_separ.{scfile}.scatter.png')
    plt.close()
   #ok let's make a little decision block here to either get or set the axes based on the which time it has been through loop
#  ok so the above block will fail if there is any column tested without any variance - i.e., if the Ptz_H mutants all have same hbonds, then it'll error - can I build this to be better?
 DRR_CDRlength.to_csv('DRR_CDRlength.df.csv')
 dfAvRR.to_csv('AvRR.df.csv')
 dfTops[['decoy','mutant','rlxBool','rankMetric','H1seq','H2seq','H4seq','H3seq','L1seq','L2seq','L4seq','L3seq','scFilename','decoyFilename']].to_csv('dfTops.tsv',sep="	",header=False,index=False)
