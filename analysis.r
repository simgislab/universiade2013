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

top10ussr = subset(d,d$CNTRY %in% c('RUS','USA','CHN','GER','GBR','FRA','JPN','KOR','CAN','AZE','LTU','LAT','EST','BLR','UKR','KAZ','TKM','UZB','TJK'))
top10ussr = data.frame(CNTRY=top10ussr$CNTRY,YEAR=as.numeric(as.character(top10ussr$DOB_YEAR)))
top10ussr = na.omit(top10ussr)

cntry_over20_list = names(subset(table(dy$CNTRY),table(dy$CNTRY) >20))
over20 = subset(d,d$CNTRY %in% cntry_over20_list)
over20 = data.frame(CNTRY=over20$CNTRY,YEAR=as.numeric(as.character(over20$DOB_YEAR)))
over20 = na.omit(over20)


meanyear = aggregate(top10$YEAR, by=list(top10$CNTRY), FUN=mean)
barplot(meanyear[,2] - mean(meanyear[,2]),xlab = "������", ylab = "���������� �� ��������, ���",names.arg=meanyear[,1],ylim=c(-1,1))

medianyear = aggregate(top10$YEAR, by=list(top10$CNTRY), FUN=median)
barplot(medianyear[,2] - median(medianyear[,2]),xlab = "������", ylab = "���������� ������� �� ����� �������, ���",names.arg=medianyear[,1],ylim=c(-2,2))

medianyear_top10ussr = aggregate(top10ussr$YEAR, by=list(top10ussr$CNTRY), FUN=median)
barplot(medianyear_top10ussr[,2] - median(medianyear_top10ussr[,2]),xlab = "������", ylab = "���������� ������� �� ����� �������, ���",names.arg=medianyear_top10ussr[,1],ylim=c(-2,2))

modeyear = aggregate(top10$YEAR, by=list(top10$CNTRY), FUN=Mode)
barplot(modeyear[,2] - mean(modeyear[,2]),xlab = "������", ylab = "���������� ���� �� ����� ����, ���",names.arg=modeyear[,1],ylim=c(-2,2))

meanage = aggregate(2013-over20$YEAR, by=list(over20$CNTRY), FUN=mean)
meanage = meanage[!meanage$Group.1 == "UAE", ]
meanage = meanage[!meanage$Group.1 == "OMA", ]
barplot(meanage[,2] - mean(meanage[,2]),xlab = "������", ylab = "���������� �� �������� ��������, ���",names.arg=meanage[,1],ylim=c(-3,3))


meanage_top10ussr = aggregate(2013-top10ussr$YEAR, by=list(top10ussr$CNTRY), FUN=mean)
barplot(meanage_top10ussr[,2] - mean(meanage[,2]),xlab = "������", ylab = "���������� �� �������� ��������, ���",names.arg=meanage_top10ussr[,1],ylim=c(-1,1))

mfile = "d:\\Programming\\Python\\universiade2013\\data\\medals_total.csv"
m = read.csv(mfile)

cntr_medals_all = merge(meanyear_all,m,by.x="Group.1",by.y="CNTRY")
plot(2013-cntr_medals_all$x,cntr_medals_all$TOTAL,pch=19,xlab = "������� �������", ylab = "����� ���������� �������")