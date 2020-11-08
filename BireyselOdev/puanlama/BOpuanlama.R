datfiles <- list.files()
#select the files you would like to merge, say first 24
datfiles=datfiles[2:4]
#use do call and rbind to merge multiple files
library(readxl)
merged=do.call("rbind", lapply(datfiles, read_excel))
head(merged)
merged=data.frame(merged)


#sonuclar
sonuc=read.csv("../odevsonuc.csv")

head(sonuc)
sonuc1=sonuc[,1:11]

merged=round(merged,1)
sonuc1=round(sonuc1,1)

puanlama=merge(merged,sonuc1,by="OgretmenNo")

puanlama$p1=with(puanlama,ifelse((KadinSayisi-o1_ks)==0,1,0))
puanlama$p2=with(puanlama,ifelse((ErkekSayisi-o1_es)==0,1,0))
puanlama$p3=with(puanlama,ifelse((Mod-o1_mod)==0,1,0))
puanlama$p4=with(puanlama,ifelse((Medyan-o1_med)==0,1,0))
puanlama$p5=with(puanlama,ifelse((Ortalama-o1_ort)==0,1,0))
puanlama$p6=with(puanlama,ifelse((Min-o1_min)==0,1,0))
puanlama$p7=with(puanlama,ifelse((Max-o1_max)==0,1,0))
puanlama$p8=with(puanlama,ifelse((Ranj-o1_ranj)==0,1,0))
puanlama$p9=with(puanlama,ifelse(abs(Var-o1_var)<0.1,3,0))
puanlama$p10=with(puanlama,ifelse(abs(SS-o1_sd)<0.1,4,0))

puanlama$odev1not=rowSums(puanlama[,23:32])
