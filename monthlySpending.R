## Analyze FEC 2012 presidential campaign data
## from https://modeanalytics.com/editor/reports/e158bc36e711/runs/a0b486b7d8ac

## Read the data
data <- read.csv('Data/fec_2012_presidential_campaign_expenditures.csv', colClasses = 'character')
candidates <- unique(data[,3])

#-----------------------------------------------------------------------
## Function returning a data frame: month, year, disbursement amount for a given candidate

split_months <- function(candidate){
        
        ## Subset candidate data
        candidate_data <- data[data[,3] == candidate,]
        
        ## Strip time stamp, leaving year-month-day
        date_data <- gsub('T00:00:00','',candidate_data[, 6])

        ## Split the date_data to extract month & year
        split_date <- strsplit(date_data, '-')
        
        ## Store the year and month in vectors
        year <- vector('character')
        month <- vector('character')
        for (i in 1:length(split_date)){
                year <- c(year, split_date[[i]][1])
                month <- c(month, split_date[[i]][2])
        }

        disburse_amount <- as.numeric(candidate_data[, 5])
        
        ## Return a data frame containing columns for the month, year, and disbursement amount
        df <- cbind.data.frame(month, year, disburse_amount)
}

#-----------------------------------------------------------------------
## Function for computing the spending for each month for a given candidate
## Outputs a data frame with "month/year" and amount spent in that "month/year"

monthly_spending <- function(candidate){
        
        ## Order the data frame by month, year
        df <- split_months(candidate)
        df <- df[order(df$year, df$month),]
        
        ## Get unique (year, month)
        unique_dates <- unique(df[c("year", "month")])
        
        monthly_spending <- rep(0, nrow(unique_dates))
        
        for (row in 1:nrow(df)){
                month <- as.character(df[row, 1])
                year <- as.character(df[row, 2])
                w <- which(as.character(unique_dates$month) == as.character(month) & as.character(unique_dates$year) == as.character(year))
                
                monthly_spending[w] <- monthly_spending[w] + as.numeric(df[row, 3])    
        }
        
        if (candidate == 'Romney, Mitt' || candidate == 'Huntsman, Jon'){
                monthly_spending <- monthly_spending[-1]
                unique_dates <- unique_dates[-1]
        }

        dates <- vector("character")
        for (date in 1:nrow(unique_dates)){
                x <- paste(unique_dates[date, 2], '/' , unique_dates[date, 1], sep='')
                dates <- c(dates, x)
        }

        cbind.data.frame(dates, monthly_spending)
}

#-----------------------------------------------------------------------
## Function to make the monthly spending barplot for a given candidate

make_barplot <- function(candidate){
        df <- monthly_spending(candidate)
        spending <- df$monthly_spending / 1000000
        ylim <- c(0, 1.1*max(spending))
        opt <- options("scipen" = 20)
        par(mar=c(7,8,4,2)) ## (bottom, left, top, right)
        xx <- barplot(spending, names.arg=df$dates, main=paste('Spending by Month', ':', candidate), ylim = ylim, ylab='Total Expenditures (in millions)', col="darkblue", las=3, cex.names = 0.7, space = 2)
        text(x = xx, y = spending, label = round(spending, 1), col = "red", pos=3, cex = 0.6, xpd=NA) ## Add labels on top of bars
        options(opt)
        dev.copy2pdf(file = paste('Plots/','Monthly Spending', "_", candidate, '.pdf', sep=''), width=8, height=10)
        dev.off()
        
}

#-----------------------------------------------------------------------
make_barplot('Obama, Barack')
#make_barplot('Romney, Mitt')
make_barplot('Santorum, Rick')
make_barplot('Pawlenty, Timothy')
make_barplot('Huntsman, Jon')
make_barplot('Gingrich, Newt')

## Generate plots for each candidate
#for (cand in candidates){
#        make_barplot(cand)
#}
