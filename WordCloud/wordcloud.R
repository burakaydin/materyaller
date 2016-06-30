load("TextMineMAT.Rdata")
head(tdm2)
str(tdm2)


# see http://btovar.com/2015/04/text-mining-in-r/
library(wordcloud)
comparison.cloud(tdm2, random.order=FALSE, 
                 colors = c("deeppink", "yellowgreen", "red", "slateblue1"),
                 title.size=1.4, max.words=80,scale = c(5, 0.2))

commonality.cloud(tdm2, random.order=F, 
                  colors = brewer.pal(8, "Paired"),
                  scale = c(5, 0.3))

##yuzde
head(tdm2)
tdm3=apply(tdm2[1:105,], 2, function(x){x/sum(x)}) 

comparison.cloud(tdm3, random.order=FALSE, 
                 colors = c("deeppink", "yellowgreen", "red", "slateblue1"),
                 title.size=1.4, max.words=80,scale = c(5, 0.2))

commonality.cloud(tdm3, random.order=F, 
                  colors = brewer.pal(8, "Paired"),
                  scale = c(5, 0.3))
