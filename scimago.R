setwd("~/OneDrive/Cursos/meusR/capes/")
scimago <- read.csv("scimagojr 2016.csv", header = T, sep = ";")
names(scimago)
head(scimago)
scimago[,4]
scimago[,4] <- substr(scimago[,4], 6, 23)
scimago[,4] <- substr(scimago[,4], 1, 8)
head(scimago)
head(scimago[,4], 10)
#scimago<- scimago[,1:6]
summary(scimago)
names(scimago)
dim(scimago)
plot(scimago)
plot(SJR ~ Type, scimago)
dim(scimago)
scimago[,5] <- as.numeric(scimago[,5])
SJR <- scimago[,5]
SJR <- SJR[!is.na(SJR)]
hist(SJR)
summary(SJR)
min(scimago[,5], na.rm = TRUE)
max(scimago[,5], na.rm = TRUE)
scimago[1,]
plot(SJR ~ SJR.Best.Quartile, scimago)
plot(SJR ~ Country, scimago)
plot(SJR ~ H.index, scimago)
plot(SJR ~ Categories, scimago)
plot(SJR ~ log(Total.Refs., 2), scimago)
max(scimago$Total.Refs.)
line <- which(grepl(max(scimago$Total.Refs.), scimago$Total.Refs.))
scimago[line,]

min(scimago$Total.Refs.)
line <- which(grepl(min(scimago$Total.Refs.), scimago$Total.Refs.))
zerados <- scimago[line,]
dim(zerados)
head(zerados)
library(data.table)

DT <- data.table(zerados[,-(1:2)])
DT <- data.table(DT[,-(6:12)])
DT <- data.table(DT[,-(7)])
DT
barplot(prop.table(table(DT$Country)))

