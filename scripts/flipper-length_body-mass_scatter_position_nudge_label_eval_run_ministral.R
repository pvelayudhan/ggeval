
            library(ggplot2)
            library(palmerpenguins)
            built_answer <- tryCatch(
                {
                    set.seed(42)
                    ggplot(island_means, aes(x = mean_flipper, y = mean_mass)) + geom_point(size = 4) + geom_label(aes(label = island), position = position_nudge(y = 1))
                    suppressWarnings(
                        if (!file.exists("/sandbox/figures/flipper-length_body-mass_scatter_position_nudge_label_answer.png")) {
                            ggsave(
                                width = 3,
                                height = 3,
                                "/sandbox/figures/flipper-length_body-mass_scatter_position_nudge_label_answer.png"
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
                    ggplot(island_means, aes(x = mean_flipper, y = mean_mass, size = 4)) +
  geom_point() +
  geom_label(aes(label = island), position_nudge(y = 1))
                    suppressWarnings(
                        ggsave(
                            width = 3,
                            height = 3,
                            "figures/flipper-length_body-mass_scatter_position_nudge_label_submission_ministral.png"
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
        