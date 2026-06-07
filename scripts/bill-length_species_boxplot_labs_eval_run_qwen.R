
            library(ggplot2)
            library(palmerpenguins)
            built_answer <- tryCatch(
                {
                    set.seed(42)
                    ggplot(penguins, aes(x = species, y = bill_length_mm)) + geom_boxplot() + labs(title = "Bill Length by Species", x = "Species", y = "Bill Length (mm)")
                    suppressWarnings(
                        if (!file.exists("/sandbox/figures/bill-length_species_boxplot_labs_answer.png")) {
                            ggsave(
                                width = 3,
                                height = 3,
                                "/sandbox/figures/bill-length_species_boxplot_labs_answer.png"
                            )
                        }
                    )
                    suppressWarnings(
                        ggplot_build(last_plot())
                    )
                },
                error = function(e) {
                    'ERROR'
                }
            )
            built_submission <- tryCatch(
                {
                    set.seed(42)
                    ggplot(data = penguins, aes(x = species, y = bill_length_mm)) +
  geom_boxplot() +
  labs(title = "Bill Length by Species",
       x = "Species",
       y = "Bill Length (mm)") +
  theme_minimal()
                    suppressWarnings(
                        ggsave(
                            width = 3,
                            height = 3,
                            "figures/bill-length_species_boxplot_labs_submission_qwen.png"
                        )
                    )
                    suppressWarnings(
                        ggplot_build(last_plot())
                    )
                },
                error = function(e) {
                    'ERROR'
                }
            )
            cat(isTRUE(all.equal(built_answer, built_submission)))
        