# This script goes through all the subdirectories indicated and 
#   pulls out the introduction, title, authors, and doi

rm(list=ls())
library(stringi)
library( readr )

folder <- "MolecularEcology"

files <- list.files(path=folder, pattern="*.txt", 
                    recursive = TRUE, full.names = TRUE)


files <- files

df <- data.frame( Files=files,
                  Abstract=NA,
                  Introduction=NA,
                  Methods=NA,
                  Discussion=NA )


# set up the patterns
abstract_breaks <- "abstract"
introduction_breaks <- "introduction"
method_breaks <- c("materials and methods", "methods", "the model")
results_breaks <- "results"
discussion_breaks <- "discussion"
acknowledgement_breaks <- "acknowledgements"


findIn <- function( lines, patterns) {
  
  for( pattern in patterns ){
    
    # whole line 
    idx <- which( lines == pattern )
    if( length(idx)> 1)
      return(min(idx))
    
    # partial begins with
    x <- startsWith(lines,pattern) 
    if( any( x ))
      return( min(which( x ) ))
    
    # partial ends with
    x <- endsWith(lines,pattern)
    if( any( x ) ) 
      return( min(which(x)))
  }

  return(NA)
}



for( file in files ) {
  text <- read_file( file )
  text <- stri_replace_all_fixed(text,"\n","\r")
  text <- stri_replace_all_fixed(text,"\r", "linebreakmarkerhere")
  text <- gsub("[^[:alnum:]///' ]", "",text)
  text <- tolower( text )
  
  # clean up the lines
  lines <- strsplit(text, split="linebreakmarkerhere", fixed=TRUE )[[1]]
  lines <- lines[ nchar(lines) >0  ]
  lines <- trimws( lines )
  lines <- lines[ !is.na(lines) ]
  
  # abstract
  ab_idx <- findIn( lines, abstract_breaks )
  in_idx <- findIn( lines, introduction_breaks )
  me_idx <- findIn( lines, method_breaks )
  re_idx <- findIn( lines, results_breaks )
  di_idx <- findIn( lines, discussion_breaks )
  ac_idx <- findIn( lines, acknowledgement_breaks )
  
  cat(file)
  
  if( !is.na(ab_idx )  && !is.na(in_idx) ) {
    cat(" abstract")
    df$Abstract[df$Files == file] <- paste( lines[(1+ab_idx):(in_idx-1)], collapse = " ")
  }
  
  if( !is.na(in_idx) && !is.na(me_idx ) ) {
    cat(" introduction")
    df$Introduction[df$Files == file] <- paste( lines[ (in_idx+1):(me_idx-1)],collapse = " " )
  }
  
  if( !is.na(me_idx) && !is.na(re_idx) ){
    cat(" methods")
    df$Methods[ df$Files == file ] <- paste( lines[ (me_idx+1):(re_idx-1)],collapse = " " )
  }
  
  if( !is.na(di_idx) && !is.na(ac_idx) ){
    cat(" discussion")
    df$Discussion[df$Files == file] <- paste( lines[ (di_idx+1):(ac_idx-1)],collapse = " " )
  }
  
  cat("\n")
}


save(df,file="df_parts.rda")

