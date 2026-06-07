
            library(ggplot2)
            library(palmerpenguins)
            built_answer <- tryCatch(
                {
                    set.seed(42)
                    ggplot(penguins, aes(x = species, y = bill_length_mm, fill = species)) + stat_summary(fun = mean, geom = "bar")
                    suppressWarnings(
                        if (!file.exists("/sandbox/figures/bill-length_species_mean_bar_stat_summary_answer.png")) {
                            ggsave(
                                width = 3,
                                height = 3,
                                "/sandbox/figures/bill-length_species_mean_bar_stat_summary_answer.png"
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
library(palmerpenguins)

ggplot(penguins, aes(x = species, y = bill_length_mm, fill = species)) +
  stat_summary(fun = mean, geom = "bar")
                    suppressWarnings(
                        ggsave(
                            width = 3,
                            height = 3,
                            "figures/bill-length_species_mean_bar_stat_summary_submission_gemma.png"
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
        