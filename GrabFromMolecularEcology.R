rm(list=ls())
library(RCurl)
library(XML)

# Example URL:
# http://onlinelibrary.wiley.com/doi/10.1111/mec.2001.10.issue-1/issuetoc

base1 <- "http://onlinelibrary.wiley.com/doi/10.1111/mec."
base2 <- ".issue-"
base3 <- "/issuetoc"

for( year in 2009:2016){
  vol <- year - 1991
  for( issue in 13:24){
    
    # find folder URL
    url <- paste( base1, year, ".", vol, base2, issue, base3, sep="")
    html <- getURL( url )
    doc <- htmlParse( html, asText=TRUE, trim=TRUE )
    refs <- xpathSApply( doc, "//a[@class='readcubePdfLink']", xmlGetAttr, 'href')
    base <- "http://onlinelibrary.wiley.com"
    for( ref in refs ){
      article <- paste( base, ref, sep="" )
      system( paste("open -g",article))
      Sys.sleep( 1+abs(rnorm(2,mean=3))) 
    }
    
    # stop some random amount of time to allow PDF's to download.
    Sys.sleep( 10+abs(rnorm(5,mean=3)))
    
    # make folder for storing downloads
    folder <- paste("~/Downloads/",vol,".",issue,sep="")
    system( paste("mkdir", folder, sep=" ") )
    
    system( paste("mv -f ~/Downloads/*.pdf", folder, sep=" "))
  }
}


# Additional Issues to redo
# 2007-2017 has issues 13-24.
# 2005 has 13 & 14,
# 2006 has 13 & 14
