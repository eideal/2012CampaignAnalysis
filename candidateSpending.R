## Analyze FEC 2012 presidential campaign data
## from https://modeanalytics.com/editor/reports/e158bc36e711/runs/a0b486b7d8ac

## Read the data
data <- read.csv('fec_2012_presidential_campaign_expenditures.csv', colClasses = 'character')

cand_spending <- function(candidate){
        
        ## Compute total spending for candidate
        candidate_data <- data[data[, 3] == candidate,]
        spending <- 0
        for (row in 1:nrow(candidate_data)){
                spending <- spending + as.numeric(candidate_data[row, 5])
        }
        spending
}

all_spending <- function(){
        candidates <- unique(data[, 3])
        money_spent <- vector("numeric")
        for (cand in candidates){
                money <- cand_spending(cand)
                money_spent <- c(money_spent, money)
        }
        cbind.data.frame(candidates, money_spent)
}


## Bar Plots ##

## Compute everyone's spending
df <- all_spending()
candidates <- df[, 1]
money <- df[, 2]

## Plot money spent in millions
money <- money / 1000000
money_order <- order(-money)

## Order the candidates & money spent from highest -> lowest
cands_ordered <- vector("character")
money_ordered <- vector("numeric")
for (i in money_order){
        cands_ordered <- c(cands_ordered, as.character(candidates[i]))
        money_ordered <- c(money_ordered, as.numeric(money[i]))
}

## Plotting details
ylim <- c(0, 1.1*max(money_ordered))
opt <- options("scipen" = 20) ## Remove scientific notation (fixed notation unless # is more than ‘scipen’ digits wider)

## Make bar plot and save as PDF
x11()
par(mar=c(11,5,4,2)) ## (bottom, left, top, right)
xx <- barplot(money_ordered, main="Candidate Total Expenditures", ylab="Total Expenditures (in millions)", ylim = ylim, names.arg=cands_ordered, col="darkgreen", las=3, cex.names = 0.8, space = 2)
text(x = xx, y = money_ordered, label = round(money_ordered, 1), col = "red", pos=3, xpd=NA) ## Add labels on top of bars
options(opt)
dev.copy2pdf(file = "total_expenditures.pdf")

## Trying to make stacked bar (REP) with unstacked bar (DEM) ...
money_GOP <- money_ordered[2:14]
money_DEM <- money_ordered[1]
cands_GOP <- cands_ordered[2:14]
money_DEM <- c(money_DEM, rep(0,12))
qplot(x = factor(1), y = money_GOP, xlab="REP", ylab="Expenditures (in millions)", geom = "bar", fill = cands_GOP, stat="identity")
ggsave(file="RepvsDem.pdf")
dev.off()

## Write data frame to a CSV to be analyzed with pyROOT
write.csv(file="candidateSpending.csv", x=df)




