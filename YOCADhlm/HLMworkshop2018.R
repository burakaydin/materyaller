#datayi oku BASS:
dataTFGA=read.csv("Balanced2L.csv")

#write.csv2(dataTFGA,file="BASS2016_CAB_csv2.csv",row.names=F)
# data 600 sira ve 5 sutuna sahip
head(dataTFGA)

#id        : her birey icin kimlik no
#condition : mudahele
#CABpre    : on-test
#CABpost   : son-test
#teacherid : sinif kimlik no

#data ozet
summary(dataTFGA)
#0n-test son-test dagilim grafigi
hist(dataTFGA$CABpost)
hist(dataTFGA$CABpre)
#ozet icin paket 
library(psych)

#sontest ozet
describe(dataTFGA$CABpost)
describeBy(dataTFGA$CABpost,dataTFGA$condition)

#on test ozet
describe(dataTFGA$CABpre)

# basiklik carpiklik
library(moments)
skewness(dataTFGA$CABpost)
kurtosis(dataTFGA$CABpost)
kurtosis(dataTFGA$CABpost)-3
kurtosis(dataTFGA$CABpre)
kurtosis(dataTFGA$CABpre)-3


# ortalamaya gore merkezilestirme GOM ontest
dataTFGA$grandcnt=dataTFGA$CABpre-mean(dataTFGA$CABpre)

#regresyon modeli
model0=lm(CABpost~grandcnt+condition,data=dataTFGA)
summary(model0)
require(car)
library(MASS)

#Regresyon Hatalarin Dagilimi
sresid <- studres(model0) 
hist(sresid, freq=FALSE, 
     main="Regresyon Hatalarin Dagilimi")
xfit<-seq(min(sresid),max(sresid),length=40) 
yfit<-dnorm(xfit) 
lines(xfit, yfit)
crPlots(model0)
png(file="selfDECEPTION.png",width=600,height=800,res=100)
crPlots(model0)
dev.off()


##NULL/ BOS model 
require(nlme)
require(multilevel)
nullmodelREML<-lme(CABpost~1,random=~1|teacherid, data=dataTFGA,method = "REML",
               control=list(opt="optim"),na.action = na.omit)
summary(nullmodelREML)

#toplam varyans
nop=as.numeric(VarCorr(nullmodelREML)[2])+as.numeric(VarCorr(nullmodelREML)[1])
nop
var(dataTFGA$CABpost)
# daha fazla detay https://www.aydinburak.net/single-post/2017/11/14/Totalvarianceeiju0j

#ML and REML ICC
model<-lme(CABpost~1,random=~1|teacherid,data=dataTFGA)
comp=as.numeric(VarCorr(model))
remlicc=comp[1]/(comp[1]+comp[2])
remlicc

model<-lme(CABpost~1,random=~1|teacherid,data=dataTFGA,method="ML")
comp=as.numeric(VarCorr(model))
mlicc=comp[1]/(comp[1]+comp[2])
mlicc

#Raudenbush Bryk 2002 pg 53 REML carpi duzeltme faktoru gamma=1
J=length(unique(dataTFGA$teacherid))
remlicc*(J-1)/J


# Rassal Kesim modeli
model1REML<-lme(CABpost~grandcnt+condition,random=~1|teacherid, data=dataTFGA,
            control=list(opt="optim"),na.action = na.omit)
summary(model1REML)
#varyans homojenligi, varyanslarin homojen olmadigi durumda tahminleyicide modifikasyon gerekir
plot(model1REML)


#serbestlik derecesi n*J= 12*50=600
# 2. duzey : J-m0-p2= 50-1-1 (Pinhero&Bates s91 Q=1,m0=1(intercept),m1=50,m2=600,p1=1,p2=1)
# 1. duzey " (Tüm orneklem)-(J+p) = 600-51= 549. Snijders ve Boskere gore 600-1-1 farkeder mi?
anova(model1REML)

model1ML<-lme(CABpost~grandcnt+condition,random=~1|teacherid, data=dataTFGA,
            control=list(opt="optim"),na.action = na.omit,method="ML")
summary(model1ML)


nullmodelML<-lme(CABpost~1,random=~1|teacherid, data=dataTFGA,
               control=list(opt="optim"),na.action = na.omit,method="ML")

# Likelihood Ratio Test 
anova(nullmodelML,model1ML)

#rassal kesim modeli ile toplam varyans
p1=as.numeric(VarCorr(model1REML)[2])+as.numeric(VarCorr(model1REML)[1])
p1

#rassal kesim modeli ile bos modele nazaran aciklanan varyans, pseudo R2
global1= round(((nop-p1)/nop),3)*100
global1

#rassal kesim egim modeli
model1aREML<-lme(CABpost~grandcnt+condition,random=~grandcnt|teacherid, data=dataTFGA,
             control=list(opt="optim"),na.action = na.omit)
summary(model1aREML)
VarCorr(model1aREML)
VarCorr(model1REML)

#varyans homojenligi, varyanslarin homojen olmadigi durumda tahminleyicide modifikasyon gerekir
plot(model1aREML)

# rassal egim varyansini goz ardi ederek pseudo R2
p1a=as.numeric(VarCorr(model1aREML)[3])+as.numeric(VarCorr(model1aREML)[1])
global1a= round(((nop-p1a)/nop),3)*100


#deviance test , rassal egim varyansi
anova(model1REML,model1aREML)

#deviance test ML , rassal egim varyansi
model1aML<-lme(CABpost~grandcnt+condition,random=~grandcnt|teacherid, data=dataTFGA,
                 control=list(opt="optim"),na.action = na.omit,method = "ML")

#deviance test , rassal egim varyansi
anova(model1ML,model1aML)


# egim grafikleri
dataTFGA2=dataTFGA[order(dataTFGA$condition),]
dataTFGA2$id2=rep(1:50,each=12)
library(lattice)
xyplot(CABpost~grandcnt|as.factor(id2),data=dataTFGA2,
       type=c("p","g","r"),col="black",col.line="black",
       xlab="On-test",
       ylab="Son-test")


#group mean centering/ kume ortalamasi etrafinda merkezilestirme KOM
require(plyr)
dataTFGA3=dataTFGA
dataTFGA3=ddply(dataTFGA3, "teacherid", transform,  pregmean= mean(CABpre))
dataTFGA3$grpcnt=with(dataTFGA3,CABpre-pregmean)
head(dataTFGA3)
#iki yeni degisken, pregmean=kume ortalamasi, grpcnt=KOM

#KOM analizleri rassal kesim
model1b<-lme(CABpost~pregmean+grpcnt+condition,random=~1|teacherid, data=dataTFGA3,
             control=list(opt="optim"),na.action = na.omit)
summary(model1b)
VarCorr(model1b)

# Raporlanmamis KOM analizleri rassal kesim egim
model1c<-lme(CABpost~pregmean+grpcnt+condition,random=~grpcnt|teacherid, data=dataTFGA3,
             control=list(opt="optim"),na.action = na.omit)
summary(model1c)
VarCorr(model1c)



#context effect Esitlik 32
model1e<-lme(CABpost~pregmean+CABpre,random=~1|teacherid, data=dataTFGA3,
             control=list(opt="optim"),na.action = na.omit)
summary(model1e)
VarCorr(model1e)

##context effect Esitlik 33
model1f<-lme(CABpost~pregmean+grpcnt,random=~1|teacherid, data=dataTFGA3,
             control=list(opt="optim"),na.action = na.omit)
summary(model1f)
VarCorr(model1f)


##Assumption Check Varsayim kontrolu model1 a 
par(mfrow=c(1,1))

plot(model1aREML,xlab="Tahmin",ylab="Standardize Hata")
qqnorm(resid(model1aREML), main="Duzey-1 hata",xlab="teorik deger",ylab = "deger")
qqnorm(ranef(model1aREML)$`(Intercept)`, main="Kesim hata",xlab="teorik deger",ylab = "deger")
qqnorm(ranef(model1aREML)$grandcnt, main="Egim hata",xlab="teorik deger",ylab = "deger")

# Interaction?
summary(lme(CABpost~condition+CABpre+CABpre*condition,random=~1|teacherid, data=dataTFGA3,
            control=list(opt="optim"),na.action = na.omit))

summary(lme(CABpost~condition+pregmean+grpcnt+pregmean*condition+grpcnt*condition,
            random=~1|teacherid, data=dataTFGA3,
            control=list(opt="optim"),na.action = na.omit))



#Veri seti iki WorldBANK Turkiye
dataEGBA=read.csv("dataEGBAyocad.csv",header = F)
names(dataEGBA)=c("binitem1","yod","age","incomePCTRANS","FEM","id1","ilID")
head(dataEGBA)
library(lme4)
modellog=glmer(formula = binitem1 ~ yod+age+incomePCTRANS+FEM+(1 | ilID) , family = binomial,data=dataEGBA)
summary(modellog)

# The college effect was also detected on dual-earning (B=.238, SE=.066), holding
# constant the other fixed and random effects, the expected odds of answering ‘strongly
# agree’ for college graduates were 1.27 (exp(.238)) times the odds of answering ‘strongly agree’ for
# non-college graduates.

modellogMPLUS=glmer(formula = binitem1 ~ yod+incomePCTRANS+(1 | ilID) , family = binomial,data=dataEGBA)
summary(modellogMPLUS)



# Uc duzeyli model West, Welch ve Galecki s.162
rm(list=ls())
require(WWGbook)
require(nlme)
classroomDATA=WWGbook::classroom
model4.1.fit <- lme(mathgain ~ 1, random = ~ 1 | schoolid/classid, data=classroomDATA, method = "REML")
summary(model4.1.fit)


model4.1A.fit <- lme(mathgain ~ 1, random = ~1 | schoolid, data=classroomDATA, method = "REML")
anova(model4.1.fit, model4.1A.fit)

model4.2.fit <- lme(mathgain ~ mathkind, random = ~1 | schoolid/classid, 
                    data=classroomDATA, na.action = "na.omit", method = "REML")

summary(model4.2.fit)



> # Model 4.1: ML estimation with lme(). > 
model4.1.ml.fit <- lme(mathgain ~ 1, random = ~1 | schoolid/classid, data=classroomDATA, method = "ML") 
# Model 4.2: ML estimation with lme(). > 
model4.2.ml.fit <- lme(mathgain ~ mathkind, random = ~1 | schoolid/classid, 
                       data=classroomDATA, na.action = "na.omit", method = "ML") 
anova(model4.1.ml.fit, model4.2.ml.fit)

model4.3.fit <- update(model4.2.fit, fixed = ~ mathkind + mathknow)
summary(model4.3.fit)

model4.4.fit <- update(model4.2.fit, fixed = ~ mathkind + mathknow + housepov,data=classroomDATA, na.action = "na.omit", method = "ML")
summary(model4.4.fit)

classroomDATAmplus=classroomDATA[,c("mathgain","mathkind","mathknow","housepov","classid","schoolid","childid")]
classroomDATAmplus=na.omit(classroomDATAmplus)
#classroomDATAmplus[is.na(classroomDATAmplus)]= (-99)
#write.csv(classroomDATAmplus,file="classroomDATAmplus.csv",row.names = F,col.names = F)
write.table( classroomDATAmplus, sep=",",  col.names=FALSE, file="classroomDATAmplus.csv",row.names = F)

#further
model4.2.ml.rs <- lme(mathgain ~ mathkind + mathknow + housepov, random = list(schoolid = ~mathkind, classid = ~mathkind), 
                       data=classroomDATA, na.action = "na.omit", method = "ML") 
summary(model4.2.ml.rs)

model4.2.ml.rs2 <- lme(mathgain ~ mathkind + mathknow + housepov, random = list(schoolid = ~1, classid = ~mathkind), 
                      data=classroomDATA, na.action = "na.omit", method = "ML") 
summary(model4.2.ml.rs2)

model4.2.ml.rs3 <- lme(mathgain ~ mathkind + mathknow + housepov, random = list(schoolid = ~mathknow, classid = ~1), 
                       data=classroomDATA, na.action = "na.omit", method = "ML") 
summary(model4.2.ml.rs3)

model4.2.ml.rs4 <- lme(mathgain ~ mathkind + mathknow + housepov, random = list(schoolid = ~mathknow+mathkind, classid = ~1), 
                       data=classroomDATA, na.action = "na.omit", method = "ML") 
summary(model4.2.ml.rs4)

model4.2.ml.rs5 <- lme(mathgain ~ mathkind + mathknow + housepov, random = list(schoolid = ~mathknow+mathkind, classid = ~mathkind), 
                       data=classroomDATA, na.action = "na.omit", method = "ML") 
summary(model4.2.ml.rs5)


#Hard coded solution

#hand calculation (ANOVA) by Kuehl
# SSW
sswfun<- function(y,id,J,n) {
  return(
    sum((y-tapply(y,id,mean)[id])^2))
}
# kume sayisi
J=length(unique(dataTFGA$teacherid))
#kume basi birey sayisi
n=nrow(dataTFGA)/J
sswk=with(dataTFGA,sswfun(CABpost,factor(teacherid),J,n))

#MSW
mswfun<- function(y,id,J,n) {
  return(
    sum((y-tapply(y,id,mean)[id])^2)/(J*(n-1)))
}


msw=with(dataTFGA,mswfun(CABpost,factor(teacherid),J,n))

#SSB
ssbfun<-function(y,id,J,n){
  return(
    (sum((tapply(y,id,mean)-mean(y))^2)*n)
  )
}

ssbk=with(dataTFGA,ssbfun(CABpost,factor(teacherid),J,n))

#MSB
msbfun<-function(y,id,J,n){
  return(
    (sum((tapply(y,id,mean)-mean(y))^2))*n/(J-1)
  )
}

msb=with(dataTFGA,msbfun(CABpost,factor(teacherid),J,n))

#sigma hat
sigmahat=msw
#tauhat
tauhat=(msb-sigmahat)/n

# Kumeici korelasyon (ICC) KIK
anovaicc=tauhat/(tauhat+sigmahat)

#95% confidence interval
F0=msb/msw
Fupp=qf(.975,(J-1),J*(n-1))
Flow=qf(.025,(J-1),J*(n-1))
lowericc=(F0-Fupp)/(F0+(n-1)*Fupp)
uppericc=(F0-Flow)/(F0+(n-1)*Flow)

#95% CI for SSW
sswk/qchisq(.975, J*(n-1))
sswk/qchisq((1-.975), J*(n-1))

#95% CI for tau
fdis1=qf(.975,J-1,J*(n-1))
fdis2=qf(.025,J-1,J*(n-1))

ssbk*(1-(fdis2/(msb/msw)))/(n*qchisq(.025,J-1))
ssbk*(1-(fdis1/(msb/msw)))/(n*qchisq(.975,J-1))


#95% CI for gamma
tdist=qt(.975,J-1)
gammak=mean(dataTFGA$CABpost)
gammak-(sqrt(msb/(n*J))*tdist)
gammak+(sqrt(msb/(n*J))*tdist)



# f test for ICC
F0
#kritik deger
qf(.95,J-1,J*(n-1))
#p degeri
1-pf(F0,J-1,J*(n-1))


#Tasari etkisi / design effect
DE=1+(n-1)*anovaicc






