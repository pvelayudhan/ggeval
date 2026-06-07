
            library(ggplot2)
            library(palmerpenguins)
            built_answer <- tryCatch(
                {
                    set.seed(42)
                    ggplot(penguins, aes(x = species, y = bill_length_mm, fill = species)) + stat_summary(fun = mean, geom = "bar") + stat_summary(fun.data = mean_se, geom = "errorbar", width = 0.2)
                    suppressWarnings(
                        if (!file.exists("/sandbox/figures/bill-length_species_mean_bar_errorbar_answer.png")) {
                            ggsave(
                                width = 3,
                                height = 3,
                                "/sandbox/figures/bill-length_species_mean_bar_errorbar_answer.png"
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
                    penguins %>%
  group_by(species) %>%
  stat_summary(fun.y = mean, geom = "bar", fill = "reversed", 
               stat = "identity") %>%
  stat_summary(fun.data = mean_se, geom = "errorbar", width = 0.2, 
                fill = "reversed", color = "black")
                    suppressWarnings(
                        ggsave(
                            width = 3,
                            height = 3,
                            "figures/bill-length_species_mean_bar_errorbar_submission_llama.png"
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
        