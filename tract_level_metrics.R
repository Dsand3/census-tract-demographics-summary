# -----------------------------------------------------------------------------
# tract_level_metrics.R
#
# Purpose:
#   Generate tract-level derived metrics (e.g., POC%) from tract demographic data.
#
# What this script does:
#   1) Deduplicates tract rows using key ID + indicator columns
#   2) Ensures key fields are numeric
#   3) Calculates tract-level percentages (e.g., POC / Total.Pop * 100)
#   4) Computes overall POC% across all tracts (weighted by population)
#   5) Prints quick summary statistics for key tract-level fields
#
# Inputs expected in the data:
#   - Full.Tract.ID
#   - Total.Pop
#   - Race.POC
#   (Optional for later expansion: Poverty_Under200, Age.65.Plus, etc.)
# -----------------------------------------------------------------------------

library(dplyr)

# ---- Helper (same as in overall_summary_statistics.R) ------------------------
to_numeric_clean <- function(x) {
  x <- gsub("[^0-9.-]", "", x)
  as.numeric(x)
}

# NOTE:
# This script expects `census_data_raw` (or `census_data_clean`) to already exist.
# If running standalone, uncomment and set the filename:
# census_data_raw <- read.csv("Demographics by Tract.csv", stringsAsFactors = FALSE, check.names = FALSE)

# -----------------------------------------------------------------------------
# Step 1: Build a tract-level table for POC analysis
# -----------------------------------------------------------------------------
poc_tract_group <- census_data_raw %>%
  distinct(Full.Tract.ID, Total.Pop, Race.POC)

# Clean numeric fields (if not already cleaned upstream)
poc_tract_group <- poc_tract_group %>%
  mutate(
    Total.Pop = to_numeric_clean(Total.Pop),
    Race.POC  = to_numeric_clean(Race.POC)
  )

# -----------------------------------------------------------------------------
# Step 2: Calculate tract-level POC percent
# -----------------------------------------------------------------------------
poc_tract_group <- poc_tract_group %>%
  mutate(
    Race.POC.Percent = ifelse(Total.Pop > 0, (Race.POC / Total.Pop) * 100, NA_real_)
  )

# -----------------------------------------------------------------------------
# Step 3: Compute weighted overall POC% across dataset
# -----------------------------------------------------------------------------
poc_pop_sum <- sum(poc_tract_group$Race.POC, na.rm = TRUE)
tot_pop_sum <- sum(poc_tract_group$Total.Pop, na.rm = TRUE)

total_poc_pop_percent <- (poc_pop_sum / tot_pop_sum) * 100

cat("Overall POC Percentage (weighted by population): ",
    round(total_poc_pop_percent, 2), "%\n", sep = "")

# -----------------------------------------------------------------------------
# Step 4: Quick summary stats for tract-level fields
# -----------------------------------------------------------------------------
summary_poc_stats <- summary(poc_tract_group[, c("Total.Pop", "Race.POC", "Race.POC.Percent")])
print(summary_poc_stats)

# -----------------------------------------------------------------------------
# Optional: scaffold for other tract-level groupings
# (These are placeholders until you add cleaning + metrics like above)
# -----------------------------------------------------------------------------

# Low income (example: Poverty_Under200) - deduplicate to tract level
low_income_group <- census_data_raw %>%
  distinct(Full.Tract.ID, Total.Pop, Poverty_Under200)

# Limited English
limited_english_group <- census_data_raw %>%
  distinct(Full.Tract.ID, Total.Pop, Language.Speak.English.Not.Well)

# Under 5 years old
age_under5_group <- census_data_raw %>%
  distinct(Full.Tract.ID, Total.Pop, Age.Under.5)

# Age 65+
age_over65_group <- census_data_raw %>%
  distinct(Full.Tract.ID, Total.Pop, Age.65.Plus)

# NOTE:
# If you want, we can extend this file to compute:
# - poverty percent per tract
# - limited English percent per tract
# - under 5 percent per tract
# - over 65 percent per tract
# using the same pattern as POC.Percent.
