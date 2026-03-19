# This function goes through the files and pulls the introductions out
#   and stems those sections.

rm(list=ls())

library(tm)
library(SnowballC)
library(wordcloud)

folder <- "Evolution"
files <- list.files(path=folder, pattern="*.txt", 
                    recursive = TRUE, full.names = TRUE)

for( file in files[1:10] ) {
  suppressWarnings( txt <- readLines(file) )
  
  # pull out the after abstract to beginning of repeat
  idx <- which( regexpr("Abstract.",txt) != -1)
  if( length(idx) == 2 )
    txt <- txt[ (idx[1]+2):(idx[2]-5) ]
  else if( length(idx)==1)
    txt <- txt[ (idx[1]+2):length(txt)]
  else
    warning(paste("No abstract in",file))

  boundaries <- c("METHODS","MODEL", "Study System")
  regexpr(boundaries, txt)
  
  
  # find if there is an introduction
  idx <- which( regexpr("METHODS",txt) != -1)
  if( length(idx)==0 ){
    idx <- which( regexpr("MODEL",txt) != -1)
    if( length(idx) ) {
      print(file)
      print(txt[idx[1]])
    }
  }

  
  # txt <- paste(txt,collapse = "NEWLINE")
  # 
  # corpus <- Corpus( DataframeSource( data.frame(txt)))
  # corpus <- tm_map( corpus, content_transformer(removePunctuation))
  # corpus <- tm_map( corpus, content_transformer(removeNumbers ))
  # corpus <- tm_map( corpus, content_transformer(stripWhitespace))
  # txt <- strsplit(corpus[[1]]$content, split="NEWLINE")[[1]]
  # 
  # idx <- which( txt == toupper(txt) )
  # 
  # corpus <- tm_map( corpus, content_transformer(tolower))

}
