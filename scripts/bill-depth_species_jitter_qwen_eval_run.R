
            library(ggplot2)
            library(palmerpenguins)
            built_answer <- tryCatch(
                {
                    set.seed(42)
                    ggplot(penguins, aes(x = species, y = bill_depth_mm)) + geom_jitter()
                    suppressWarnings(
                        if (!file.exists("/sandbox/figures/bill-depth_species_jitter_answer.png")) {
                            ggsave(
                                width = 3,
                                height = 3,
                                "/sandbox/figures/bill-depth_species_jitter_answer.png"
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
                    ggplot(data = penguins, aes(x = species, y = bill_depth_mm)) +
  geom_jitter(width = 0.1)
                    suppressWarnings(
                        ggsave(
                            width = 3,
                            height = 3,
                            "figures/bill-depth_species_jitter_qwen_submission.png"
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
        