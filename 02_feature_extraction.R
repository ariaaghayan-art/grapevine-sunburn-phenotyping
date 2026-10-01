library(jpeg)

# ---------------------------------------------------------
# Function 1: Extract color features from a grape image
# ---------------------------------------------------------

analyze_grape <- function(path, label) {
  
  img <- readJPEG(path)
  
  r <- img[,,1]
  g <- img[,,2]
  b <- img[,,3]
  
  # Brightness / Value
  value <- pmax(r, g, b)
  
  # Simple background mask
  mask <- value < 0.95
  
  # Keep only pixels belonging to the grape region
  red <- r[mask]
  green <- g[mask]
  blue <- b[mask]
  
  # Convert RGB pixels to HSV
  rgb_values <- cbind(red, green, blue)
  hsv_values <- grDevices::rgb2hsv(t(rgb_values))
  
  saturation <- hsv_values[2, ]
  
  # Simple brownness index
  brownness_index <- (red - green) / (red + green + blue + 0.0001)
  
  data.frame(
    Label = label,
    Mean_Red = mean(red),
    Mean_Green = mean(green),
    Mean_Blue = mean(blue),
    Mean_Saturation = mean(saturation),
    Median_Saturation = median(saturation),
    Mean_Brownness = mean(brownness_index),
    Median_Brownness = median(brownness_index),
    Mask_fraction = mean(mask)
  )
}


# ---------------------------------------------------------
# Analyze the three grape images
# ---------------------------------------------------------

healthy_features <- analyze_grape(
  "data/healthy/a_crop.jpg",
  "Healthy"
)

mild_features <- analyze_grape(
  "data/mild_sunburn/b_crop.jpg",
  "Mild"
)

severe_features <- analyze_grape(
  "data/severe_sunburn/c_crop.jpg",
  "Severe"
)


# ---------------------------------------------------------
# Combine all results into one table
# ---------------------------------------------------------

features <- rbind(
  healthy_features,
  mild_features,
  severe_features
)

features


# ---------------------------------------------------------
# Calculate brownness values for the healthy image
# ---------------------------------------------------------

healthy_img <- readJPEG("data/healthy/a_crop.jpg")

r <- healthy_img[,,1]
g <- healthy_img[,,2]
b <- healthy_img[,,3]

value <- pmax(r, g, b)

mask <- value < 0.95

healthy_brownness <- (r - g) / (r + g + b + 0.0001)

healthy_brownness <- healthy_brownness[mask]


# ---------------------------------------------------------
# Define an experimental brownness threshold
# using the upper 95th percentile of the healthy sample
# ---------------------------------------------------------

brown_threshold <- quantile(
  healthy_brownness,
  probs = 0.95,
  na.rm = TRUE
)

brown_threshold
calculate_brown_fraction <- function(path, threshold) {
  
  img <- readJPEG(path)
  
  r <- img[,,1]
  g <- img[,,2]
  b <- img[,,3]
  
  value <- pmax(r, g, b)
  mask <- value < 0.95
  
  brownness <- (r - g) / (r + g + b + 0.0001)
  
  mean(brownness[mask] > threshold)
}

brown_fraction <- data.frame(
  Label = c("Healthy", "Mild", "Severe"),
  
  Brown_Fraction = c(
    calculate_brown_fraction(
      "data/healthy/a_crop.jpg",
      brown_threshold
    ),
    
    calculate_brown_fraction(
      "data/mild_sunburn/b_crop.jpg",
      brown_threshold
    ),
    
    calculate_brown_fraction(
      "data/severe_sunburn/c_crop.jpg",
      brown_threshold
    )
  )
)

brown_fraction
barplot(
  brown_fraction$Brown_Fraction * 100,
  names.arg = brown_fraction$Label,
  ylab = "Candidate brown-pixel fraction (%)",
  xlab = "Sunburn severity",
  main = "Image-based grapevine sunburn phenotyping",
  ylim = c(0, 60)
)
png(
  "results/sunburn_phenotyping.png",
  width = 900,
  height = 600
)

barplot(
  brown_fraction$Brown_Fraction * 100,
  names.arg = brown_fraction$Label,
  ylab = "Candidate brown-pixel fraction (%)",
  xlab = "Sunburn severity",
  main = "Image-based grapevine sunburn phenotyping",
  ylim = c(0, 60)
)

dev.off()
dir.create("results", showWarnings = FALSE)