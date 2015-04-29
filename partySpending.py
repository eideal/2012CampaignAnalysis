import ROOT
import pandas as pd
import numpy as np

## Read the CSV into a pandas dataframe
data = pd.read_csv('Data/candidateSpending.csv')

## Store the first column of CSV into a pandas series
candidates = data.candidates

## Store the second column of CSV into a numpy array
money_spent = np.array(data.money_spent)
money_spent = money_spent/1000000


## Define a ROOT canvas
canvas = ROOT.TCanvas('RepvsDem Spending', 'RepvsDem Spending', 400, 10, 750, 550)

## Define ROOT histograms
h1   = ROOT.TH1F('','',5,0,5)
h2   = ROOT.TH1F('','',5,0,5)
h3   = ROOT.TH1F('','',5,0,5)
h4   = ROOT.TH1F('','',5,0,5)
h5   = ROOT.TH1F('','',5,0,5)
h6   = ROOT.TH1F('','',5,0,5)
h7   = ROOT.TH1F('','',5,0,5)
h8   = ROOT.TH1F('','',5,0,5)
h9   = ROOT.TH1F('','',5,0,5)
h10  = ROOT.TH1F('','',5,0,5)
h11  = ROOT.TH1F('','',5,0,5)
h12  = ROOT.TH1F('','',5,0,5)
h13  = ROOT.TH1F('','',5,0,5)
hDEM = ROOT.TH1F('','',5,0,5)

## Set xaxis labels
h1.GetXaxis().SetBinLabel(1, 'Democratic')
h1.GetXaxis().SetBinLabel(2, 'Republican')
h1.GetXaxis().SetBinLabel(3, 'Libertarian')
h1.GetXaxis().SetBinLabel(4, 'Green')
h1.GetXaxis().SetBinLabel(5, 'Reform')
h1.GetYaxis().SetTitle('Total Expenditures (in millions)')

## Set the bin content for REP and DEM
h1.SetBinContent  (2, money_spent[0])
h2.SetBinContent  (2, money_spent[1])
h3.SetBinContent  (5, money_spent[3])
h4.SetBinContent  (2, money_spent[4])
h5.SetBinContent  (3, money_spent[5])
h6.SetBinContent  (2, money_spent[6])
h7.SetBinContent  (2, money_spent[7])
h8.SetBinContent  (2, money_spent[8])
h9.SetBinContent  (2, money_spent[9])
h10.SetBinContent (2, money_spent[10])
h11.SetBinContent (2, money_spent[11])
h12.SetBinContent (2, money_spent[12])
h13.SetBinContent (4, money_spent[13])
hDEM.SetBinContent(1, money_spent[2])

## Define stacked histogram and set fill colors
stack = ROOT.THStack('','')
h1.SetFillColor   (ROOT.kRed)
h2.SetFillColor   (ROOT.kOrange)
h3.SetFillColor   (ROOT.kTeal)
h4.SetFillColor   (ROOT.kGreen)
h5.SetFillColor   (ROOT.kBlue)
h6.SetFillColor   (ROOT.kMagenta)
h7.SetFillColor   (ROOT.kBlack)
h8.SetFillColor   (ROOT.kCyan)
h9.SetFillColor   (ROOT.kYellow)
h10.SetFillColor  (ROOT.kGray)
h11.SetFillColor  (ROOT.kPink)
h12.SetFillColor  (ROOT.kViolet)
h13.SetFillColor  (ROOT.kSpring)
hDEM.SetFillColor (ROOT.kAzure)

## Add histograms to the stack
stack.Add(h1)
stack.Add(h2)
stack.Add(h3)
stack.Add(h4)
stack.Add(h5)
stack.Add(h6)
stack.Add(h7)
stack.Add(h8)
stack.Add(h9)
stack.Add(h10)
stack.Add(h11)
stack.Add(h12)
stack.Add(h13)
stack.Add(hDEM)
#stack.Draw("hist")

## Draw the stack and set axis titles
stack.Draw('BAR')
stack.GetStack().Last().Draw('TEXT 0 SAME')
stack.GetYaxis().SetTitle('Total Expenditures (in millions)')
stack.GetYaxis().CenterTitle()
stack.GetXaxis().SetTitle('Political Party')
stack.GetXaxis().CenterTitle()
stack.SetTitle('Candidate Spending by Party')
canvas.Update()

## Print canvas to a .png
canvas.Print('Plots/PartySpending.pdf')




