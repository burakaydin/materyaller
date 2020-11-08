set.seed(1111)

#test
courseTAKERid=c(1111,2222,3333)
ogr.say=3
satir.say=30

odev=data.frame(Ogretmen=rep(1:ogr.say,each=satir.say),
                ID=1:(ogr.say*satir.say)+100,
                Cinsiyet=sample(c("Erkek","Kadin"),size =ogr.say*satir.say,replace = T ),
                Sehir=rep(rep(c("IST","ANK","IZM"),each =satir.say/3),times=ogr.say),
                Mat=sample(1:10,ogr.say*satir.say,replace = T),
                FenBil=sample(1:10,ogr.say*satir.say,replace = T),
                Bilim=sample(1:10,ogr.say*satir.say,replace = T))
head(odev)
odev$FenBil=as.integer((odev$FenBil*.7)+(0.3*odev$Mat))
odev$Bilim=as.integer((odev$Bilim*.5)+(0.3*odev$Mat)+(0.2*odev$FenBil)+(1*(odev$Cinsiyet=="Kadin"))+rnorm(mean=2,sd = 0,n =ogr.say*satir.say ))
summary(odev)


#test
cor(odev[,c("FenBil","Mat","Bilim")])
with(odev,t.test(Bilim~Cinsiyet))
summary(with(odev,aov(Bilim~Sehir)))
summary(with(odev,lm(Bilim~Mat+FenBil+Cinsiyet)))

splitodev=split(odev,odev$Ogretmen)
write.csv(splitodev,file="odevdata.csv")
save(splitodev,file="odevdata.RData")

library("rmarkdown")
library("knitr")
for (i in 1:ogr.say){
  kaf <- data.frame(splitodev[[i]])
  render("TESTrmd2.Rmd",output_file = paste0(courseTAKERid[i], '.doc'),encoding = "UTF-8")    
}

ModeR <- function(x) {
  ux <- unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}

sonuc=matrix(0,nrow=ogr.say,ncol=33)
for (i in 1:ogr.say){
  sonuc[i,1]=sum((splitodev[[i]]$Cinsiyet=="Kadin"))
  sonuc[i,2]=sum((splitodev[[i]]$Cinsiyet=="Erkek"))
  sonuc[i,3]=ModeR(splitodev[[i]]$Mat)
  sonuc[i,4]=median(splitodev[[i]]$Mat)
  sonuc[i,5]=mean(splitodev[[i]]$Mat)
  sonuc[i,6]=min(splitodev[[i]]$Mat)
  sonuc[i,7]=max(splitodev[[i]]$Mat)
  sonuc[i,8]=max(splitodev[[i]]$Mat)-min(splitodev[[i]]$Mat)
  sonuc[i,9]=var(splitodev[[i]]$Mat)
  sonuc[i,10]=sd(splitodev[[i]]$Mat)
  sonuc[i,11]=t.test(splitodev[[i]]$FenBil,       
                     alternative="two.sided",
                     mu=5,
                     conf.level = 0.95)$statistic
  sonuc[i,12]=qt(.975,df=29)
  sonuc[i,13]=qt(.995,df=29)
  sonuc[i,14]=ifelse(abs(sonuc[i,11])>sonuc[i,12],1,0)
  
  sonuc[i,15]=cor(splitodev[[i]]$Mat,splitodev[[i]]$FenBil)
  sonuc[i,16]=cor(splitodev[[i]]$Mat,splitodev[[i]]$Bilim)
  sonuc[i,17]=cor(splitodev[[i]]$FenBil,splitodev[[i]]$Bilim)
  
  
  
  sonuc[i,18]=t.test(splitodev[[i]]$Bilim~splitodev[[i]]$Cinsiyet)$statistic
  sonuc[i,19]=qt(.975,df=28)
  sonuc[i,20]=qt(.995,df=28)
  sonuc[i,21]=ifelse(abs(sonuc[i,18])>sonuc[i,19],1,0)
  
  sonuc[i,22]=summary(aov(splitodev[[i]]$Bilim~splitodev[[i]]$Sehir))[[1]]$F[1]
  sonuc[i,23]=qf(.95,2,27)
  sonuc[i,24]=qf(.90,2,27)
  sonuc[i,25]=ifelse(abs(sonuc[i,22])>sonuc[i,23],1,0)
  
  sonuc[i,26]=summary(lm(splitodev[[i]]$Bilim~splitodev[[i]]$Cinsiyet+splitodev[[i]]$Mat+splitodev[[i]]$FenBil))$fstatistic[1]
  sonuc[i,27]=summary(lm(splitodev[[i]]$Bilim~splitodev[[i]]$Cinsiyet+splitodev[[i]]$Mat+splitodev[[i]]$FenBil))$coef[3,3]
  sonuc[i,28]=summary(lm(splitodev[[i]]$Bilim~splitodev[[i]]$Cinsiyet+splitodev[[i]]$Mat+splitodev[[i]]$FenBil))$coef[3,4]
  sonuc[i,29]=summary(lm(splitodev[[i]]$Bilim~splitodev[[i]]$Cinsiyet+splitodev[[i]]$Mat+splitodev[[i]]$FenBil))$coef[4,3]
  sonuc[i,30]=summary(lm(splitodev[[i]]$Bilim~splitodev[[i]]$Cinsiyet+splitodev[[i]]$Mat+splitodev[[i]]$FenBil))$coef[4,4]
  sonuc[i,31]=summary(lm(splitodev[[i]]$Bilim~splitodev[[i]]$Cinsiyet+splitodev[[i]]$Mat+splitodev[[i]]$FenBil))$coef[2,3]
  sonuc[i,32]=summary(lm(splitodev[[i]]$Bilim~splitodev[[i]]$Cinsiyet+splitodev[[i]]$Mat+splitodev[[i]]$FenBil))$coef[1,1]+7*summary(lm(splitodev[[i]]$Bilim~splitodev[[i]]$Cinsiyet+splitodev[[i]]$Mat+splitodev[[i]]$FenBil))$coef[3,1]+8*summary(lm(splitodev[[i]]$Bilim~splitodev[[i]]$Cinsiyet+splitodev[[i]]$Mat+splitodev[[i]]$FenBil))$coef[4,1]
  sonuc[i,33]=summary(lm(splitodev[[i]]$Bilim~splitodev[[i]]$Cinsiyet+splitodev[[i]]$Mat+splitodev[[i]]$FenBil))$adj.r.squared
  }
sonuc=data.frame(sonuc)
colnames(sonuc)=c("o1_ks","o1_es","o1_mod","o1_med","o1_ort","o1_min","o1_max","o1_ranj","o1_var","o1_sd",
                  "o2_t","o2_tk1","o2_tk2","o2_sonuc",
                  "o3_corMF","o3_corMB","o3_corFB",
                  "o4_t","o4_tk1","o4_tk2","o4_sonuc",
                  "o5_F","o5_Fk1","o5_Fk2","o5_sonuc",
                  "o6_RegF","o6_tMat","o6_pMat","o6_tFen","o6_pFen","o6_pCins","o6_tahmin","o6_rsqared")

write.csv(sonuc,file="odevsonuc.csv")

## lets use jamovi to test



