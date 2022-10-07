#need to pass as an argument a file containing list of scorefiles to analyze additionally, need to have a file colKeys1.tsv that specifies order and exactly the score 
#names (i.e. dG_separated/dSASAx100)
#separated by having one per line

import scipy
import numpy as np
import pandas as pd
from pandarallel import *
import sys
import os
import matplotlib as mpl
import matplotlib.pyplot as plt
import seaborn
pandarallel.initialize()
#define the little function for getting seq from pdb so I can use a proper apply instead of looping over rows
#note that this contains conditionals that are dependent on this-run specific filename formatting, so must be adjusted for different filename starts
seaborn.set(style='ticks')
#read in universal data and initialize things for counting
keydf = pd.read_csv(r'colKeys1.tsv',sep = '	', header = None)
keyPDB = pd.read_csv(r'PDBlist.txt',sep = '	', header = None)
dfTops = pd.DataFrame()
colList1 = list(keydf[0])
PDBlist = list(keyPDB[0])
argScorefile = sys.argv[1]
i = 1


#gotta loop over dfseqs or maybe even 
#with open(argScorefileList) as scorelistF:


dfpdblist = pd.DataFrame()
dfpdblist['decoyFilename'] = PDBlist
#dfpdblist['path'], dfpdblist['decoy'] = dfpdblist['decoyFilename'].str.rsplit(pat="/",n=1,expand=True)
dfpdblist['decoy'] = dfpdblist['decoyFilename'].parallel_apply(lambda x:os.path.basename(x))
dfpdblist['path'] = dfpdblist['decoyFilename'].parallel_apply(lambda x:os.path.dirname(x))
#print(dfpdblist['decoy'])
#########
##TOGGLE THE NEXT TWO LINES IN/OUT DEPENDING ON NAMING OF YOUR FILES
#dfpdblist['decoy'] = dfpdblist['decoy'].str.replace(pat='_initrlx_0002_',repl='_',regex=False)
dfpdblist['decoy'] = dfpdblist['decoy'].str.replace(pat='renum_S351',repl='renum-S351',regex=False)

../2020-07-13_allPtzShotgunCM/DII-Ptz_initrlx_0002_CM_HHa_n100_0059.pdb  DII-Fab-renum-S351Srlx_0008_CM_Lib1_100tr_0100.pdb.gz


#print(dfpdblist['decoy'])
#print(dfpdblist['decoy'].str.rsplit(n=1,pat="_",expand=True)[1])
dfpdblist['nstructID'] = dfpdblist['decoy'].str.rsplit(n=1,pat="_",expand=True)[1]
dfpdblist['nstructID'] = dfpdblist['nstructID'].str.rstrip('.pdb')
dfpdblist['complex'] = dfpdblist['decoy'].str.split(n=1,pat="_",expand=True)[0]

dfpdblist['approach']=dfpdblist['decoy'].str.split(n=1,pat="_",expand=True)[1]
dfpdblist['tuners']=dfpdblist['approach'].str.split(n=1,pat="_",expand=True)[1]
dfpdblist['tuners']=dfpdblist['tuners'].str.rsplit(n=1,pat="_",expand=True)[0]
dfpdblist['lib']=dfpdblist['tuners'].str.split(n=1,pat="_",expand=True)[0]
dfpdblist['ntrials']=dfpdblist['tuners'].str.split(n=1,pat="_",expand=True)[1]
dfpdblist['approach']=dfpdblist['approach'].str.split(n=1,pat="_",expand=True)[0]
#dfpdblist.drop(columns='tuners',inplace=True)

#dfpdblist.loc[dfpdblist['decoy'].str.contains('CM'),'approach'] = 'CM'
#dfpdblist.loc[dfpdblist['decoy'].str.contains('RAbD'),'approach'] = 'RAbD'

#print(dfpdblist.head())
dfpdblist.loc[:,'decoy'] = dfpdblist['decoy'].str.strip('.pdb')
dfSeq = pd.read_csv(f'dfSeq.agg.csv', header=0)
#print(dfpdblist['decoyFilename'].head())
#print(dfSeq['decoyFilename'].head())
dfpdblist = pd.merge(dfpdblist,dfSeq,how='outer',on='decoyFilename')
#print(dfSeq.head())

#initialize an empty dataframe so I can avoid decision later about whether to copy/create or append the first loop
scores = pd.DataFrame()
#loop over the lines in the passed file of scorefiles
scores = pd.read_json(argScorefile, lines = 'true')
#subset the data by pulling out the scores we care about 
scores = scores.loc[:,colList1]
#print(scores['decoy'].head())
scores['decoy'] = scores['decoy'].str.replace(pat='_initrlx_0002_',repl='_',regex=False)
#print(scores['decoy'].head())
#print(dfpdblist['decoy'].head())
scores = pd.merge(scores,dfpdblist,how='outer',on='decoy')
#print(scores[['complex','approach','tuners']].head())
#drop some rows that are a result of headers in the dfSeq.agg.csv file that get repeated in catenating the separate dfSeqs together
scores['dG_cross'].replace('',np.nan,inplace=True)
scores.dropna(subset=['dG_cross'],inplace=True)
scores.to_csv(f'scores.csv')


#declare a few useful things for later
	#this line had an older sortdict i reduced for efficiency
#listlevels = ['dG_separated/dSASAx100','dG_cross/dSASAx100', 'delta_unsatHbonds','sc_value','total_score','side1_normalized','side2_normalized','hbonds_int']
#sortdict = {'dG_separated/dSASAx100':True,'sc_value':False,'hbonds_int':False,'dG_cross/dSASAx100':True,'delta_unsatHbonds':True}
sortdict = {'dG_separated/dSASAx100':True,'sc_value':False,'hbonds_int':False,'delta_unsatHbonds':True}
listlevels = ['dG_separated/dSASAx100','sc_value','hbonds_int','delta_unsatHbonds','total_score']
TszCDRseq = {'H1seq':'AASGFNIKDTYIH', 'H2seq':'RIYPTNGYTR','H4seq':'ADTSKNTA','H3seq':'SRWGGDGFYAMDY','L1seq':'RASQDVNTAVA','L2seq':'YSASFLYS','L4seq':'RSGTDF','L3seq':'QQHYTTPPT'}
PtzCDRseq = {'H1seq':'AASGFTFTDYTMD', 'H2seq':'DVNPNSGGSI','H4seq':'VDRSKNTL','H3seq':'ARNLGPSFYFDY' ,'L1seq':'KASQDVSIGVA','L2seq':'YSASYRYT','L4seq':'GSGTDF','L3seq':'QQYYIYPYT'}


#loop over the listlevels to plot overall KDE
for level1 in listlevels:
 totKDEax=scores[level1].plot.kde()
 plt.savefig(f'KDE.allsets.{str(level1)[0:8]}.png')
 plt.close()
 totScatterax = seaborn.scatterplot(x=scores['dG_separated/dSASAx100'],y=scores[level1],hue=scores['approach'])
 Rvalue1 = scores['dG_separated/dSASAx100'].corr(scores[level1])
 R2value1 = Rvalue1*Rvalue1
#  totScatterax.text(1,1,f'R^2 = {R2value1}')
 axdummy1 =plt.plot([], [], ' ', label=f'R^2 = {R2value1}')
 plt.savefig(f'allsets.byapproach.{str(level1)[0:8]}_dG_separ.scatter.png')
 plt.close()
 totScatterax = seaborn.scatterplot(x=scores['dG_separated/dSASAx100'],y=scores[level1],hue=scores['tuners'])
 Rvalue1 = scores['dG_separated/dSASAx100'].corr(scores[level1])
 R2value1 = Rvalue1*Rvalue1
#  totScatterax.text(1,1,f'R^2 = {R2value1}')
 axdummy1 =plt.plot([], [], ' ', label=f'R^2 = {R2value1}')
 plt.savefig(f'allsets.bytuners.{str(level1)[0:8]}_dG_separ.scatter.png')
 plt.close()





scoresP = scores.loc[scores['complex'].str.contains('Ptz')]
scoresT = scores.loc[scores['complex'].str.contains('Tsz')]
for app in [dfpdblist.approach.unique()]:
 scoresPa = scoresP.loc[scoresP['approach'].str.contains(f'{app}')]
 scoresTa = scoresT.loc[scoresT['approach'].str.contains(f'{app}')]
 for feature in sortdict:
  Plen = len(scoresPa.index)
  Ptoplen = int(round(0.1*Plen))
  PtopFeature = scoresPa.sort_values(by=feature,ascending=sortdict[feature]).head(Ptoplen)
  PtopFeature['rankMetric']=str(feature)[0:8]
  Tlen = len(scoresTa.index)
  Ttoplen = int(round(0.1*Tlen))
  TtopFeature = scoresTa.sort_values(by=feature,ascending=sortdict[feature]).head(Ttoplen)
  TtopFeature['rankMetric']=str(feature)[0:8]
  dfTops = dfTops.append(PtopFeature)
  dfTops = dfTops.append(TtopFeature)
dfTops[['decoy','complex','approach','lib','ntrials,'rankMetric','H1seq','H2seq','H4seq','H3seq','L1seq','L2seq','L4seq','L3seq','decoyFilename']].to_csv(f'dfTops.csv',header=False,sep="	",index=False)
print(f'scores[scores.isna().any(axis=1)] yields:')
print(scores[scores.isna().any(axis=1)])
for trylooper1 in listlevels:
 for app in dfpdblist.approach.unique():
  scoresPaa = scoresP[scoresP['approach'].str.match(f'{app}')]
  scoresTaa = scoresT[scoresT['approach'].str.match(f'{app}')]
  dfP = pd.DataFrame()
  dfT = pd.DataFrame()
  for libiter in dfpdblist.loc[(dfpdblist['approach'] == f'{app}'), 'lib'].unique():
   scoresPa = scoresPaa[scoresP['lib'].str.match(f'{libiter}')]
   scoresTa = scoresTaa[scoresT['lib'].str.match(f'{libiter}')]
   for temps in dfpdblist.loc[(dfpdblist['approach'] == f'{app}'),'ntrials'].unique():
    print(dfpdblist.loc[(dfpdblist['approach'] == f'{app}' && dfpdblist['lib'] == f'{libiter}'),'ntrials'].unique())
    print(f'ntrials={temps}')
    print(f'lib={libiter}')
    print(f'approach={app}')
    print(f'trylooper1={trylooper1}')
    scoresPaloop = scoresPa.loc[scoresPa['ntrials'].str.contains(f'{temps}'),f'{trylooper1}'].to_frame(name=f'{temps}')
    scoresTaloop = scoresTa.loc[scoresTa['ntrials'].str.contains(f'{temps}'),f'{trylooper1}'].to_frame(name=f'{temps}')
    scoresPaloop.columns = [ f'{libiter}.{temps}' ]
    scoresTaloop.columns = [ f'{libiter}.{temps}' ]
    scoresPaloop.reset_index(drop=True,inplace=True)
    scoresTaloop.reset_index(drop=True,inplace=True)
    scoresPaloop = scoresPaloop.loc[:,(scoresPaloop != scoresPaloop.iloc[0]).any()]
    scoresTaloop = scoresTaloop.loc[:,(scoresTaloop != scoresTaloop.iloc[0]).any()]
    dfP = pd.concat([dfP,scoresPaloop],axis=1)
    dfT = pd.concat([dfT,scoresTaloop],axis=1)
    print(dfP)
    print(dfT)
  ax1 = dfP.plot.kde()
  ax1.set_title(f'{app}_Ptz')
  ax1.set_xlabel(f'{trylooper1}')
  trylooper1a = trylooper1[0:8]
  plt.savefig(f'KDE.{app}.Ptz.{trylooper1a}.png')
  plt.close()

  ax1 = dfT.plot.kde()
  ax1.set_title(f'{app}_Tsz')
  ax1.set_xlabel(f'{trylooper1}')
  plt.savefig(f'KDE.{app}.Tsz.{trylooper1a}.png')
  plt.close()

