library(ggplot2)
library(palmerpenguins)

myplot <-
    ggplot(penguins, aes(x = species, y = bill_length_mm)) + 
    geom_boxplot()

right1 <-
    ggplot(penguins, aes(x = species, y = bill_length_mm)) + 
    geom_boxplot()
