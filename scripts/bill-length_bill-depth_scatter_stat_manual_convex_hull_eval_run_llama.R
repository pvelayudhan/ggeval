
            library(ggplot2)
            library(palmerpenguins)
            built_answer <- tryCatch(
                {
                    set.seed(42)
                    ggplot(penguins, aes(x = bill_length_mm, y = bill_depth_mm, colour = species)) + geom_point() + stat_manual(geom = "polygon", fun = function(data) data[chull(data$x, data$y), ], fill = NA)
                    suppressWarnings(
                        if (!file.exists("/sandbox/figures/bill-length_bill-depth_scatter_stat_manual_convex_hull_answer.png")) {
                            ggsave(
                                width = 3,
                                height = 3,
                                "/sandbox/figures/bill-length_bill-depth_scatter_stat_manual_convex_hull_answer.png"
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
                    penguins$bill_depth_mm <- penguins$bill_depth_mm / 10
ggplot(penguins, aes(x = bill_length_mm, y = bill_depth_mm, color = species)) +
  geom_point() +
  stat_manual(aes(fill = species), geom = "polygon", 
               fun = function(data) data[chull(data$x, data$y), ], 
               fill = NA) +
  theme_void()
                    suppressWarnings(
                        ggsave(
                            width = 3,
                            height = 3,
                            "figures/bill-length_bill-depth_scatter_stat_manual_convex_hull_submission_llama.png"
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
        