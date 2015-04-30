## Analyze FEC 2012 presidential campaign data
## from https://modeanalytics.com/editor/reports/e158bc36e711/runs/a0b486b7d8ac

## Load the ggplot2 library
library(ggplot2)

## Read the data
data <- read.csv('Data/fec_2012_presidential_campaign_expenditures.csv', colClasses = 'character')
candidates <- unique(data[,3])

## Function to compute most common disbursement types and the total $ spent on each for a given candidate
cand_disbursement <- function(candidate){
        
        ## Subset the candidate data
        candidate_data <- data[data[, 3] == candidate,]
        
        ## Find the 10 most common disbursement types for the candidate
        disburse_data <- candidate_data[,10]
        common_disburse <- as.data.frame(sort(table(disburse_data), decreasing=TRUE)[1:10])
        common_disburse_types <- vector('character')
        for (i in 1:length(dimnames(common_disburse)[[1]])){
                common_disburse_types <- c(common_disburse_types, dimnames(common_disburse)[[1]][i])
        }
        
        ## Sum the expenditures for each common disburse type
        total_expenditures <- rep(0, length(common_disburse_types))
        for (row in 1:nrow(candidate_data)){
                if (candidate_data[row, 10] %in% common_disburse_types){
                        num <- which(common_disburse_types %in% candidate_data[row,10])
                        total_expenditures[num] <- total_expenditures[num] + as.numeric(candidate_data[row, 5])
                }
        }
        return_list <- list('money' = total_expenditures, 'types' = common_disburse_types)
}

## Make a barplot for the candidate showing the most common disbursement types in order of their expenditures
make_barplot <- function(candidate){
        
        return_list <- cand_disbursement(candidate)
        
        total_expenditures <- return_list$money
        total_expenditures <- total_expenditures/1000000
        common_types <- return_list$types
        ordering <- order(total_expenditures, common_types, decreasing = TRUE)
        expenditures <- vector('numeric')
        disbursement_type <- vector('character')
        for (i in ordering){
                expenditures <- c(expenditures, total_expenditures[i])
                disbursement_type <- c(disbursement_type, common_types[i])
        }
        qplot(x = factor(1), y = expenditures,main = paste('Most Common Disbursements', ":", candidate), ylim = c(0, 1.05*sum(expenditures)), xlab = '', ylab = 'Expenditures (in millions)', geom = 'bar', fill = disbursement_type, stat='identity') + theme(axis.ticks.x = element_blank(), axis.text.x = element_blank())#+ theme(panel.background = element_blank())
        ggsave(file=paste('Plots/','Common Disbursements', "_", candidate, '.pdf', sep=''), width = 9, height = 8)
        
}

## Make barplots for each candidate
for (cand in candidates){
        make_barplot(cand)
}

