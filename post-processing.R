library(plyr)

#set working directory and import datafiles from 3, 6, 24
setwd("C:/Users/melba/Desktop/UCSD GENOME LAB/edited csvs - Copy/3hr cybert/")
threeHourFileNames <- Sys.glob("*.txt")

for(file3 in threeHourFileNames){
  #read original 3hour file
  drug3 <- read.table(file3, header=TRUE, sep="\t")
  
  #extract drug name
  underInd <- regexpr("_", file3, fixed=T)[1] 
  perInd <- regexpr(".txt", file3, fixed=T)[1]
  drugName3 <- substr(basename(file3),underInd+1,perInd-1)
  
  #create new 3hour dataframe
  df3 <- data.frame(hour3gene=character(0),hour3pVal=character(0))
  
  #find & extract all pVals + respective gene name if <= .05
  #insert into 3hour dataframe
  for(i in 1:length(drug3$pVal)){
    if ((drug3$pVal[i]) <= .05){
      insert <- data.frame(hour3gene=c(toString(drug3$Lab_2[i])), hour3pVal=c(drug3$pVal[i]))
      df3 <- rbind.data.frame(df3, insert)
    }
  }
    
  setwd("C:/Users/melba/Desktop/UCSD GENOME LAB/edited csvs - Copy/6hr cybert/")
  sixHourFileNames <- Sys.glob("*.txt")
  
  for(file6 in sixHourFileNames){
    #extract drug name
    underInd <- regexpr("_", file6, fixed=T)[1] 
    perInd <- regexpr(".", file6, fixed=T)[1]
    drugName6 <- substr(basename(file6),underInd+1,perInd-1)
    
    #if file6 matches file3
    if(drugName6 == drugName3){
      #read 6hour file
      drug6 <- read.table(file6, header=TRUE, sep="\t")
      
      #create new 6hour dataframe
      df6 <- data.frame(hour6gene=character(0),hour6pVal=character(0))
      
      #find & extract all pVals + respective gene name if <= .05
      #insert into 6hour dataframe
      for(i in 1:length(drug6$pVal)){
        if ((drug6$pVal[i]) <= .05){
          insert <- data.frame(hour6gene=c(toString(drug6$Lab_2[i])), hour6pVal=c(drug6$pVal[i]))
          df6 <- rbind.data.frame(df6, insert)
        }
      }
      df3 <- rbind.fill(df3,df6)
    }
  }
  
  setwd("C:/Users/melba/Desktop/UCSD GENOME LAB/edited csvs - Copy/24hr cybert/")
  twentyFourHourFileNames <- Sys.glob("*.txt")
  
    for(file24 in twentyFourHourFileNames){
      #extract drug name
      underInd <- regexpr("_", file24, fixed=T)[1] 
      perInd <- regexpr(".", file24, fixed=T)[1]
      drugName24 <- substr(basename(file24),underInd+1,perInd-1)
      
      #if file24 matches file3
      if(drugName24 == drugName3){
        #read 24hour file
        drug24 <- read.table(file24, header=TRUE, sep="\t")
        
        #create new 24hour dataframe
        df24 <- data.frame(hour24gene=character(0),hour24pVal=character(0))
        
        #find & extract all pVals + respective gene name if <= .05
        #insert into 24hour dataframe
        for(i in 1:length(drug24$pVal)){
          if ((drug24$pVal[i]) <= .05){
            insert <- data.frame(hour24gene=c(toString(drug24$Lab_2[i])), hour24pVal=c(drug24$pVal[i]))
            df24 <- rbind.data.frame(df24, insert)
          }
        }
        df3 <- rbind.fill(df3,df24)
        write.csv(df3, file = drugName3, row.names = TRUE)
      }
    }
}
    
