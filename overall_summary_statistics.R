# -----------------------------------------------------------------------------
# overall_summary_statistics.R
#
# Purpose:
#   Read tract-level demographic data, clean key numeric indicator fields,
#   compute overall summary statistics (totals/means/percentages), and export
#   a reporting-ready CSV.
#
# Notes:
#   Many census-style exports store numbers with commas/percent signs or other
#   characters. This script strips non-numeric characters and coerces fields
#   to numeric before calculations.
# -----------------------------------------------------------------------------

# ---- Step 1: Read raw data --------------------------------------------------
input_file <- "Demographics by Tract.csv"   # keep generic for GitHub
census_data_raw <- read.csv(input_file, sep = ",", header = TRUE, stringsAsFactors = FALSE)

# ---- Helper: clean numeric strings ------------------------------------------
# Removes everything except digits, decimal points, and minus signs.
to_numeric_clean <- function(x) {
  x <- gsub("[^0-9.-]", "", x)
  as.numeric(x)
}

# ---- Step 2: Clean key numeric columns --------------------------------------
census_data_raw$Total.Pop <- to_numeric_clean(census_data_raw$Total.Pop)

# People of color (POC)
census_data_raw$Race.POC <- to_numeric_clean(census_data_raw$Race.POC)

# Limited English speakers
census_data_raw$Language.Speak.English.Not.Well <- to_numeric_clean(
  census_data_raw$Language.Speak.English.Not.Well
)

# Under 5 years old
census_data_raw$Age.Under.5 <- to_numeric_clean(census_data_raw$Age.Under.5)

# Age 65+
census_data_raw$Age.65.Plus <- to_numeric_clean(census_data_raw$Age.65.Plus)

# Family households
census_data_raw$Housing.Family.Household <- to_numeric_clean(census_data_raw$Housing.Family.Household)

# ---- Step 3: Compute overall summary statistics -----------------------------
total_pop <- sum(census_data_raw$Total.Pop, na.rm = TRUE)

summary_stats <- data.frame(
  Metric = c(
    "Total Population",
    "Average Total Population",

    "Total Race.POC",
    "Average Race.POC",
    "POC Percentage (Overall)",

    "Total Age 65+",
    "Average Age 65+",
    "Age 65+ Percentage (Overall)",

    "Total Limited English Speaking",
    "Average Limited English Speaking",
    "Limited English Speaking Percentage (Overall)",

    "Total Age Under 5",
    "Average Age Under 5",
    "Age Under 5 Percentage (Overall)",

    "Total Family Housing",
    "Average Family Housing",
    "Family Housing Percentage (Overall)"
  ),
  Value = c(
    total_pop,
    mean(census_data_raw$Total.Pop, na.rm = TRUE),

    sum(census_data_raw$Race.POC, na.rm = TRUE),
    mean(census_data_raw$Race.POC, na.rm = TRUE),
    (sum(census_data_raw$Race.POC, na.rm = TRUE) / total_pop) * 100,

    sum(census_data_raw$Age.65.Plus, na.rm = TRUE),
    mean(census_data_raw$Age.65.Plus, na.rm = TRUE),
    (sum(census_data_raw$Age.65.Plus, na.rm = TRUE) / total_pop) * 100,

    sum(census_data_raw$Language.Speak.English.Not.Well, na.rm = TRUE),
    mean(census_data_raw$Language.Speak.English.Not.Well, na.rm = TRUE),
    (sum(census_data_raw$Language.Speak.English.Not.Well, na.rm = TRUE) / total_pop) * 100,

    sum(census_data_raw$Age.Under.5, na.rm = TRUE),
    mean(census_data_raw$Age.Under.5, na.rm = TRUE),
    (sum(census_data_raw$Age.Under.5, na.rm = TRUE) / total_pop) * 100,

    sum(census_data_raw$Housing.Family.Household, na.rm = TRUE),
    mean(census_data_raw$Housing.Family.Household, na.rm = TRUE),
    (sum(census_data_raw$Housing.Family.Household, na.rm = TRUE) / total_pop) * 100
  )
)

# ---- Step 4: Export ---------------------------------------------------------
output_file <- "2022_summary_stats.csv"
write.csv(summary_stats, output_file, row.names = FALSE)
