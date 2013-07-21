# Maxim Dubinin, sim@gis-lab.info
# Created: 0:38 16.07.2013
# Modified: 22:06 21.07.2013
# merge all csv-files into one

inputdir = "d:\\Programming\\Python\\universiade\\countries\\"
outputfile = "d:\\Programming\\Python\\universiade\\all_data.csv"

csvs = list.files(path=inputdir, pattern="csv")

cnames = names(read.csv(paste(inputdir,"RUS.csv",sep=""),sep=",",header=T,strip.white=T))

#c("NAME","LINK","NAMERU","GENDER","SPORTS","SPORTSLINK","CNTRY","CNTRYLINK","LASTNAME","FIRSTNAME","DOB","DOB_DAY","DOB_MNTH","DOB_YEAR","HEIGHT","WEIGHT","UNINAME","UNICITY","TEAM")

d = data.frame()
for (i in 1:length(csvs)) {
	csv = paste(inputdir,csvs[i],sep="")
	add = read.csv(csv,sep=",",strip.white=T)
	d = rbind(d,add)
    print(csv)
}

write.csv(d,file=outputfile,row.names=F)

