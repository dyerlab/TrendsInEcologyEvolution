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
library(ggplot2)
load("MolEcolIntroTDM.rda")
load("MolEcolIntroSummary.rda")


# summarize by issue.
data$VolIss <- data$Volume*100 + data$Issue 


# Make an issue coordinate matrix
TermMatrix <- matrix(0, nrow=nrow(m), ncol=length(unique(data$VolIss)))
colnames(TermMatrix) <- unique( data$VolIss )
rownames(TermMatrix) <- rownames(m)

for( col in colnames(TermMatrix) ) {
  files <- data$Files[ data$VolIss == col ]
  x <- rowSums( m[, colnames(m) %in% files] ) / length(files)
  TermMatrix[, colnames(TermMatrix)==col] <- x
}

df <- data.frame( VolIss = data$VolIss, delta=NA )
for( i in 2:ncol(TermMatrix) ){
  x1 <- TermMatrix[,(i-1)]
  x2 <- TermMatrix[,i]
  dist <- sum(sqrt( (x1-x2)**2 ))
  df$delta[i] <- dist 
}
