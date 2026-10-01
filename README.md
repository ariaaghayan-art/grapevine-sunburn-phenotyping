# Grapevine Sunburn Phenotyping

## Overview

This repository contains an R-based proof-of-concept for image-assisted
phenotyping of grapevine sunburn severity.

The goal is to demonstrate how grape images can be converted into
quantitative image-derived features that may support automated
phenotyping workflows.

## Prototype workflow

Grapevine image  
→ Image preprocessing  
→ Background masking  
→ RGB / HSV feature extraction  
→ Brownness index  
→ Candidate phenotyping score

## Current demonstration

Three manually categorized grape images were used as a small proof-of-concept dataset:

- Healthy
- Mild sunburn
- Severe sunburn

The prototype extracts RGB, saturation, and a simple brownness-related
image feature from the cropped grape region.

## Results

For the current three-image demonstration, the candidate
brown-pixel fraction was:

| Phenotype | Candidate brown-pixel fraction |
|---|---:|
| Healthy | 5.0% |
| Mild | 12.3% |
| Severe | 55.6% |

These values are intended only to demonstrate the workflow and should
not be interpreted as a validated sunburn prediction model.

## Limitations

This is an early proof-of-concept based on only three images.
The current approach is rule-based and does not yet use machine learning
or deep learning.

Future work would include:

- larger and independently labelled image datasets
- automated berry/background segmentation
- feature validation across lighting and genotypes
- machine-learning or AI-based phenotyping
- comparison with standardized phenotypic scores

## Software

- R
- jpeg
- base R image-processing functions
