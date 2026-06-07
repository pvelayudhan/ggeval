
            library(ggplot2)
            library(palmerpenguins)
            built_answer <- tryCatch(
                {
                    set.seed(42)
                    ggplot(penguins, aes(x = bill_length_mm, y = bill_depth_mm, colour = species)) + geom_point() + scale_colour_manual(values = c(Adelie = "#E69F00", Chinstrap = "#56B4E9", Gentoo = "#009E73"))
                    suppressWarnings(
                        if (!file.exists("/sandbox/figures/bill-length_bill-depth_scatter_scale_colour_manual_answer.png")) {
                            ggsave(
                                width = 3,
                                height = 3,
                                "/sandbox/figures/bill-length_bill-depth_scatter_scale_colour_manual_answer.png"
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
  scale_color_manual(values = c("Adelie" = "#E69F00", "Chinstrap" = "#56B4E9", "Gentoo" = "#009E73"))
                    suppressWarnings(
                        ggsave(
                            width = 3,
                            height = 3,
                            "figures/bill-length_bill-depth_scatter_scale_colour_manual_submission_qwen3.5.png"
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
        