## Analyze FEC 2012 presidential campaign data
## from https://modeanalytics.com/editor/reports/e158bc36e711/runs/a0b486b7d8ac

## Read the data
data <- read.csv('Data/fec_2012_presidential_campaign_expenditures.csv', colClasses = 'character')
candidates <- unique(data[,3])

#-----------------------------------------------------------------------
## Function for plotting a candidate's daily expenditures

daily_spending <- function(candidate){
        ## Subset candidate data
        candidate_data <- data[data[,3] == candidate,]
        
        ## Strip time stamp, leaving year-month-day
        date_data <- gsub('T00:00:00','', candidate_data[,6])
        
        ## Order the dates from earlier->later
        ordering  <- order(date_data)
        date_data <- date_data[ordering]
        
        ## Obtain disbursement amounts and order them by date
        disburse_amounts <- as.numeric(candidate_data[, 5])
        disburse_amounts <- disburse_amounts[ordering]
        
        ## Define vector to store daily expenditures
        daily_money  <- vector("numeric")
        unique_dates <- vector("character")
        
        ## Add together disbursement amounts on the same day
        amount <- 0
        for (i in 1:length(date_data)){
                ## exception in Romney's and Huntsman's datasets
                if (grepl('1999', date_data[i])){
                        next()
                }
                ## exception in Ron Paul's dataset
                if (grepl('2001', date_data[i]) || grepl('2002', date_data[i]) || grepl('2014', date_data[i])|| grepl('2021', date_data[i])){
                        next()
                }
                if (disburse_amounts[i] < 0){
                        next()
                }
                ## if statement deals with last vector element
                if (is.na(date_data[i+1]) == FALSE){
                        if (date_data[i] == date_data[i+1]){
                                amount <- amount + disburse_amounts[i]          
                        }
                        else {
                                amount <- amount + disburse_amounts[i]
                                unique_dates <- c(unique_dates, date_data[i])
                                daily_money  <- c(daily_money, amount)
                                amount <- 0
                        }
                }
                else {
                        amount <- amount + disburse_amounts[i]  
                        unique_dates <- c(unique_dates, date_data[i])
                        daily_money <- c(daily_money, amount)
                }
        }
        
        ## Convert the unique dates to Date format
        unique_dates <- as.Date(unique_dates)
        daily_money <- daily_money / 1000
        
        return_list <- list('dates' = unique_dates, 'money' = daily_money)
        
}
#-----------------------------------------------------------------------
## Function to make the daily spending plot for a given candidate
make_plot <- function(candidate){
        
        return_list <- daily_spending(candidate)
        unique_dates <- return_list$dates
        daily_money <- return_list$money
        
        ## Select the minimum dates in each year-month (i.e. the first day in each month)
        locs <- tapply(X=unique_dates, FUN=min, INDEX=format(unique_dates, '%Y%m'))
        
        ## Select the minimum dates in only even-numbered months
        at <- unique_dates %in% locs
        at <- at & format(unique_dates, '%m') %in% c('02','04','06','08','10','12')       
        
        ## Plot the daily expenditures, label x-axis with month-year indicated by the first day in each even-numbered month
        par(mar=c(8,6,4,2)) ## (bottom, left, top, right)
        plot(x=as.Date(unique_dates), y=daily_money, type='b', ylim=c(0,1.1*max(daily_money)), col='darkblue', main=paste('Spending by Day', ':', candidate), las=3, xaxt='n', xlab='', ylab='Expenditures (in thousands of $)')
        axis(side=1, at=unique_dates[at], labels=format(unique_dates[at], '%b-%y'), las=3)
        abline(v=unique_dates[at], col='grey', lwd=0.5)
        
        ## Save to PDF
        dev.copy2pdf(file = paste('Plots/','Daily Spending', "_", candidate, '.pdf', sep=''), width=8, height=10)
        dev.off() 
}

#-----------------------------------------------------------------------
make_plot('Obama, Barack')
make_plot('Romney, Mitt')
make_plot('Gingrich, Newt')
make_plot('Huntsman, Jon')
make_plot('Pawlenty, Timothy')
make_plot('Santorum, Rick')

## Make plots for all candidates
#for (cand in candidates){
#        daily_spending(cand)
#}