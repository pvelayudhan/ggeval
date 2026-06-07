
            library(ggplot2)
            library(palmerpenguins)
            built_answer <- tryCatch(
                {
                    set.seed(42)
                    ggplot(species_means, aes(x = mean_bill_length, y = mean_bill_depth, colour = species)) + geom_point() + geom_text(aes(label = species), position = position_nudge(x = 0.8))
                    suppressWarnings(
                        if (!file.exists("/sandbox/figures/bill-length_bill-depth_scatter_position_nudge_text_answer.png")) {
                            ggsave(
                                width = 3,
                                height = 3,
                                "/sandbox/figures/bill-length_bill-depth_scatter_position_nudge_text_answer.png"
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
                    library(ggplot2)

species_means %>%
  ggplot(aes(x = mean_bill_length, y = mean_bill_depth, color = species)) +
  geom_point() +
  geom_text(aes(label = species), nudge_x = 0.8, color = species) +
  labs(title = "Mean Bill Length vs. Mean Bill Depth by Species",
       x = "Mean Bill Length (mm)",
       y = "Mean Bill Depth (mm)",
       color = "Species")
                    suppressWarnings(
                        ggsave(
                            width = 3,
                            height = 3,
                            "figures/bill-length_bill-depth_scatter_position_nudge_text_submission_gemma.png"
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
        