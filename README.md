Overview

This project processes tract-level demographic data to generate overall population summaries and vulnerability-related percentage metrics. Numeric fields containing formatting artifacts (commas, symbols) are cleaned and standardized before summary statistic generation.

The analysis produces:

Cleaned numeric demographic indicators

Population-weighted percentage metrics

Overall totals and averages

Reporting-ready CSV outputs

Key indicators include:

Total population

People of color (POC)

Limited English proficiency

Age under 5

Age 65+

Family households

Project Structure

overall_summary_statistics.R – Cleans demographic fields and generates overall summary metrics.

tract_level_metrics.R – Produces tract-level derived percentages and grouped metrics.

run_analysis.R – Optional execution script.

Methods Used

Regex-based numeric cleaning

Population-weighted percentage calculation

Grouped tract-level summarization

Structured CSV export for reporting

This workflow demonstrates data cleaning, public health–relevant metric derivation, and structured summary reporting.

ggplot2 for probability visualization

This workflow demonstrates applied biostatistical analysis suitable for epidemiology and diagnostic performance evaluation contexts.
