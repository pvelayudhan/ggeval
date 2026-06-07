
            library(ggplot2)
            library(palmerpenguins)
            built_answer <- tryCatch(
                {
                    set.seed(42)
                    ggplot(penguins, aes(x = bill_length_mm, y = bill_depth_mm, colour = species)) + geom_point(alpha = 0.3) + geom_density_2d()
                    suppressWarnings(
                        if (!file.exists("/sandbox/figures/bill-length_bill-depth_scatter_2d_density_answer.png")) {
                            ggsave(
                                width = 3,
                                height = 3,
                                "/sandbox/figures/bill-length_bill-depth_scatter_2d_density_answer.png"
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
                    ggplot(data = penguins, aes(x = bill_length_mm, y = bill_depth_mm)) +
  geom_density_2d(aes(color = species), alpha = 1) +
  geom_point(aes(color = species), size = 2, alpha = 0.3)
                    suppressWarnings(
                        ggsave(
                            width = 3,
                            height = 3,
                            "figures/bill-length_bill-depth_scatter_2d_density_submission_qwen.png"
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
        