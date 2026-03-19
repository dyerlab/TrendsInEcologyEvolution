rm(list=ls())
library(tm)
library(SnowballC)

# Load in the materials and set up data.frame with just text
load("df_parts.rda")
data <- df[ , c("Files","Methods")]
rm(df)
data <- data[!is.na(data[,2]),]
x <- matrix( unlist(strsplit( data$Files, split="/", fixed=TRUE )), ncol=3, byrow = TRUE)[,2]
m <- matrix(as.numeric(unlist(strsplit( x, split=".", fixed=TRUE ))), ncol=2, byrow = TRUE)
data$Volume <- m[,1]
data$Issue <- m[,2]
rm(list=c("m","x"))
names(data)[2] <- "Text"


# pull it apart
corpus <- Corpus( DataframeSource( data.frame(data$Text )) )
corpus <- tm_map( corpus, content_transformer(removePunctuation))
corpus <- tm_map( corpus, content_transformer(tolower))
corpus <- tm_map( corpus, content_transformer(removeNumbers ))
corpus <- tm_map( corpus, content_transformer(stripWhitespace))
corpus <- tm_map( corpus, content_transformer(
  function(x) { removeWords(x, stopwords(kind="en")) } ))
corpus <- tm_map( corpus, content_transformer(
  function(x) { removeWords(x, stopwords(kind="SMART")) } ))

# Stem each document (SnowballC currently mpi-like error)
for( i in 1:length(corpus) ){
  x <- corpus[[i]]
  y <- stemDocument( x )
  corpus[[i]] <- y
}


# Turn it into a matrix and keep terms > 5%
tdm <- TermDocumentMatrix( corpus )  
m <- as.matrix( tdm )
colnames(m) <- data$Files 

save(m,file="MolEcol_Methods_tdm.rda")
