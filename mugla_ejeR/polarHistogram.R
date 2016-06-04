#' polarHistogram builds many  histogram and arranges them around a circle to save space.
#' C. Ladroue, after Kettunen, J. et al. Genome-wide association study identifies multiple loci influencing human serum metabolite levels. Nat Genet advance online publication (2012). URL http://dx.doi.org/10.1038/ng.1073.
#' CC licence: http://creativecommons.org/licenses/by-nc-sa/3.0/ 
#' Attribution - You must attribute the work in the manner specified by the author or licensor (but not in any way that suggests that they endorse you or your use of the work).
#' Noncommercial - You may not use this work for commercial purposes.
#' Share Alike - If you alter, transform, or build upon this work, you may distribute the resulting work only under the same or similar license to this one. 
#'
#' v. 21022012
#'
#' The data frame is expected to have at least four columns: family, item, score and value. 
#' The three first columns are categorical variables, the fourth column contains non-negative values.
#' See testPolarHistogram.R for an example.
#' Each bar represents the proportion of scores for one item. Items can be grouped by families.
#' The resulting graph can be busy and might be better off saved as a pdf, with ggsave("myGraph.pdf").
#'
#' @author Christophe Ladroue
#' @param df a data frame containing the data
#' @param binSize width of the bin. Should probably be left as 1, as other parameters are relative to it.
#' @param spaceItem space between bins
#' @param spaceFamily space between families
#' @param innerRadius radius of inner circle
#' @param outerRadius radius of outer circle. Should probably be left as 1, as other parameters are relative to it.
#' @param guides a vector with percentages to use for the white guide lines
#' @param alphaStart offset from 12 o'clock in radians
#' @param circleProportion proportion of the circle to cover
#' @param direction whether the increasing count goes from or to the centre.
#' @param familyLabels logical. Whether to show family names
#' @return a ggplot object
#' @export
#' @examples
#' See testPolarHistogram.R

polarHistogram<-function(
  df,
  binSize=1,
  spaceItem=0.2,
  spaceFamily=1.2,
  innerRadius=0.3,
  outerRadius=1,
  guides=c(10,20,40,80),
  alphaStart=-0.3,
  circleProportion=0.8,
  direction="inwards",
  familyLabels=FALSE){
  
  # ordering
  df<-arrange(df,family,item,score)
  
  # summing up to one
  # TO DO: replace NA by 0 because cumsum doesn't ignore NA's.
  df<-ddply(df,.(family,item),transform,value=cumsum(value/(sum(value))))
  
  # getting previous value
  df<-ddply(df,.(family,item),transform,previous=c(0,head(value,length(value)-1)))
  
  # family and item indices. There must be a better way to do this
  df2<-ddply(df,.(family,item),summarise,indexItem=1)
  df2$indexItem<-cumsum(df2$indexItem)
  df3<-ddply(df,.(family),summarise,indexFamily=1)
  df3$indexFamily<-cumsum(df3$indexFamily)
    
  df<-merge(df,df2,by=c("family",'item'))
  df<-merge(df,df3,by="family")
    
  df<-arrange(df,family,item,score)
    
  # define the bins
  # linear projection  
  affine<-switch(direction,
                 'inwards'= function(y) (outerRadius-innerRadius)*y+innerRadius,
                 'outwards'=function(y) (outerRadius-innerRadius)*(1-y)+innerRadius,
                 stop(paste("Unknown direction")))
  
  df<-within(df,{
             xmin<-(indexItem-1)*binSize+(indexItem-1)*spaceItem+(indexFamily-1)*(spaceFamily-spaceItem)
             xmax<-xmin+binSize
             ymin<-affine(1-previous)
             ymax<-affine(1-value)
             }
             )
  
  # build the guides
  guidesDF<-data.frame(
    xmin=rep(df$xmin,length(guides)),
    y=rep(1-guides/100,1,each=nrow(df)))
  
  guidesDF<-within(guidesDF,{
    xend<-xmin+binSize
    y<-affine(y)
  })
      
  
  # Building the ggplot object
  
  totalLength<-tail(df$xmin+binSize+spaceFamily,1)/circleProportion-0

  # histograms
  p<-ggplot(df)+geom_rect(
    aes(
      xmin=xmin,
      xmax=xmax,
      ymin=ymin,
      ymax=ymax,
      fill=score)
    )
  
  # item labels
  readableAngle<-function(x){
    angle<-x*(-360/totalLength)-alphaStart*180/pi+90
    angle+ifelse(sign(cos(angle*pi/180))+sign(sin(angle*pi/180))==-2,180,0)
  }
  readableJustification<-function(x){
    angle<-x*(-360/totalLength)-alphaStart*180/pi+90
    ifelse(sign(cos(angle*pi/180))+sign(sin(angle*pi/180))==-2,1,0)
  }
  
  dfItemLabels<-ddply(df,.(item),summarize,xmin=xmin[1])
  dfItemLabels<-within(dfItemLabels,{
    x<-xmin+binSize/2
    angle<-readableAngle(xmin+binSize/2)
    hjust<-readableJustification(xmin+binSize/2)
    })

  p<-p+geom_text(
    aes(
      x=x,
      label=item,
      angle=angle,
      hjust=hjust),
    y=1.02,
    size=3,
    vjust=0.5,
    data=dfItemLabels)
  
  # guides  
  p<-p+geom_segment(
    aes(
      x=xmin,
      xend=xend,
      y=y,
      yend=y),
    colour="white",
    data=guidesDF)
  
  # label for guides
  guideLabels<-data.frame(
    x=0,
    y=affine(1-guides/100),
    label=paste(guides,"% ",sep='')
    )
  
  p<-p+geom_text(
    aes(x=x,y=y,label=label),
    data=guideLabels,
    angle=-alphaStart*180/pi,
    hjust=1,
    size=4)
  
  # family labels
  if(familyLabels){
#     familyLabelsDF<-ddply(df,.(family),summarise,x=mean(xmin+binSize),angle=mean(xmin+binSize)*(-360/totalLength)-alphaStart*180/pi)
    familyLabelsDF<-aggregate(xmin~family,data=df,FUN=function(s) mean(s+binSize))
    familyLabelsDF<-within(familyLabelsDF,{
      x<-xmin
      angle<-xmin*(-360/totalLength)-alphaStart*180/pi
    })

    p<-p+geom_text(
      aes(
        x=x,
        label=family,
        angle=angle),
    data=familyLabelsDF,
    y=1.2)
  }  
#   # empty background and remove guide lines, ticks and labels
  p<-p+theme(
    panel.background=element_blank(),
    axis.title.x=element_blank(),
    axis.title.y=element_blank(),
    panel.grid.major=element_blank(),
    panel.grid.minor=element_blank(),
    axis.text.x=element_blank(),
    axis.text.y=element_blank(),
    axis.ticks=element_blank()
    )
  
  # x and y limits
  p<-p+xlim(0,tail(df$xmin+binSize+spaceFamily,1)/circleProportion)
  p<-p+ylim(0,outerRadius+0.2)
  
  # project to polar coordinates
  p<-p+coord_polar(start=alphaStart)
  
  # nice colour scale
  p<-p+scale_fill_brewer(palette='Set1',type='qual')
  
  p
}