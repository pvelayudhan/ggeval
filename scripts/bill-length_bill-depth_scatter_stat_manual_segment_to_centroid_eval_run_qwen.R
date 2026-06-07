
            library(ggplot2)
            library(palmerpenguins)
            built_answer <- tryCatch(
                {
                    set.seed(42)
                    ggplot(penguins, aes(x = bill_length_mm, y = bill_depth_mm, colour = species)) + geom_point(alpha = 0.4) + stat_manual(geom = "segment", fun = function(data) transform(data, xend = mean(data$x, na.rm = TRUE), yend = mean(data$y, na.rm = TRUE)))
                    suppressWarnings(
                        if (!file.exists("/sandbox/figures/bill-length_bill-depth_scatter_stat_manual_segment_to_centroid_answer.png")) {
                            ggsave(
                                width = 3,
                                height = 3,
                                "/sandbox/figures/bill-length_bill-depth_scatter_stat_manual_segment_to_centroid_answer.png"
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
                    ggplot(penguins, aes(x=bill_length_mm, y=bill_depth_mm, color=species)) +
  geom_point(alpha = 0.4) +
  stat_manual(mapping=aes(group = species),
              geom="segment",
              fun=function(data){
                data$xend <- mean(data$x, na.rm = TRUE)
                data$yend <- mean(data$y, na.rm = TRUE)
                return(data)
              },
              colour="black") +
  scale_color_manual(values=c("Adelie"="blue", "Chinstrap"="red", "Gentoo"="green"))
                    suppressWarnings(
                        ggsave(
                            width = 3,
                            height = 3,
                            "figures/bill-length_bill-depth_scatter_stat_manual_segment_to_centroid_submission_qwen.png"
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
        