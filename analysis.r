# Maxim Dubinin, sim@gis-lab.info
# Created: 16:19 28.03.2008
# Modified: 0:38 16.07.2013
# Analysis

Mode <- function(x) {
  ux <- unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}

datafile = "d:\\Programming\\Python\\universiade2013\\data\\all_data.csv"
d = read.csv(datafile)
dy = data.frame(CNTRY=d$CNTRY,YEAR=as.numeric(as.character(d$DOB_YEAR)))
dy = na.omit(dy)
meanyear_all = aggregate(dy$YEAR, by=list(dy$CNTRY), FUN=mean)

top10 = subset(d,d$CNTRY %in% c('RUS','USA','CHN','GER','GBR','FRA','JPN','KOR','CAN'))
top10 = data.frame(CNTRY=top10$CNTRY,YEAR=as.numeric(as.character(top10$DOB_YEAR)))
top10 = na.omit(top10)

meanyear = aggregate(top10$YEAR, by=list(top10$CNTRY), FUN=mean)
barplot(meanyear[,2] - mean(meanyear[,2]),xlab = "Страна", ylab = "Отклонение от среднего, лет",names.arg=meanyear[,1],ylim=c(-1,1))

medianyear = aggregate(top10$YEAR, by=list(top10$CNTRY), FUN=median)
barplot(medianyear[,2] - median(medianyear[,2]),xlab = "Страна", ylab = "Отклонение медианы от общей медианы, лет",names.arg=medianyear[,1],ylim=c(-2,2))

modeyear = aggregate(top10$YEAR, by=list(top10$CNTRY), FUN=Mode)
barplot(modeyear[,2] - mean(modeyear[,2]),xlab = "Страна", ylab = "Отклонение моды от общей моды, лет",names.arg=modeyear[,1],ylim=c(-2,2))


mfile = "d:\\Programming\\Python\\universiade2013\\data\\medals_total.csv"
m = read.csv(mfile)

cntr_medals_all = merge(meanyear_all,m,by.x="Group.1",by.y="CNTRY")
plot(2013-cntr_medals_all$x,cntr_medals_all$TOTAL,pch=19,xlab = "Средний возраст", ylab = "Общее количество медалей")