
    library(ggplot2)
    library(palmerpenguins)
    built_answer <- tryCatch(
        {
            set.seed(42)
            ggplot(penguins, aes(x = species, y = bill_length_mm)) + geom_boxplot()
            suppressWarnings(ggsave(width = 3, height = 3, "figures/bill-length_species_boxplot_answer.png"))
            suppressWarnings(ggplot_build(last_plot()))
        },
        error = function(e) {
            FALSE
        }
    )
    built_submission <- tryCatch(
        {
            set.seed(42)
            ggplot(data = penguins, aes(x = species, y = bill_length_mm)) +
  geom_boxplot()
            suppressWarnings(ggsave(width = 3, height = 3, "figures/bill-length_species_boxplot_qwen_submission.png"))
            suppressWarnings(ggplot_build(last_plot()))
        },
        error = function(e) {
            FALSE
        }
    )
    print(isTRUE(all.equal(built_answer, built_submission)))
