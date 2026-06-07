
            library(ggplot2)
            library(palmerpenguins)
            built_answer <- tryCatch(
                {
                    set.seed(42)
                    ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g, colour = species)) + geom_point() + geom_smooth(method = "lm", se = FALSE) + facet_wrap(~ sex) + theme_minimal() + theme(legend.position = "none")
                    suppressWarnings(
                        if (!file.exists("/sandbox/figures/flipper-length_body-mass_scatter_smooth_facet_sex_legend_off_answer.png")) {
                            ggsave(
                                width = 3,
                                height = 3,
                                "/sandbox/figures/flipper-length_body-mass_scatter_smooth_facet_sex_legend_off_answer.png"
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
                    ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g, color = species)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  facet_wrap(~sex) +
  theme_minimal() +
  theme(legend = element_blank())
                    suppressWarnings(
                        ggsave(
                            width = 3,
                            height = 3,
                            "figures/flipper-length_body-mass_scatter_smooth_facet_sex_legend_off_submission_ministral.png"
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
        