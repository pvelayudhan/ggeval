
            library(ggplot2)
            library(palmerpenguins)
            built_answer <- tryCatch(
                {
                    set.seed(42)
                    ggplot(penguins, aes(x = species, y = bill_length_mm)) + geom_boxplot() + theme(axis.text = element_text(size = 14), axis.title = element_text(size = 16))
                    suppressWarnings(
                        if (!file.exists("/sandbox/figures/bill-length_species_boxplot_font_size_axis_answer.png")) {
                            ggsave(
                                width = 3,
                                height = 3,
                                "/sandbox/figures/bill-length_species_boxplot_font_size_axis_answer.png"
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
                    penguins$species <- as.factor(penguins$species)
ggplot(penguins, aes(x = species, y = bill_length_mm)) +
  geom_boxplot() +
  theme(axis.text.x = element_text(size = 14),
        axis.title.x = element_text(size = 16),
        axis.text.y = element_text(size = 14),
        axis.title.y = element_text(size = 16))
                    suppressWarnings(
                        ggsave(
                            width = 3,
                            height = 3,
                            "figures/bill-length_species_boxplot_font_size_axis_submission_llama.png"
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
        