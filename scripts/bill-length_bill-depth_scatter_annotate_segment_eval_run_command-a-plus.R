
            library(ggplot2)
            library(palmerpenguins)
            built_answer <- tryCatch(
                {
                    set.seed(42)
                    ggplot(penguins, aes(x = bill_length_mm, y = bill_depth_mm, colour = species)) + geom_point() + annotate("segment", x = 50, xend = 47, y = 20, yend = 18, colour = "black", arrow = arrow(length = unit(0.3, "cm")))
                    suppressWarnings(
                        if (!file.exists("/sandbox/figures/bill-length_bill-depth_scatter_annotate_segment_answer.png")) {
                            ggsave(
                                width = 3,
                                height = 3,
                                "/sandbox/figures/bill-length_bill-depth_scatter_annotate_segment_answer.png"
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
                    ggplot(data=penguins, aes(x=bill_length_mm, y=bill_depth_mm, colour=species)) + 
  geom_point() + 
  annotate("segment", x = 50, y = 20, xend = 47, yend = 18, colour = "black", arrow = arrow(length = unit(0.3, "cm")))
                    suppressWarnings(
                        ggsave(
                            width = 3,
                            height = 3,
                            "figures/bill-length_bill-depth_scatter_annotate_segment_submission_command-a-plus.png"
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
        