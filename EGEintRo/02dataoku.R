#Veri Okuma ve basit islemler
# nerde calisiyorum?
getwd()

#calisma alanimda neler var?
list.files()

#hangi paketler yuklu?
search()

#data oku

## SPSS
#install.packages("foreign")
library(foreign)   # SPSS verisi okumak için gereken paket
data = read.spss("02veriSPSS.sav", to.data.frame=TRUE)  #datayi oku
head(data)



#1 clicking


#3
data3=read.csv("02vericsv.csv")

#4
data4=read.csv(file.choose())
str(data4)


#basla
data=read.csv("02vericsv.csv")



head(data)
#datanin ilk on sirasini gosterir.

summary(data)
# datanin kisa ozetini verir


str(data)
# structure datanin yapisini gosterir


data$AGE
# bu ornek data'dan AGE yi cagirir.

data[10:15,6:8]
#datadan kume cekmek: datanin 10.dan 15. e kadar satir, ve 6. dan 8. ye kadar sutunu sectik

head(data)
testdata=data[,c("X","TOTTTD","MALE","CITIZ","AGE")]
#datadan sonra [,] kullanarak subset alabiliriz.
# virgulun sol tarafi satirlari
# virgulun sag tarafi sutunlari temsil eder.  

testdata
head(testdata)
tail(testdata)



table(testdata$MALE)
#frekans tablosunu verir

with(testdata,table(MALE,CITIZ))
# ikili frekans tablosu

testdata$ege=testdata$TOTTTD+testdata$AGE
#yeni sutun olusturma


hist(testdata$ege)
#histogram cizer

hist(testdata$ege,freq=F)
lines(density(testdata$ege))
lines(density(testdata$ege,na.rm = TRUE))
#yogunluk grafigi


stem(testdata$ege)
# govde ve yaprak gosterimi


shapiro.test(testdata$ege)
# normality holds unless the null is rejected
# normal dagilim testi, eger p degeri .05 den buyukse, 
# normal dagilim varsayilabilir.


# F test is generally robust to type-I, but power might be an issue
# transform or use non parametric

shapiro.test

?shapiro.test

citation()
citation("stats")
citation("brew")


#paketlerim nerede?
.libPaths()
#anova

#install.packages("psych")

library(psych)

?describeBy


describeBy(testdata$ege, testdata$MALE)
#betimsel analiz, ege degiskenini cinsiyete gore aciklar.

with(testdata,describeBy(ege,MALE))
#ayni isi yapar, sadece ege ve MALE in "testdata" nin icinde oldugunu kullanir.


library(doBy)
lla=summaryBy(ege ~ MALE, data = testdata, 
          FUN = function(x) { c(m = mean(x,na.rm=T), s = sd(x,na.rm=T)) } )

lla

write.csv(lla,file="020_EGE_ortstd.csv")


plot(testdata$ege~testdata$MALE)

# Bartlett Test of Homogeneity of Variances
bartlett.test(testdata$ege~testdata$MALE)
#reject the null, variances are not equal

# Figner-Killeen Test of Homogeneity of Variances
fligner.test(testdata$ege~testdata$MALE)

require(car)

#run anova
str(testdata)
testdata$MALE=as.factor(testdata$MALE)
EGEanova <- aov(testdata$ege~testdata$MALE)
summary(EGEanova)

capture.output(summary(EGEanova),file="021testreport.doc")
write.csv(as.matrix(anova(lm(testdata$ege~testdata$MALE))), file = "022testreport2.csv", na = "")


#type iii
Anova(lm(testdata$ege~testdata$MALE),type="III")

# discussion http://www.uni-kiel.de/psychologie/dwoll/r/ssTypes.php

#follow ups
TukeyHSD(EGEanova)

#non-parametric anova
kruskal.test(testdata$ege~testdata$MALE)

#transformation

hist(testdata$ege)
hist(log(testdata$ege))

