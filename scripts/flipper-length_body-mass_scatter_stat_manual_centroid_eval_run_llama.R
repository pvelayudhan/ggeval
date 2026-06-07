
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
                    penguins$species <- as.factor(penguins$species)
ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g, color = species, alpha = 1)) +
  stat_manual(aes(x = x, y = y, color = species, size = 6, shape = 21), fun = function(data) data.frame(x = mean(data$x, na.rm = TRUE), y = mean(data$y, na.rm = TRUE)), geom = "point") +
  theme_void()
                    suppressWarnings(
                        ggsave(
                            width = 3,
                            height = 3,
                            "figures/flipper-length_body-mass_scatter_stat_manual_centroid_submission_llama.png"
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
        