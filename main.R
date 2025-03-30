# --------------------------------------------------------
# Main Analysis Script for Toxocariasis Study
# --------------------------------------------------------
# This script orchestrates the entire analysis workflow for
# the Toxocariasis prevalence study by income level
# --------------------------------------------------------

# Import the dataset
# Note: Adjust the path as needed
tox_lead11.21 <- read.csv("tox_lead11.21.csv")
attach(tox_lead11.21)

# Run all analysis scripts in sequence
cat("Running data preparation...\n")
source("1_data_preparation.R")

cat("\nRunning descriptive statistics...\n")
source("2_descriptive_statistics.R")

cat("\nRunning statistical analysis...\n")
source("3_statistical_analysis.R")

cat("\nGenerating tables and figures...\n")
source("4_tables_figures.R")

cat("\nAnalysis complete.\n")

# Detach the dataset
detach(tox_lead11.21)