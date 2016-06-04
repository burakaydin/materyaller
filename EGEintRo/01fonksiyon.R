# require(MASS)
# ttestdata=data.frame(mvrnorm(n=100,mu=c(1,1.5),Sigma=matrix(c(1,0,0,1),2,2),empirical=T))
# write.csv(ttestdata,file="ttestdata.csv",row.names = F)
# rm(list=ls())



data=read.csv("01ttestdata.csv")  #datayi oku
head(data)                        #datanin ilk 10 sirasi
tail(data)                        #datanin son 10 sirasi

data$X1                   #X1i gor
mean(data$X1)             #X1in ortalamasi
mean(data$X2)             #X2in ortalamasi
var(data$X1)              #X1in varyansi
length(data$X1)           #X1in uzunlugu

fonk1=function(x){x^2}
fonk1(4)
  
EGEttest=function(X1,X2){
  x1smean=mean(X1)
  x2smean=mean(X2)
  x1svar=var(X1)
  x2svar=var(X2)
  x1ssize=length(X1)
  x2ssize=length(X2)
  tsta=(x1smean-x2smean)/sqrt((x1svar/x1ssize)+(x2svar/x2ssize))
  return(tsta)
}

# rm(list=setdiff(ls(),c("vhasttest")))
# cat("\014") 

names(data)=c("acemi","usta")
head(data)

EGEttest(data$acemi,data$usta)


require(stats)
?t.test
t.test(data$acemi,data$usta)


#ikinci ornek
data2=data.frame(erkek=rnorm(100),kadin=runif(100))
hist(data2$erkek)
hist(data2$kadin)


EGEttest(data2$erkek,data2$kadin)

EGEttest2=function(X1,X2){
  if (shapiro.test(X1)$p<.05 || shapiro.test(X2)$p<.05) 
    warning("normallik ihlali")
  x1smean=mean(X1)
  x2smean=mean(X2)
  x1svar=var(X1)
  x2svar=var(X2)
  x1ssize=length(X1)
  x2ssize=length(X2)
  tsta=(x1smean-x2smean)/sqrt((x1svar/x1ssize)+(x2svar/x2ssize))
  return(tsta)
}

EGEttest2(data2$erkek,data2$kadin)


EGEttest3=function(X1,X2){
  if (shapiro.test(X1)$p<.05 || shapiro.test(X2)$p<.05) 
    stop("normallik ihlali")
  x1smean=mean(X1)
  x2smean=mean(X2)
  x1svar=var(X1)
  x2svar=var(X2)
  x1ssize=length(X1)
  x2ssize=length(X2)
  tsta=(x1smean-x2smean)/sqrt((x1svar/x1ssize)+(x2svar/x2ssize))
  return(tsta)
}

EGEttest3(data2$erkek,data2$kadin)
#fonksiyonlar pakete, paketler internete...