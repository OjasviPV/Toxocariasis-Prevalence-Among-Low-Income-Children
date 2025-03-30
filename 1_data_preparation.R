# --------------------------------------------------------
# Data Preparation for Toxocariasis Study
# --------------------------------------------------------
# This script imports and prepares the NHANES dataset for analysis
# of Toxocariasis prevalence among children by income level
# --------------------------------------------------------

# Import the dataset
# Note: Actual path will depend on user's environment
tox_lead11.21 <- read.csv("tox_lead11.21.csv")

# Examine the structure of the dataset
str(tox_lead11.21)

# Attach the data for easier access to variables
attach(tox_lead11.21)

# Examine income distribution
table(income)
median(income)

# Create binary income variable
# Lower income: income groups 1-6 ($0 to $34,999)
# Higher income: income groups 7-11 ($35,000 to $75,000+)
lowincome <- ifelse(income > 6, 0, 1)

# Check the distribution of the binary income variable
table(lowincome)

# Cross-tabulate Toxocariasis cases by income group
table(tox, lowincome)