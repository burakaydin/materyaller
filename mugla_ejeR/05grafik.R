# Christophe Ladroue
library(plyr)
library(ggplot2)
library(reshape2)
source("polarHistogram.R")

isa=data.frame(gen=rep(c("m","f"),times=36),nam=as.character(1:36),
               dogru=as.integer(abs(rnorm(36,mean=12,sd=2))),
               hata=as.integer(abs(rnorm(36,mean=7,sd=1))),
               eksik=as.integer(abs(rnorm(36,mean=6,sd=2))),
               yanlis=as.integer(abs(rnorm(36,mean=40,sd=5))),
               bos=as.integer(abs(rnorm(36,mean=8,sd=5))),
               hf=as.integer(abs(rnorm(36,mean=2,sd=2))),
               hek=as.integer(abs(rnorm(36,mean=2,sd=2))))
head(isa)
isa2<-melt(isa,c("gen","nam"),variable_name="score")
names(isa2)=c("family","item","score","value")
p<-polarHistogram(isa2,familyLabel=FALSE)
print(p)


library(ggplot2)
# sort the constituencies backward, to have them listed alphabetically from top to bottom in the graph
# levels(byLevel1$region)<-rev(levels(byLevel1$region))
# p<-ggplot(byLevel1)
# p<-p+geom_bar(aes(x=region,Vacancies2011,fill=level1),position='fill')
# p<-p+coord_flip()+scale_fill_brewer(type='qual',palette='Set1')
# print(p)

dat = data.frame(server = paste("svr", round(runif(1000, 1, 10)), sep = ""),
                 time = Sys.time() + sort(round(runif(1000, 1, 36000))))
dat$hr = strftime(dat$time, "%H")

hits_hour = count(dat, vars = c("server","hr"))
head(hits_hour)
ggplot(data = isa2) + geom_bar(aes(x = item, y = value, fill = score), stat="identity", position = "dodge")



p<-ggplot(isa2)
p<-p+geom_bar(aes(x=item,value,fill=score),position='fill',stat="identity")
p<-p+coord_flip()+scale_fill_brewer(type='qual',palette='Set1')
print(p)


ggplot(isa2) + geom_bar(aes(item, y = value, fill=score), stat="identity") + coord_flip()

