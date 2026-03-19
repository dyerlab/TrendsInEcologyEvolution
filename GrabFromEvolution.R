rm( list=ls() )
library( RCurl )
library( XML )

urls <- c("http://onlinelibrary.wiley.com/doi/10.1111/evo.2013.67.issue-1/issuetoc",
          "http://onlinelibrary.wiley.com/doi/10.1111/evo.2013.67.issue-2/issuetoc",
          "http://onlinelibrary.wiley.com/doi/10.1111/evo.2013.67.issue-3/issuetoc",
          "http://onlinelibrary.wiley.com/doi/10.1111/evo.2013.67.issue-4/issuetoc",
          "http://onlinelibrary.wiley.com/doi/10.1111/evo.2013.67.issue-5/issuetoc",
          "http://onlinelibrary.wiley.com/doi/10.1111/evo.2013.67.issue-6/issuetoc",
          "http://onlinelibrary.wiley.com/doi/10.1111/evo.2013.67.issue-7/issuetoc",
          "http://onlinelibrary.wiley.com/doi/10.1111/evo.2013.67.issue-8/issuetoc",
          "http://onlinelibrary.wiley.com/doi/10.1111/evo.2013.67.issue-9/issuetoc",
          "http://onlinelibrary.wiley.com/doi/10.1111/evo.2013.67.issue-10/issuetoc",
          "http://onlinelibrary.wiley.com/doi/10.1111/evo.2013.67.issue-11/issuetoc",
          "http://onlinelibrary.wiley.com/doi/10.1111/evo.2013.67.issue-12/issuetoc")





for( url in urls ) {
  html <- getURL( url )
  doc <- htmlParse( html, asText=TRUE, trim=TRUE )
  refs <- xpathSApply( doc, "//a[@class='readcubePdfLink']", xmlGetAttr, 'href')
  base <- "http://onlinelibrary.wiley.com"
  for( ref in refs ){
    article <- paste( base, ref, sep="" )
    system( paste("open -g",article))
    Sys.sleep( 1+abs(rnorm(2,mean=3))) # so it doesn't look like I'm just pulling everything
  }
  
  Sys.sleep( 10+abs(rnorm(5,mean=3))) # so it doesn't look like I'm just pulling everything
  folder_raw <- strsplit(url,"/",fixed=TRUE)[[1]][6]
  folder_parts <- strsplit(folder_raw,".",fixed=T)[[1]]
  issue_num <- strsplit( folder_parts[4], "-", fixed=TRUE)[[1]][2]
  newFolder <- paste(folder_parts[3],issue_num,sep=".")
  folder_path <- paste("~/Downloads/",newFolder,"/",sep="")
  system( paste("mkdir", folder_path, sep=" ") )
  mvCmd <- paste("mv ~/Downloads/*.pdf ", folder_path, sep="") 
  system( mvCmd )
  
}




