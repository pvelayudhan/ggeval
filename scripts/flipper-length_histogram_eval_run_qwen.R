
            library(ggplot2)
            library(palmerpenguins)
            built_answer <- tryCatch(
                {
                    set.seed(42)
                    ggplot(penguins, aes(x = flipper_length_mm)) + geom_histogram(binwidth = 5)
                    suppressWarnings(
                        if (!file.exists("/sandbox/figures/flipper-length_histogram_answer.png")) {
                            ggsave(
                                width = 3,
                                height = 3,
                                "/sandbox/figures/flipper-length_histogram_answer.png"
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
                    ggplot(data = penguins, aes(x = flipper_length_mm)) +
    geom_histogram(binwidth = 5)
                    suppressWarnings(
                        ggsave(
                            width = 3,
                            height = 3,
                            "figures/flipper-length_histogram_submission_qwen.png"
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
        