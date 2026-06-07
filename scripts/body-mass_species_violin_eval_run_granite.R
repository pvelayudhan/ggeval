
            library(ggplot2)
            library(palmerpenguins)
            built_answer <- tryCatch(
                {
                    set.seed(42)
                    ggplot(penguins, aes(x = species, y = body_mass_g)) + geom_violin()
                    suppressWarnings(
                        if (!file.exists("/sandbox/figures/body-mass_species_violin_answer.png")) {
                            ggsave(
                                width = 3,
                                height = 3,
                                "/sandbox/figures/body-mass_species_violin_answer.png"
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

ggplot(penguins, aes(x = species, y = body_mass_g)) +
  geom_violin()
                    suppressWarnings(
                        ggsave(
                            width = 3,
                            height = 3,
                            "figures/body-mass_species_violin_submission_granite.png"
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
        