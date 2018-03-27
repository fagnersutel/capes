#https://stackoverflow.com/questions/1299871/how-to-join-merge-data-frames-inner-outer-left-right
setwd("capes/")
scimago <- read.csv("scimagojr 2016.csv", header = T, sep = ";")
names(scimago)
head(scimago)
scimago[,4]
scimago[,4] <- substr(scimago[,4], 6, 23)
scimago[,4] <- substr(scimago[,4], 1, 8)
head(scimago)
head(scimago[,4], 10)
scimago<- scimago[,2:7]
scimago$Type <- NULL
scimago$SJR.Best.Quartile <- NULL
scimago$SJR <- NULL
head(scimago)
dim(scimago)
scimago <- scimago[!duplicated(scimago$Issn), ]
dim(scimago)

df1 = read.table("classificacoes_publicadas_medicina_i_2017_1496941695476.xls", header = TRUE)
head(df1)
dim(df1)
df2 = read.table("classificacoes_publicadas_medicina_ii_2017_1496941695569.xls", header = TRUE)
head(df2)
dim(df2)
df3 = read.table("classificacoes_publicadas_medicina_iii_2017_1496941695680.xls", header = TRUE)
head(df3)
dim(df3)
df4 = read.table("classificacoes_publicadas_biotecnologia_2017_1496941692806.xls", header = TRUE)
head(df4)
dim(df4)
df5 = read.table("classificacoes_publicadas_ciencias_biologicas_i_2017_1496941693320.xls", header = TRUE)
head(df5)
dim(df5)
df6 = read.table("classificacoes_publicadas_enfermagem_2017_1496941694042.xls", header = TRUE)
head(df6)
dim(df6)
df7 = read.table("classificacoes_publicadas_farmacia_2017_1496941694770.xls", header = TRUE)
head(df7)
dim(df7)
dffinal <- rbind(df1, df2, df3, df4, df5, df6, df7)
dim(dffinal)
qualis <- dffinal[!duplicated(dffinal), ]
dim(qualis)
qualis <- qualis[!duplicated(qualis$ISSN), ]
dim(qualis)
head(qualis)
#write.xlsx(qualis, "qualis.xlsx")

#install.packages('xlsx')
require(xlsx) 
options(java.parameters = "- Xmx8000m")
egressos <- read.xlsx("lattes.xls", 1, encoding="UTF-8")
egressos$DOI <- NULL
egressos$VOLUME <- NULL
egressos$PAG_INICIAL <- NULL
egressos$PAG_FINAL <- NULL
egressos$AUTORES <- NULL
dim(egressos)
head(egressos)
head(scimago)
head(qualis)


#tabelaum <- merge(egressos, qualis, by.x = "ISSN", by.y = "ISSN")
#dim(tabelaum)
#View(tabelaum)
#write.xlsx(tabelaum, "qualis_e_egressos.xlsx")

#tabeladois <- merge(tabelaum, scimago, by.x = "ISSN", by.y = "Issn")
#View(tabeladois)
#dim(tabeladois)


#final <- tabeladois[!duplicated(tabeladois), ]
#dim(final)

#write.xlsx(final, "qualis_egressos.xlsx")


#install.packages('sqldf')
names(egressos) <- c("Paper", "Journal", "ISSN", "AUTOR")
library(sqldf)
#teste1 <- sqldf("SELECT AUTOR,  ISSN, Estrato, Paper
#             FROM egressos
#             INNER  JOIN qualis USING(ISSN)")
#dim(egressos)
#dim(teste1)
#View(teste1)

teste2 <- sqldf("SELECT  *
                FROM egressos 
                LEFT JOIN qualis ON egressos.ISSN = qualis.ISSN")
dim(egressos)
dim(teste2)
names(teste2) <- c("Paper", "Journal", "ISSN", "AUTOR", "conmtrole", "Titulo", "Estrato")

#scimago <- scimago[complete.cases(scimago$Issn), ]
#teste2 <- teste2[complete.cases(teste2$conmtrole), ]

teste3 <- sqldf("SELECT  *
                FROM teste2 
                LEFT JOIN scimago ON teste2.ISSN = scimago.Issn")
dim(teste3)
teste3 <- cbind(teste3$AUTOR, teste3)
teste3[,5] <- NULL
teste3$Issn <- NULL
teste3$conmtrole <- NULL
names(teste3) <- c("AUTOR", "Paper", "Journal", "ISSN", "Titulo", "Estrato", "Title", "H.index")
write.xlsx(teste3, "qualis_egressos_JCR.xlsx")


authors <- data.frame(
    ## I(*) : use character columns of names to get sensible sort order
    surname = I(c("Tukey", "Venables", "Tierney", "Ripley", "McNeil")),
    nationality = c("US", "Australia", "US", "UK", "Australia"),
    deceased = c("yes", rep("no", 4)))
authorN <- within(authors, { name <- surname; rm(surname) })
books <- data.frame(
    name = I(c("Tukey", "Venables", "Tierney",
               "Ripley", "Ripley", "McNeil", "R Core")),
    title = c("Exploratory Data Analysis",
              "Modern Applied Statistics ...",
              "LISP-STAT",
              "Spatial Statistics", "Stochastic Simulation",
              "Interactive Data Analysis",
              "An Introduction to R"),
    other.author = c(NA, "Ripley", NA, NA, NA, NA,
                     "Venables & Smith"))

(m0 <- merge(egressos, qualis))
(m1 <- merge(egressos, qualis, by.x = "ISSN", by.y = "ISSN"))
m2 <- merge(books, authors, by.x = "name", by.y = "surname")
