# -----------------------------------------------------------------------------
# overall_summary_statistics.R
#
# Purpose:
#   Read tract-level demographic data, clean key numeric indicator fields,
#   compute overall summary statistics (totals/means/percentages), and export
#   a reporting-ready CSV.
#
# What this script outputs:
#   - overall_summary_all_metrics.csv (one table: Metric, Value)
#
# Notes:
#   Many demographic exports store numbers with commas, percent signs, etc.
#   This script strips non-numeric characters before converting to numeric.
# -----------------------------------------------------------------------------

# ---- Step 1: Read raw data --------------------------------------------------
input_file <- "Demographics by Tract.csv"  # keep generic for GitHub
census_data_raw <- read.csv(
  input_file,
  sep = ",",
  header = TRUE,
  stringsAsFactors = FALSE,
  check.names = FALSE
)

# ---- Helper: clean numeric strings ------------------------------------------
to_numeric_clean <- function(x) {
  x <- gsub("[^0-9.-]", "", x)  # keep digits, decimals, minus sign
  as.numeric(x)
}

# ---- Step 2: Clean columns used in summaries --------------------------------
# Denominator
census_data_raw$Total.Pop <- to_numeric_clean(census_data_raw$Total.Pop)

# Numerators / indicators
census_data_raw$Race.POC <- to_numeric_clean(census_data_raw$Race.POC)
census_data_raw$Language.Speak.English.Not.Well <- to_numeric_clean(
  census_data_raw$Language.Speak.English.Not.Well
)
census_data_raw$Age.Under.5 <- to_numeric_clean(census_data_raw$Age.Under.5)
census_data_raw$Age.65.Plus <- to_numeric_clean(census_data_raw$Age.65.Plus)
census_data_raw$Housing.Family.Household <- to_numeric_clean(census_data_raw$Housing.Family.Household)

# ---- Step 3: Compute overall summary metrics --------------------------------
total_pop <- sum(census_data_raw$Total.Pop, na.rm = TRUE)

summary_stats <- data.frame(
  Metric = c(
    "Total Population",
    "Average Total Population",

    "Total Race.POC",
    "Average Race.POC",
    "POC Percentage (Overall)",

    "Total Limited English Speaking (Not Well)",
    "Average Limited English Speaking (Not Well)",
    "Limited English Speaking Percentage (Overall)",

    "Total Age Under 5",
    "Average Age Under 5",
    "Age Under 5 Percentage (Overall)",

    "Total Age 65+",
    "Average Age 65+",
    "Age 65+ Percentage (Overall)",

    "Total Family Households",
    "Average Family Households",
    "Family Households Percentage (Overall)"
  ),
  Value = c(
    total_pop,
    mean(census_data_raw$Total.Pop, na.rm = TRUE),

    sum(census_data_raw$Race.POC, na.rm = TRUE),
    mean(census_data_raw$Race.POC, na.rm = TRUE),
    (sum(census_data_raw$Race.POC, na.rm = TRUE) / total_pop) * 100,

    sum(census_data_raw$Language.Speak.English.Not.Well, na.rm = TRUE),
    mean(census_data_raw$Language.Speak.English.Not.Well, na.rm = TRUE),
    (sum(census_data_raw$Language.Speak.English.Not.Well, na.rm = TRUE) / total_pop) * 100,

    sum(census_data_raw$Age.Under.5, na.rm = TRUE),
    mean(census_data_raw$Age.Under.5, na.rm = TRUE),
    (sum(census_data_raw$Age.Under.5, na.rm = TRUE) / total_pop) * 100,

    sum(census_data_raw$Age.65.Plus, na.rm = TRUE),
    mean(census_data_raw$Age.65.Plus, na.rm = TRUE),
    (sum(census_data_raw$Age.65.Plus, na.rm = TRUE) / total_pop) * 100,

    sum(census_data_raw$Housing.Family.Household, na.rm = TRUE),
    mean(census_data_raw$Housing.Family.Household, na.rm = TRUE),
    (sum(census_data_raw$Housing.Family.Household, na.rm = TRUE) / total_pop) * 100
  )
)

# ---- Step 4: Print + Export -------------------------------------------------
print(summary_stats)

output_file <- "overall_summary_all_metrics.csv"
write.csv(summary_stats, output_file, row.names = FALSE)
