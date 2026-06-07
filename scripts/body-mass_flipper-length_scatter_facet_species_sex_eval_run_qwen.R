
            library(ggplot2)
            library(palmerpenguins)
            built_answer <- tryCatch(
                {
                    set.seed(42)
                    ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) + geom_point() + facet_grid(species ~ sex)
                    suppressWarnings(
                        if (!file.exists("/sandbox/figures/body-mass_flipper-length_scatter_facet_species_sex_answer.png")) {
                            ggsave(
                                width = 3,
                                height = 3,
                                "/sandbox/figures/body-mass_flipper-length_scatter_facet_species_sex_answer.png"
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
                    ggplot(data = penguins, aes(x = flipper_length_mm, y = body_mass_g)) +
  facet_wrap(~ species + sex) +
  geom_point()
                    suppressWarnings(
                        ggsave(
                            width = 3,
                            height = 3,
                            "figures/body-mass_flipper-length_scatter_facet_species_sex_submission_qwen.png"
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
        