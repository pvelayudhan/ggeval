
            library(ggplot2)
            library(palmerpenguins)
            built_answer <- tryCatch(
                {
                    set.seed(42)
                    ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g, colour = sex, shape = species)) + geom_point()
                    suppressWarnings(
                        if (!file.exists("/sandbox/figures/body-mass_flipper-length_scatter_colour_sex_shape_species_answer.png")) {
                            ggsave(
                                width = 3,
                                height = 3,
                                "/sandbox/figures/body-mass_flipper-length_scatter_colour_sex_shape_species_answer.png"
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
                    ggplot(data = penguins, aes(x = flipper_length_mm, y = body_mass_g, color = sex, shape = species)) + geom_point()
                    suppressWarnings(
                        ggsave(
                            width = 3,
                            height = 3,
                            "figures/body-mass_flipper-length_scatter_colour_sex_shape_species_submission_command-a-plus.png"
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
        