##################################################################################
#                       _                 _       _                              #
#                    __| |_   _  ___ _ __| | __ _| |__                           #
#                   / _` | | | |/ _ \ '__| |/ _` | '_ \                          #
#                  | (_| | |_| |  __/ |  | | (_| | |_) |                         #
#                   \__,_|\__, |\___|_|  |_|\__,_|_.__/                          #
#                         |___/                                                  #
#                                                                                #
#  Copyright 2017 Rodney J. Dyer.  All Rights Reserved.                          #
#                                                                                #
# This file may be distributed under the terms of GNU Public License version     #
# 3 (GPL v3) as defined by the Free Software Foundation (FSF). A copy of the     #
# license should have been included with this file, or the project in which      #
# this file belongs to. You may also find the details of GPL v3 at:              #
#                                                                                #
# http://www.gnu.org/licenses/gpl-3.0.txt                                        #
#                                                                                #
# If you have any questions regarding the use of this file, feel free to         #
# contact the rjdyer@vcu.edu.                                                    #
#                                                                                #
##################################################################################


rm(list=ls())
library(bibtex)
library(stringi)


years <- 2001:2016
prefix <- "molecol"

df <- data.frame( DOI=NA, 
                  Authors=NA, 
                  Title=NA, 
                  Volume=NA,
                  Issue=NA,
                  Pages=NA, 
                  Citations=NA,
                  Type=NA)

debracketify <- function( val ){
  if( is.null(val) )
    return("NA")
  val <- stri_replace_all_fixed(val,"{","")
  val <- stri_replace_all_fixed(val,"}","")
  return(val)
}

for( year in years ){
  file <- paste( "data/",prefix, year, ".bib", sep="")
  print(file)
  bib <- read.bib(file)
  K <- length(bib)
  df.1 <- data.frame( DOI=rep(NA,K), 
                      Authors=rep(NA,K), 
                      Title=rep(NA,K), 
                      Volume=rep(NA,K),
                      Issue=rep(NA,K),
                      Pages=rep(NA,K), 
                      Citations=rep(NA,K),
                      Type=NA)
  for(i in 1:K){
    b <- bib[i]
    df.1$DOI[i] <- debracketify( b$doi )
    df.1$Authors[i] <- debracketify( paste( b$author, collapse="|" ))
    df.1$Title[i] <- debracketify( b$title )
    df.1$Volume[i] <- debracketify( b$volume )
    df.1$Issue[i] <- debracketify( b$number )
    df.1$Pages[i] <- debracketify( b$pages )
    df.1$Citations[i] <- debracketify( b$`times-cited` )
    df.1$Type[i] <- debracketify(b$type)
  }
  
  df <- rbind( df, df.1)
}

df <- df[ !is.na(df$DOI),]
df$Type <- factor(df$Type)
df$Volume <- as.numeric( df$Volume )
df$Issue <- as.numeric( df$Issue )

summary(df)

