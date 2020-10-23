library(httr)
library(rvest)
library(jpeg)
library(dplyr)
library(gdata)
library(sos)
library(glue)
library(stringr)

setwd('C:\\Users\\Jaymes Pyne\\Google Drive\\1_Stanford_Pyne\\Classes\\Coursera\\Data_Science_Specialization\\3 Getting and Cleaning Data\\2_Data')
features<-read.table('./UCI HAR Dataset/features.txt')
nms<-features$V2

xtest<-read.table('./UCI HAR Dataset/test/X_test.txt',col.names=nms)
ytest<-read.table('./UCI HAR Dataset/test/y_test.txt')
subtest<-read.table('./UCI HAR Dataset/test/subject_test.txt')

xtrain<-read.table('./UCI HAR Dataset/train/X_train.txt',col.names=nms)
ytrain<-read.table('./UCI HAR Dataset/train/y_train.txt')
subtrain<-read.table('./UCI HAR Dataset/train/subject_train.txt')

allx0<-rbind(xtest,xtrain)
	allx0$nmeanstd<-as.numeric(rownames(allx0))
	allx1<-allx0[,grep("[Mm]ean",names(allx0))]
	allx2<-allx0[,grep("[Ss]td",names(allx0))]
	allx3<-merge(allx1,allx2,by="nmeanstd")
	allx<-allx3[,!grepl("Freq",names(allx3))]
	
ally<-rbind(ytest,ytrain)
	names(ally)<-c("activity")
	ally$obs<-as.numeric(rownames(ally))

alls<-rbind(subtest,subtrain)
	names(alls)<-c("subject")
	alls$obs<-as.numeric(rownames(alls))

final0<-merge(alls,ally,by="obs")
final<-merge(final0,allx,by.x="obs",by.y="nmeanstd")
	write.csv(final,'tidyset1.csv')
final2<-aggregate(.~activity+subject,mean,data=final)
	write.csv(final2,'tidyset2.csv')

library(dataMaid)
makeCodebook(final)
makeCodebook(final2)






