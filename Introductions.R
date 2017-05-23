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
library(ggrepel)
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

df <- data.frame( VolIss = colnames(TermMatrix), 
                  delta=NA,  
                  variance=NA )

df$Labels = NA
special_issues <- c("1003","1304","1701","1916","1917","2409","2203","2005","2103","2108","2203","2211",
                    "2306","2315","2909","2501","2508","2511","2601","2607")
for( issue in special_issues ) {
  df$Labels[ df$VolIss == issue ] <- issue
}


# Find Issue Deviance from overall mean
molEcolCentroid <- rowSums(m) / ncol(m)
for( i in 1:ncol(TermMatrix) ){
  x <- TermMatrix[,i]
  dist <- sum(sqrt( (x-molEcolCentroid)**2 ))
  df$delta[i] <- dist 
}

# Find Variation around issue
for( i in 1:ncol(TermMatrix) ) {
  
}





ggplot(df,aes(x=VolIss,y=delta)) + geom_point()  + 
  geom_text_repel( aes(label=Labels)) + 
  xlab("Time") + ylab("Deviance from Journal Centroid") +
  theme(axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
        panel.grid.minor = element_blank(),
        panel.grid.major = element_blank(),
        panel.background = element_blank(),
        axis.line = element_line(colour="grey50"))

