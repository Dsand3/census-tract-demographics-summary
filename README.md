Overview

This project evaluates tissue-level diagnostic success probabilities using structured statistical workflows in R. Wide-format laboratory results are reshaped into long format, per-tissue success proportions are calculated, and inferential comparisons are performed.

The analysis includes:

Wide-to-long data reshaping

Binomial proportion estimation

Wilson confidence interval calculation

Pairwise Fisher’s exact testing

Logistic regression modeling (Result ~ Tissue)

Ordered visualizations of diagnostic yield

Project Structure

tissue_success_probability_analysis.R – Full analysis pipeline including:

Data reshaping

Proportion estimation

Confidence intervals

Optional statistical testing

Visualization

Methods Used

tidyr::pivot_longer() for reshaping

binom::binom.confint() for Wilson intervals

fisher.test() for pairwise comparisons

glm(..., family = binomial) for logistic modeling

ggplot2 for probability visualization

This workflow demonstrates applied biostatistical analysis suitable for epidemiology and diagnostic performance evaluation contexts.
