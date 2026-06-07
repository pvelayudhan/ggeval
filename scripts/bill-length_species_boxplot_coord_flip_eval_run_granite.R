
            library(ggplot2)
            library(palmerpenguins)
            built_answer <- tryCatch(
                {
                    set.seed(42)
                    ggplot(penguins, aes(x = species, y = bill_length_mm)) + geom_boxplot() + coord_flip()
                    suppressWarnings(
                        if (!file.exists("/sandbox/figures/bill-length_species_boxplot_coord_flip_answer.png")) {
                            ggsave(
                                width = 3,
                                height = 3,
                                "/sandbox/figures/bill-length_species_boxplot_coord_flip_answer.png"
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
                    library(palmerpenguins)
library(ggplot2)

ggplot(penguins, aes(x = species, y = bill_length_mm)) +
  geom_boxplot() +
  coord_flip()
                    suppressWarnings(
                        ggsave(
                            width = 3,
                            height = 3,
                            "figures/bill-length_species_boxplot_coord_flip_submission_granite.png"
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
        