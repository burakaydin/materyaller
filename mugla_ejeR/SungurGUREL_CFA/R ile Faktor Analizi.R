#veri setinin bulundugu dosyanin konumunu tanit
setwd("C:/Users/s.gurel/Dropbox/mugla ejer kongre/calistay")
#veri setini yukle
data=read.csv(file="imputed.data.csv")
str(data)

#dogrulayici faktor analizi icn gerekli paket
library(lavaan)

okuma.dfa='rekabet =~ s12 + s17 + s18 + s22 + s29 + s36 + s43 + s49 + s50
           merak   =~ s5 + s8 + s13 + s16
           onem    =~ s32 + s39 + s47 + s50 + s52 + s53'

dfa.okuma=cfa(okuma.dfa,
              
              ordered=c("s12","s17","s18","s22","s29","s36",
                        "s43","s49","s50","s5","s8","s13",
                        "s16","s32","s39","s47","s52","s53"),
              
              data=data,
              
              estimator="WLSMV",
              
              std.lv=TRUE )


#model sonuclari
summary(dfa.okuma,
        
        fit.measures=TRUE)

#faktor puanlarini hesapama
faktor.puanlari=data.frame(predict(dfa.okuma))

faktor.puanlari[1:15,]



