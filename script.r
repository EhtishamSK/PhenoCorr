# Correlation
setwd("C:/Users/ehtis/OneDrive - New Mexico State University/SUNNY/Research Projects/Mechanical Harvest Paper/Phenotype manuscript/PCA")
install.packages("metan")
library (metan)
#import data set, adjusted means
data <- read.csv("mydata.csv")
head(data)
str(data)
summary(data)
options(max.print = 99999)
print(data)
#A subset of the data is created, excluding the first column (genotypes)
data_corr <- data[, -1, drop = FALSE]
str(data_corr)
# Correlation
corrl <- corr_coef(data_corr)
plot(corrl)
#correlation table
correlation_table0 <- cor(data_corr)
write.csv(correlation_table0, file = "correlation_table0.csv", row.names = FALSE)
# Check for constant variables
constant_vars <- names(data_corr)[apply(data_corr, 2, function(x) length(unique(x))) == 1]
print(constant_vars)
# Calculate correlation matrix, ignoring NAs
correlation_matrix <- cor(data_corr, method = "pearson", use = "pairwise.complete.obs")
# Initialize an empty matrix for storing correlation coefficients with significance levels
correlation_table <- matrix("", nrow = ncol(correlation_matrix), ncol = ncol(correlation_matrix))
# Loop through each pair of variables
for(i in 1:ncol(correlation_matrix)) {
  for(j in 1:ncol(correlation_matrix)) {
    # Skip diagonal elements
    if(i == j) next
    # Perform correlation test
    correlation_test <- cor.test(data_corr[[i]], data_corr[[j]], use = "pairwise.complete.obs")
    # Get correlation coefficient
    r <- correlation_matrix[i, j]
    # Get p-value
    p <- correlation_test$p.value
    # Add significance level
    if(p < 0.001) {
      correlation_table[i, j] <- paste0(format(r, digits = 2), "***")
    } else if(p < 0.01) {
      correlation_table[i, j] <- paste0(format(r, digits = 2), "**")
    } else if(p < 0.05) {
      correlation_table[i, j] <- paste0(format(r, digits = 2), "*")
    } else {
      correlation_table[i, j] <- format(r, digits = 2)
    }
  }
}
# Convert to data frame for better display
correlation_table <- as.data.frame(correlation_table)
# Print the correlation table
print(correlation_table)
# Write the correlation table to a CSV file
write.csv(correlation_table, file = "correlation_table.csv", row.names = FALSE)


# Calculate the correlation matrix for the data using Pearson's correlation method
corMat1 <-  cor(data_corr, method = "pearson", use="pairwise")

# Define groups for the traits to be used in the visualization
groups <- list(Plant_architecture = c(1,2,3,4,5),
               Fruit_destemming = c(6,7,8,9),
               Fruit_morphology = c(10,11,12,13,14,15,16),
               Yeild_parameters = c(17,18,19,20))

# Set the labels for the traits corresponding to the columns in the data
trait_labels <- c("PHT", "PWDT", "HTFPB", "DTFN", "NBB", "DSFG", "DSFR", "DSRG", "DSRR",  
                  "ARA", "CURH", "HMW", "MAXH", "MAXW", "PER", "WMH", "GRN", "RED", "TLY", "PODWT")

# Save the plot as a PNG file with specific dimensions and resolution
png("qgraph_correlation_plot2.png", width = 12, height = 8, units = "in", res = 600, bg = "white")

library(qgraph)
qgraph(corMat1, graph = "cor", groups=groups, minimum=0.23,
       borders = TRUE,
       shape="rectangle", vsize=6, vsize2=2,
       labels = trait_labels,  # Explicitly set labels
       edge.labels=TRUE, edge.label.cex=0.5,  # Increase correlation label font size
       label.cex=1, 
       edge.label.bg=FALSE, edge.label.color="black", edge.label.position=0.65, 
       legend.cex = 0.5, esize=7,
       posCol="seagreen", negCol="coral3", label.scale=FALSE,
       palette="rainbow")

dev.off()




# plot only significant correlations 

library(qgraph)
library(psych)  # Load psych package for corr.test

# Compute correlation matrix and p-values in one step
corr_results <- corr.test(data_corr, method = "pearson", use = "pairwise.complete.obs")

# Extract correlation matrix
corMat1 <- corr_results$r  

# Extract p-value matrix
pMat1 <- corr_results$p  

# Apply significance threshold (e.g., p < 0.05)
corMat1[pMat1 >= 0.05] <- 0  # Set non-significant correlations to zero

# Force symmetry to avoid numerical inconsistencies
corMat1 <- (corMat1 + t(corMat1)) / 2


# Define groups for visualization
groups <- list(
  Plant_architecture = c(1,2,3,4,5),
  Fruit_destemming = c(6,7,8,9),
  Fruit_morphology = c(10,11,12,13,14,15,16),
  Yield_parameters = c(17,18,19,20)
)

trait_labels <- c("PHT", "PWDT", "HTFPB", "DTFN", "NBB", "DSFG", "DSFR", "DSRG", "DSRR",  
                  "ARA", "CURH", "HMW", "MAXH", "MAXW", "PER", "WMH", "GRN", "RED", "TLY", "PODWT")

# Plot the significant correlations
png("qgraph_correlation_plot.png", width = 12, height = 8, units = "in", res = 600, bg = "white")

qgraph(corMat1, graph = "cor", groups=groups, minimum=0.23,
       borders = TRUE,
       shape="rectangle", vsize=6, vsize2=4.5,
       labels = trait_labels,  # Explicitly set labels
       edge.labels=TRUE, edge.label.cex=1,  # Increase correlation label font size
       label.cex=2, 
       edge.label.bg=FALSE, edge.label.color="black", edge.label.position=0.65, 
       legend.cex = 0.5, esize=7,
       posCol="DarkGreen", negCol="coral3", label.scale=FALSE,
       palette="rainbow")

dev.off()





