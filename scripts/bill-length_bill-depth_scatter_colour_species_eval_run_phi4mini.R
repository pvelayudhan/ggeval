
            library(ggplot2)
            library(palmerpenguins)
            built_answer <- tryCatch(
                {
                    set.seed(42)
                    ggplot(penguins, aes(x = bill_length_mm, y = bill_depth_mm, colour = species)) + geom_point()
                    suppressWarnings(
                        if (!file.exists("/sandbox/figures/bill-length_bill-depth_scatter_colour_species_answer.png")) {
                            ggsave(
                                width = 3,
                                height = 3,
                                "/sandbox/figures/bill-length_bill-depth_scatter_colour_species_answer.png"
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
                    ggplot(penguins, aes(x = bill_length_mm, y = bill_depth_mm, color = species)) +

  geom_point() +

  labs(x = "Bill Length (mm)", y = "Bill Depth (mm)", color = "Species") +

  theme_minimal()
                    suppressWarnings(
                        ggsave(
                            width = 3,
                            height = 3,
                            "figures/bill-length_bill-depth_scatter_colour_species_submission_phi4mini.png"
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
        