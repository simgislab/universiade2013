# Maxim Dubinin, sim@gis-lab.info
# Created: 16:19 28.03.2008
# Modified: 0:38 16.07.2013
# Analysis

datafile = "d:\\Programming\\Python\\universiade\\all_data.csv"

d = read.csv(datafile)
d = subset(d,d$CNTRY == c('RUS','USA','CHN','GER','GBR','FRA','JPN','KOR','CAN'))

dd = data.frame(CNTRY=d$CNTRY,YEAR=as.numeric(as.character(d$DOB_YEAR)))
#dd[complete.cases(dd),]
dd = na.omit(dd)

meanage = aggregate(dd$YEAR, by=list(dd$CNTRY), FUN=mean)
barplot(meanage[,2] - mean(meanage[,2]),xlab = "Страна", ylab = "Отклонение от среднего, лет",names.arg=meanage[,1],ylim=c(-1,1))