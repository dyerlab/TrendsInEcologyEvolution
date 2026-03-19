# This script goes through all the subdirectories indicated and 
#   converts the raw PDF objects into text objects.

rm(list=ls())
library(stringi)

folder <- "MolecularEcology"

files <- list.files(path=folder, pattern="*.pdf", 
                    recursive = TRUE, full.names = TRUE)


for( file in files ) {
  ofile <- strsplit(file,split=".",fixed=TRUE)[[1]]
  ofile[ length(ofile) ] <- "txt"
  ofile <- paste( ofile, collapse=".")
  
  # 
  if( !file.exists(ofile) ) {
    print( paste("Parsing:", file))
    cmd <- paste("./parsePDF", file, ">", ofile)
    system(cmd)
  }
  else {
    print( paste("Skipping: ", file))
  }
  
}
