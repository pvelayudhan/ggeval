
            library(ggplot2)
            library(palmerpenguins)
            built_answer <- tryCatch(
                {
                    set.seed(42)
                    ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g, colour = species)) + geom_point(alpha = 0.4) + stat_manual(geom = "point", fun = function(data) data.frame(x = mean(data$x, na.rm = TRUE), y = mean(data$y, na.rm = TRUE)), size = 6, shape = 21)
                    suppressWarnings(
                        if (!file.exists("/sandbox/figures/flipper-length_body-mass_scatter_stat_manual_centroid_answer.png")) {
                            ggsave(
                                width = 3,
                                height = 3,
                                "/sandbox/figures/flipper-length_body-mass_scatter_stat_manual_centroid_answer.png"
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

ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g, color = species)) +
  geom_point(alpha = 0.4) +
  stat_manual(data = function() {
    data.frame(x = mean(penguins$flipper_length_mm, na.rm = TRUE),
               y = mean(penguins$body_mass_g, na.rm = TRUE),
               species = levels(penguins$species))
  }, geom = "point", size = 6, shape = 21, color = "steelblue") +
  theme_minimal()
                    suppressWarnings(
                        ggsave(
                            width = 3,
                            height = 3,
                            "figures/flipper-length_body-mass_scatter_stat_manual_centroid_submission_granite.png"
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
        