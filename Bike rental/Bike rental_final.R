rm(list=ls())
setwd("G:/bike rental project/R")
rent=read.csv("day.csv",header=T)
rent=rent[,-c(1,2)]
for (i in c(1,2,3,4,5,6,7))
{rent[,i]=as.factor(rent[,i])
}
sum(is.na(rent))
numeric_index=sapply(rent,is.numeric)
numeric_data=rent[,numeric_index]
cnames=colnames(numeric_data)
cnames
library(ggplot2)
for(i in 1:length(cnames))
{assign(paste0("gn", i),ggplot(aes_string(y = (cnames[i]),x = "cnt")
                               ,data = subset(rent))+ stat_boxplot(geom = "errorbar", width = 0.5)+
          geom_boxplot(outlier.colour="RED",
                       fill ="grey", outlier.shape = 18, outlier.size = 1, notch = FALSE)+theme(legend.position = 'bottom')
        +
          labs(y = cnames[i],x = 'Count')+
          ggtitle(paste("Box plot of Count for", cnames[i])))}

library(gridExtra)
gridExtra::grid.arrange(gn1,gn2,gn3,ncol = 3)
gridExtra::grid.arrange(gn4,gn5,ncol = 2)
gridExtra::grid.arrange(gn6,gn7,ncol = 2)
library(DMwR)
for(i in cnames)
{
  print(i)
  val=rent[,i][rent[,i]%in% boxplot.stats(rent[,i])$out]
  print(length(val))
  rent=rent[which(!rent[,i]%in%val),]
}
library(corrplot)
library(caret)
correlation=cor(rent[,numeric_index])
correlation
corrplot.mixed(correlation,tl.offset=0.01,tl.cex=0.01)
findCorrelation(correlation,cutoff = 0.6)
rent=rent[,-c(9,12,13)]
index=sample(nrow(rent),0.7*nrow(rent))
train=rent[index,]
test=rent[-index,]
lm=lm(cnt~.,data=train)
summary(lm)
