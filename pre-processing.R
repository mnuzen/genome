library(plyr)

#set working directory and import datafiles
setwd("C:/Users/melba/Desktop/UCSD GENOME LAB/unedited csvs")

hour <- read.csv("3h_treatment.csv")

#extracting names
gene_uniprot <- hour$gene_uniprot
hour <- subset(hour, select = -c(1))

count <- 0

#take the average of DMSO cols
for (i in 1:ncol(hour)){
  if(substr(colnames(hour)[i], 1, 4) == "DMSO") {
    count <- i
  } else {
    break
  }
}

DMSO_avg <- rowMeans(hour[1:count], na.rm = TRUE, dims = 1)

#removes DMSO info from original dataframe
hour <- subset(hour, select = -c(1:count))

#create new dataframe that contains unique names & one col of DMSO avg
end <- data.frame(gene_uniprot = gene_uniprot,
                  DMSO_avg = DMSO_avg)

#runs while there is still data in the original dataframe
while(!empty(hour)) {
  
  drugname <- substr(colnames(hour)[1], 1, 5)
  drug_sum <- 0
  count <- 0
  
  #find col index of last same drug
  for (i in 1:ncol(hour)){
    if(drugname == substr(colnames(hour)[i], 1, 5)) {
      count <- i
    } else if ( drugname != substr(colnames(hour)[i], 1, 5) ) {
      break
    }
  }
  
  drug_avg <- rowMeans(hour[1:count], na.rm = TRUE, dims = 1)
  
  #subtract DMSO_avg to find full change
  full_change <- drug_avg - DMSO_avg
  
  #add full_change into end dataframe
  name <- paste(colnames(hour)[1],"fc",sep="_")
  end[name] <- full_change
  
  #remove the used columns
  hour <- subset(hour, select = -c(1:count))
}

write.csv(end, file = "test", row.names = TRUE)
