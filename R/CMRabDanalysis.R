
library(tidyverse)
library(SDSRegressionR)
library(caret)
library(class)
library(ggplot2)
library(rgl)
library(matrixStats)
library(rsample)
library(rjson)
library(jsonlite)
library(readr)
library(corrplot)

#let's set up all the data to be a dataframe/tibble
#with each row having the identifier first column that is uniq identifier
#consisting of concatenated trial, approach, mutant, lib, nstructid
#other columns as factors: 
#   trial, approach, mutant, lib, nstructid, H1seq,H2seq,H4seq,H3seq
#   PCA-derived most important positions (score ~ pos1 + pos2 + posi)
#   positional features like AAidentity, charge, hydrophobicity, etc
#   
#other columns as floats
#   dGseparated.dSASAx100 (rename to dGnorm)
#   sc_value, hbonds_int, 38 other scoring columns?
#   

json_raw   <- readr::read_file("IA.only.2.sc")
json_lines <- unlist(strsplit(json_raw, "\\n"))
dfscore2    <- do.call(rbind, lapply(json_lines, FUN = function(x){as.data.frame(jsonlite::fromJSON(x))}))
dfseq2 <- read.csv("dfSeq.agg.2.csv",header = TRUE)

#file2="IA.only.2.sc"
#dfscore2 <- fromJSON(paste(readLines(file2),collapse = ""))
#json_raw   <- readr::read_file("IA.only.3.sc")
#json_lines <- unlist(strsplit(json_raw, "\\n"))
#dfscore3    <- do.call(rbind, lapply(json_lines, FUN = function(x){as.data.frame(jsonlite::fromJSON(x))}))
#dfseq3 <- read.csv("dfSeq.agg.3.csv",header = TRUE)
#json_raw   <- readr::read_file("IA.only.4.sc")
#json_lines <- unlist(strsplit(json_raw, "\\n"))
#dfscore4    <- do.call(rbind, lapply(json_lines, FUN = function(x){as.data.frame(jsonlite::fromJSON(x))}))
#dfseq4 <- read.csv("dfSeq.agg.4.csv",header = TRUE)

dfseq2$decoyFilename<-gsub("./","",dfseq2$decoyFilename)
dfseq2$decoyFilename<-gsub(".pdb_H","",dfseq2$decoyFilename)
dftot2 <- merge(x=dfseq2,y=dfscore2,by.x="decoyFilename",by.y="decoy")

json_raw   <- readr::read_file("../2020-10-25_RAbDrepeatafterLost/IA.only-CMrlx.sc")
json_lines <- unlist(strsplit(json_raw, "\\n"))
dfscore2rlx    <- do.call(rbind, lapply(json_lines, FUN = function(x){as.data.frame(jsonlite::fromJSON(x))}))
dfscore2rlx$decoy<-gsub("rlxtest_0001","",dfscore2rlx$decoy)
dftot2rlx <- inner_join(x=dfseq2,y=dfscore2rlx,by=c("decoyFilename" = "decoy" ))
#dfseq2rlx <- read.csv("dfSeq.agg.2.csv",header = TRUE)




#dfseq3$decoyFilename<-gsub("./","",dfseq3$decoyFilename)
#dfseq3$decoyFilename<-gsub(".pdb","",dfseq3$decoyFilename)
#dftot3 <- merge(x=dfseq3,y=dfscore3,by.x="decoyFilename",by.y="decoy")

#dfseq4$decoyFilename<-gsub("./","",dfseq4$decoyFilename)
#dfseq4$decoyFilename<-gsub(".pdb","",dfseq4$decoyFilename)
#dftot4 <- merge(x=dfseq4,y=dfscore4,by.x="decoyFilename",by.y="decoy")
                       

dftot2 <- dftot2 %>% dplyr::rename(dGnorm=dG_separated.dSASAx100)
dftot2rlx <- dftot2rlx %>% dplyr::rename(dGnorm=dG_separated.dSASAx100)
#dftot3 <- dftot3 %>% dplyr::rename(dGnorm=dG_separated.dSASAx100)
#dftot4 <- dftot4 %>% dplyr::rename(dGnorm=dG_separated.dSASAx100)

keyscores <- c("dGnorm","sc_value","hbonds_int")

dftot2 <- dftot2 %>% mutate(mutant=str_sub(str_extract(decoyFilename,"S351[SAFY]"),-1,-1))
dftot2rlx <- dftot2rlx %>% mutate(mutant=str_sub(str_extract(decoyFilename,"S351[SAFY]"),-1,-1))
#dftot3 <- dftot3 %>% mutate(mutant=str_sub(str_extract(decoyFilename,"S351[SAFY]"),-1,-1))
#dftot4 <- dftot4 %>% mutate(mutant=str_sub(str_extract(decoyFilename,"S351[SAFY]"),-1,-1))

dftot2 <- dftot2 %>% mutate(libname=str_sub(str_extract(decoyFilename,"Lib.{1,3}_"),1,nchar(str_extract(decoyFilename,"Lib.{1,3}_"))-1))
dftot2rlx <- dftot2rlx %>% mutate(libname=str_sub(str_extract(decoyFilename,"Lib.{1,3}_"),1,nchar(str_extract(decoyFilename,"Lib.{1,3}_"))-1))
#dftot3 <- dftot3 %>% mutate(libname=str_sub(str_extract(decoyFilename,"Lib.{1,3}_"),1,nchar(str_extract(decoyFilename,"Lib.{1,3}_"))-1))
#dftot4 <- dftot4 %>% mutate(libname=str_sub(str_extract(decoyFilename,"Lib.{1,3}_"),1,nchar(str_extract(decoyFilename,"Lib.{1,3}_"))-1))

dftot2 <- dftot2 %>% mutate(tmpcol=str_extract(decoyFilename,"Lib.*_"))
dftot2 <- dftot2 %>% mutate(libname=str_sub(str_extract(tmpcol,"Lib.{1,3}_"),1,nchar(str_extract(tmpcol,"Lib.{1,3}_"))-1))
dftot2 <- dftot2 %>% mutate(ntrials=str_sub(str_extract(tmpcol,"_.*"),2,nchar(str_extract(tmpcol,"_.*"))-3))
dftot2 <- dftot2 %>% select(-tmpcol)

dftot2rlx <- dftot2rlx %>% mutate(tmpcol=str_extract(decoyFilename,"Lib.*_"))
dftot2rlx <- dftot2rlx %>% mutate(libname=str_sub(str_extract(tmpcol,"Lib.{1,3}_"),1,nchar(str_extract(tmpcol,"Lib.{1,3}_"))-1))
dftot2rlx <- dftot2rlx %>% mutate(ntrials=str_sub(str_extract(tmpcol,"_.*"),2,nchar(str_extract(tmpcol,"_.*"))-3))
dftot2rlx <- dftot2rlx %>% select(-tmpcol)

#dftot3 <- dftot3 %>% mutate(tmpcol=str_extract(decoyFilename,"Lib.*_"))
#dftot3 <- dftot3 %>% mutate(libname=str_sub(str_extract(tmpcol,"Lib.{1,3}_"),1,nchar(str_extract(tmpcol,"Lib.{1,3}_"))-1))
#dftot3 <- dftot3 %>% mutate(ntrials=str_sub(str_extract(tmpcol,"_.*"),2,nchar(str_extract(tmpcol,"_.*"))-3))
#dftot3 <- dftot3 %>% select(-tmpcol)

#dftot4 <- dftot4 %>% mutate(tmpcol=str_extract(decoyFilename,"Lib.*_"))
#dftot4 <- dftot4 %>% mutate(libname=str_sub(str_extract(tmpcol,"Lib.{1,3}_"),1,nchar(str_extract(tmpcol,"Lib.{1,3}_"))-1))
#dftot4 <- dftot4 %>% mutate(ntrials=str_sub(str_extract(tmpcol,"_.*"),2,nchar(str_extract(tmpcol,"_.*"))-3))
#dftot4 <- dftot4 %>% select(-tmpcol)

dftot2 <- dftot2 %>% mutate(trial=2)
dftot2rlx <- dftot2rlx %>% mutate(trial=2)
#dftot3 <- dftot3 %>% mutate(trial=3) 
#dftot4 <- dftot4 %>% mutate(trial=4)

dftot2 <- dftot2 %>% mutate(approach="CM")
dftot2rlx <- dftot2rlx %>% mutate(approach="CM")
#dftot3 <- dftot3 %>% mutate(approach="CM")
#dftot4 <- dftot4 %>% mutate(approach="CM")
dftot2<-dftot2 %>% mutate(relax=FALSE)
dftot2rlx<-dftot2rlx %>% mutate(relax=TRUE)

#dftot3 <- dftot3 %>% select(-LchainSeq,-L1seq,-L2seq,-L3seq,-L4seq)
#dftot4 <- dftot4 %>% select(-LchainSeq,-L1seq,-L2seq,-L3seq,-L4seq)

#dftotall <- rbind(dftot2,dftot3,dftot4)
dftotall <- rbind(dftot2,dftot2rlx)
#now, extract each position of interest for full set of libraries as new columns:
dftotall <- dftotall %>% mutate(CDR1.1=str_sub(H1seq,6,6),CDR1.2=str_sub(H1seq,7,7),CDR1.3=str_sub(H1seq,8,8),CDR1.4=str_sub(H1seq,9,9),CDR1.5=str_sub(H1seq,10,10),CDR1.6=str_sub(H1seq,11,11))
dftotall <- dftotall %>% mutate(CDR2.2=str_sub(H2seq,3,3),CDR2.3=str_sub(H2seq,4,4),CDR2.4=str_sub(H2seq,5,5),CDR2.5=str_sub(H2seq,6,6))

#bring in a bunch of the RAbD stuff, plot the length of those on a histogram for graft length of H1 and H2
json_raw   <- readr::read_file("../2020-10-25_RAbDrepeatafterLost/IA.only.sc")
json_lines <- unlist(strsplit(json_raw, "\\n"))
dfscoreRAbD  <- do.call(rbind, lapply(json_lines, FUN = function(x){as.data.frame(jsonlite::fromJSON(x))}))
dfseqRAbD <- read.csv("../2020-10-25_RAbDrepeatafterLost/dfSeq.agg.csv",header = TRUE)
dfseqRAbD$decoyFilename<-gsub("./","",dfseqRAbD$decoyFilename)
dfseqRAbD$decoyFilename<-gsub(".pdb","",dfseqRAbD$decoyFilename)
dftotRAbD <- merge(x=dfseqRAbD,y=dfscoreRAbD,by.x="decoyFilename",by.y="decoy")
dftotRAbD <- dftotRAbD %>% dplyr::rename(dGnorm=dG_separated.dSASAx100)

dftotRAbD <- dftotRAbD %>% mutate(mutant=str_sub(str_extract(decoyFilename,"S351[SAFY]"),-1,-1))
dftotRAbD <- dftotRAbD %>% mutate(libname=str_sub(str_extract(decoyFilename,"Lib.{1,3}_"),1,nchar(str_extract(decoyFilename,"Lib.{1,3}_"))-1))
dftotRAbD <- dftotRAbD %>% mutate(tmpcol=str_extract(decoyFilename,"Lib.*_"))
dftotRAbD <- dftotRAbD %>% mutate(tmpcol=str_extract(decoyFilename,"Lib.*_"))
dftotRAbD <- dftotRAbD %>% mutate(tmpcol=str_extract(decoyFilename,"Lib.*_"))
dftotRAbD <- dftotRAbD %>% mutate(trial=2)
dftotRAbD <- dftotRAbD %>% mutate(approach="RAbD")
dftotRAbD <- dftotRAbD %>% select(-LchainSeq,-L1seq,-L2seq,-L3seq,-L4seq)
dftotRAbD <- dftotRAbD %>% mutate(CDR1.1=str_sub(H1seq,6,6),CDR1.2=str_sub(H1seq,7,7),CDR1.3=str_sub(H1seq,8,8),CDR1.4=str_sub(H1seq,9,9),CDR1.5=str_sub(H1seq,10,10),CDR1.6=str_sub(H1seq,11,11))
dftotRAbD <- dftotRAbD %>% mutate(H1.len=nchar(H1seq))
dftotRAbD <- dftotRAbD %>% mutate(H2.len=nchar(H2seq))
dftotRAbD <- dftotRAbD %>% mutate(H3.len=nchar(H3seq))
dftotRAbD <- dftotRAbD %>% mutate(H4.len=nchar(H4seq))
dftotRAbD <- dftotRAbD %>% mutate(CDR1.1=str_sub(H1seq,6,6),CDR1.2=str_sub(H1seq,7,7),CDR1.3=str_sub(H1seq,8,8),CDR1.4=str_sub(H1seq,9,9),CDR1.5=str_sub(H1seq,10,10),CDR1.6=str_sub(H1seq,11,11))
dftotRAbD <- dftotRAbD %>% mutate(CDR2.2=str_sub(H2seq,3,3),CDR2.3=str_sub(H2seq,4,4),CDR2.4=str_sub(H2seq,5,5),CDR2.5=str_sub(H2seq,6,6))
dftotRAbD$relax<- !grepl("pre",dftotRAbD$decoyFilename)
dftotRAbD$ntrials <-1000
#drop incomparable clumns
dftotRAbD<-dftotRAbD %>% select(-tmpcol,-H1.len,-H2.len,-H3.len,-H4.len)
natlenH1 <-dftotRAbD %>% filter(nchar(H1seq)==13)
natlenpctH1 <- nrow(natlenH1)/nrow(dftotRAbD)
natlenH2 <-dftotRAbD %>% filter(nchar(H2seq)==10)
natlenpctH2 <- nrow(natlenH2)/nrow(dftotRAbD)
#plot the distribution of CDR lengths 
qplot(data=dftotRAbD,x=nchar(H1seq),geom="histogram",binwidth=1)+
  annotate("text",x=13,y=4000,label="85.6% \nof total\nin native\ncluster\nlength",size=2)
qplot(data=dftotRAbD,x=nchar(H2seq),geom="histogram",binwidth=1)+
  annotate("text",x=10,y=4000,label="92.7% \nof total\nin native\ncluster\nlength",size=2)

#now let's count the number of nonwt mutations at each position for a new column
#it'll be a real quick function for that...
countmut<-function(df){
  df$N_mut<-0
  if (df$CDR1.1=="T"){df$N_mut<-df$N_mut+1}
  if (df$CDR1.2=="F"){df$N_mut<-df$N_mut+1}
  if (df$CDR1.3=="T"){df$N_mut<-df$N_mut+1}
  if (df$CDR1.4=="D"){count<-count+1}
  if (df$CDR1.5=="Y"){count<-count+1}
  if (df$CDR1.6=="T"){count<-count+1}
  if (df$CDR2.2=="N"){count<-count+1}
  if (df$CDR2.3=="P"){count<-count+1}
  if (df$CDR2.4=="N"){count<-count+1}
  if (df$CDR2.5=="S"){count<-count+1}
  
}
#dftotall <- dftotall %>%
#  mutate(N_mut=)

#this will sample a subset namely 10% of the total data frame for ease of testing protocols, comment it out to run the full scale
#dftotall <- dftotall %>% group_by(mutant,libname,ntrials,trial) %>% slice_sample(prop=0.1)



# ok now we have our dataframe organized with appropriate initial factor columns. Let's get some summary plots etc
basicRAbD <- favstats(~dGnorm,data=dftotRAbD)
basicall <- favstats(~dGnorm,data=dftotall)
#basic3 <- favstats(~dGnorm,data=dftot3)
#basic4 <- favstats(~dGnorm,data=dftot4)

#qplot(x=dGnorm,y=total_score,data=dftot2,geom="boxplot", facets = ~mutant)


ggplot(data=dftotall) +
  aes(x=mutant,y=dGnorm,col=libname)+
  geom_boxplot(outlier.size = 0.5)+
  #geom_point(position="jitter",alpha=0.2) +
  facet_wrap(~trial)
#this line sets the relax column accordingly

#these lines count the number of occurrences for each sequence by mutant group
groupedcountRabd<-as_tibble(dftotRAbD) %>% group_by(mutant) %>% dplyr::count(HchainSeq)
groupedcountdf2<-as_tibble(dftot2) %>% group_by(mutant) %>% dplyr::count(HchainSeq)
#this sorts by dGnorm and slices out the top 5 in each group by mutant and relax status


top10tibleRabd <- dftotRAbD %>% group_by(mutant,relax) %>% arrange(dGnorm) %>% slice_head(n=10)

top2_dGnorm.tot <- dftotRAbD %>%
  group_by(mutant,relax) %>%
  arrange(total_score) %>% 
  slice_head(n=100) %>% arrange(dGnorm) %>% slice_head(n=2)%>%
  mutate(sorter="dGnorm-tot")
top2_sc <- dftotRAbD %>%
  group_by(mutant,relax) %>%
  arrange(desc(sc_value)) %>% slice_head(n=2)%>%
  mutate(sorter="sc_value")
top2_dUHi <- dftotRAbD %>%
  group_by(mutant,relax) %>%
  arrange(delta_unsatHbonds) %>% slice_head(n=2)%>%
  mutate(sorter="dUnsatHbondsint")
top2_Hi <- dftotRAbD %>%
  group_by(mutant,relax) %>%
  arrange(desc(hbonds_int)) %>% slice_head(n=2) %>%
  mutate(sorter="hbonds_int")
top2allsorters <- rbind(top2_dGnorm.tot,top2_dUHi,top2_Hi,top2_sc) %>%
  relocate(sorter,delta_unsatHbonds,hbonds_int,dGnorm,sc_value)

#at least for trial 2... now have checked it's actually consistent 2-4
#ok so that's actually interesting, it looks like for S310F/Y I have less favorable scores for libs 4a-c and 5a, those most heavily focused on CDR2
#would be interesting to look then at for lib2 that had design enabled for both, is CDR1 always favored?

#another noteworthy observation is that S is just below A generally, and Y is just below F generally
#probably consistent with added favorable energy of hydrogen bonds available to those hydroxyl-containing sidechans

#next thing to look at: for each outlier, how does that sequence's distribution of scores (presuming non-unique) compare to a randomly chosen example from non-outliers?

#this chunk shows nothing surprising with the correlation matrix of numerical variables mostly representing sensible trends like negative correlation between polar and hydrophobic dSASA
tmpcor <- dftotall %>%ungroup()%>% select(-ref,-HchainSeq,-H1seq,-H2seq,-H3seq,-H4seq,-decoyFilename,-libname,-approach,-ntrials,-mutant,-nres_all,-trial,-CDR1.1,-CDR1.2,-CDR1.3,-CDR1.4,-CDR1.5,-CDR1.6,-CDR2.2,-CDR2.3,-CDR2.4,-CDR2.5) %>% cor()
corrplot(tmpcor,tl.cex = 0.5,order="FPC")



# can i assemble some information with the mutational data on both sides of the interface, use that for model training?
# add character of positions, hydrophobic (write this as function)
# how do i account for coupled positions, i.e. having a residue of a certain character at position x on one side with position y on the other side having character is key
# gave a thought to it and maybe add character, and a side chain # atoms as a proxy for sidechain bulk
# add the KDmut/KDwt ratio info as a column? or a scoring function based on a linear combination of contributions from each mutation

#this one treats as dataframe passed in so don't apply
dfVajdos <- function(x){
  VajdosScores <- read.csv("vajdos-scores.csv")
  x<-as.data.frame(x)
  newcolumn <-vector()
  i<-1
  out1 <- x
  for(column in colnames(x)){
    out1[[column]] <- lapply(x[[column]],function(y) VajdosScores[which(VajdosScores$Mutation==y & VajdosScores$Position==column),"VajdosScores"])
    newcolumn[i] <-paste(column,"Vajdos",sep="")
    i<-i+1
  }
  out1<-apply(out1,1:2,function(x) if(is.list(x)){mean(unlist(x))}else{x})
  #out1<-apply(out1,1:2,function(x) if (length(unlist(x))==0) {x<-NA} else {unlist(x)})
  colnames(out1) <-newcolumn
return(as.data.frame(out1))
}

onlycdrs <-dftotall %>%ungroup() %>% select(CDR1.1,CDR1.2,CDR1.3,CDR1.4,CDR1.5,CDR1.6,CDR2.2,CDR2.3,CDR2.4,CDR2.5) 
vscoretable <-dfVajdos(onlycdrs)
vscoretable<-as.data.frame(apply(vscoretable,2,function(x)gsub("NaN","NA",x)))
vscoretable<- apply(vscoretable,1:2,function(x) as.numeric(x))
meancol <- rowMeans(vscoretable,na.rm=TRUE)
dftotall <-cbind(dftotall,meanVajdos=meancol)

onlycdrs <-dftotRAbD %>%ungroup() %>% select(CDR1.1,CDR1.2,CDR1.3,CDR1.4,CDR1.5,CDR1.6,CDR2.2,CDR2.3,CDR2.4,CDR2.5) 
vscoretable <-dfVajdos(onlycdrs)
vscoretable<-as.data.frame(apply(vscoretable,2,function(x)gsub("NaN","NA",x)))
vscoretable<- apply(vscoretable,1:2,function(x) as.numeric(x))
meancol <- rowMeans(vscoretable,na.rm=TRUE)
dftotRAbD <-cbind(dftotRAbD,meanVajdos=meancol)

dftotRAbD2 <- dftotRAbD %>%
  filter(nchar(H1seq)==13) %>%
  filter(nchar(H2seq)==10) %>%
  select(-tmpcol)

dftot.both2 <-rbind(dftotall,dftotRAbD2)

qplot(x=meanVajdos,y=dGnorm,data=dftotall,main="")+
  facet_wrap(~mutant)+
  geom_smooth(method = "lm")
qplot(x=meanVajdos,y=dGnorm,data=dftotRAbD2,main="")+
  facet_wrap(~relax+mutant)+
  geom_smooth(method = "lm")
qplot(x=meanVajdos,y=dGnorm,data=leftshoulderY,main="")+
  facet_wrap(~relax+mutant)+
  geom_smooth(method = "lm")
#so those plots show that the splitting by relax+- and by mutant, 
#there's much more correlation of vajdos score and 
#the dGnorm for the CM approach vs the RAbD approach
#note these were selected for only rows where 
#the grafted CDRs were of the native lengths 13 and 10 (H1 and H2)

#now lets plot the density of dGsep
#d<- 
ggplot(data=dftot.both2) +
  aes(x=mutant,y=dGnorm,col=libname)+
  geom_boxplot(outlier.size = 0.5)+
  #geom_point(position="jitter",alpha=0.2) +
  facet_wrap(~approach)
#for comparing both datasets with KDE of the dGnorm metric
ggplot(data=dftot.both2, aes(x=dGnorm,group=relax,colour=relax)) +
  geom_density() +
  facet_grid(~mutant)  +
  scale_y_continuous(trans="sqrt",name="sqrt_density",labels=NULL)
#this graph makes me wonder if we ran a relax on the CM set, 
#would they all shift to the same place in the left side of KDE 
#like we have the bimodal distrbution for +-relax in RabD?
#######
#separately, this also suggests maybe the valid comparison 
# between CM and RAbD would be using unrelaxed Rabd designs



#looking at the RAbD set only, KDE of dGnorm
ggplot(data=dftotRAbD2, aes(x=dGnorm,group=relax,colour=relax)) +
  geom_density() +
  facet_grid(~mutant) 
#so now this one shows the F and Y have clear shoulders
# those are going to be defined as sequences of interest
# for further investigation computationally for now
#########
#lets now go ahead and add the individual points of the top 10 guys 
#on as points with the sc_value plotted on as the y value 
#maybe even on a second axis?
#lets also make a subset frame for plotting distribution of all WT seqs on the KDE
dfrabd2onlyWT <- dftotRAbD2 %>%filter(H1seq=="AASGFTFTDYTMD") %>%
  filter(H2seq=="DVNPNSGGSI") %>% filter(H4seq=="VDRSKNTL") %>%
  filter(H3seq=="ARNLGPSFYFDY")  %>%
  mutate(relax="WT")
  
#so this plot shows the WT only on their own, along with the total set each for+-relax and individual points for scvalue vs dGnorm for the top10 dGnorms each  
ggplot(data=dftotRAbD2, aes(x=dGnorm,group=relax,colour=relax)) +
  geom_density() +
  geom_density(data=dfrabd2onlyWT,aes(x=dGnorm,group=relax,colour=relax))+
  facet_grid(~mutant) +
  geom_point(data=top10tibleRabd,aes(x=dGnorm,y=sc_value))
  #geom_text(data=top10tibleRabd,aes(x=dGnorm,y=sc_value,label=hbonds_int),check_overlap=TRUE,size=4,hjust=3,vjust=-3)

ggplot(data=dftotRAbD2, aes(x=dGnorm,group=relax,colour=relax)) +
  geom_density() +
  geom_density(data=leftshoulderF,aes(x=dGnorm),color="black")+
  geom_density(data=leftshoulderY,aes(x=dGnorm),color="black")+
  facet_grid(~mutant) +
  geom_point(data=top10tibleRabd,aes(x=dGnorm,y=sc_value))

#so this plot shows the CM designs with the relaxed set plotted separately, along with the total set each for+-relax and individual points for scvalue vs dGnorm for the top10 dGnorms each  
ggplot(data=dftotall, aes(x=dGnorm,group=relax,colour=relax)) +
  geom_density() +
  geom_density(data=dftot2rlx,aes(x=dGnorm))+
  #geom_density(data=dfrabd2onlyWT,aes(x=dGnorm,group=relax,colour=relax))+
  facet_grid(~mutant) 
  #geom_point(data=top10tibleRabd,aes(x=dGnorm,y=sc_value))
#geom_text(data=top10tibleRabd,aes(x=dGnorm,y=sc_value,label=hbonds_int),check_overlap=TRUE,size=4,hjust=3,vjust=-3)




#Here, dGnorm-tot, the yval on points is sc_value
ggplot(data=dftotRAbD2, aes(x=dGnorm,group=relax,colour=relax)) +
  geom_density() +
  geom_density(data=dfrabd2onlyWT,aes(x=dGnorm,group=relax,colour=relax))+
  facet_grid(~mutant) +
  geom_point(data=top2allsorters,aes(x=dGnorm,y=sc_value))

#Here, scvalue, the yval on points is delta_unsathbonds/5+10
ggplot(data=dftotRAbD2, aes(x=sc_value,group=relax,colour=relax)) +
  geom_density() +
  geom_density(data=dfrabd2onlyWT,aes(x=sc_value,group=relax,colour=relax))+
  facet_grid(~mutant) +
  geom_point(data=top2allsorters,aes(x=sc_value,y=delta_unsatHbonds/5+10))

#Here, hbonds_int, the yval on points is scvalue
ggplot(data=dftotRAbD2, aes(x=hbonds_int,group=relax,colour=relax)) +
  geom_density() +
  geom_density(data=dfrabd2onlyWT,aes(x=hbonds_int,group=relax,colour=relax))+
  facet_grid(~mutant) +
  geom_point(data=top2allsorters,aes(x=hbonds_int,y=sc_value))

#Here, delta_unsathbondsint, the val on points is scvalue/5
ggplot(data=dftotRAbD2, aes(x=delta_unsatHbonds,group=relax,colour=relax)) +
  geom_density() +
  geom_density(data=dfrabd2onlyWT,aes(x=delta_unsatHbonds,group=relax,colour=relax))+
  facet_grid(~mutant) +
  geom_point(data=top2allsorters,aes(x=delta_unsatHbonds,y=sc_value/5))


#and here lets look by library from the CM set at the same KDEs
dftot2a<-dftot2 %>% filter(ntrials==100)
dftot2awt <- dftot2a %>% filter(H1seq=="AASGFTFTDYTMD") %>%
  filter(H2seq=="DVNPNSGGSI") %>% filter(H4seq=="VDRSKNTL") %>%
  filter(H3seq=="ARNLGPSFYFDY") %>% mutate(libname="wtonly")
ggplot(data=dftot2a, aes(x=dGnorm,group=libname,colour=libname)) +
  geom_density() +
  geom_density(data=dftot2awt,aes(x=dGnorm,group=libname),color="black")+
  facet_grid(libname~mutant,scales="free_y")
#with this one, it makes me want to look at those in the far left extremes for them.
#even more, F and Y have big humps to the left of the main group so that is worth
# looking maybe at alignments or something there to see if these are maybe 
#hydrophobic or aromatic side chain guys mostly

#if I aggregate all 4abc into just lib4, etc, 
#then it works well and its clear that lib2 and lib3 are the best candidates for Y and F, although lib5 also looks ok
dftot2a
