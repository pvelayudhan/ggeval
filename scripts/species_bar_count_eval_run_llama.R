
            library(ggplot2)
            library(palmerpenguins)
            built_answer <- tryCatch(
                {
                    set.seed(42)
                    ggplot(penguins, aes(x = species, fill = species)) + geom_bar()
                    suppressWarnings(
                        if (!file.exists("/sandbox/figures/species_bar_count_answer.png")) {
                            ggsave(
                                width = 3,
                                height = 3,
                                "/sandbox/figures/species_bar_count_answer.png"
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
                    ggplot(penguins, aes(x = NULL, y = ~ species, fill = species)) +
  geom_bar(stat = "count") +
  labs(x = NULL, y = "Species", fill = "Species") +
  theme_void()
                    suppressWarnings(
                        ggsave(
                            width = 3,
                            height = 3,
                            "figures/species_bar_count_submission_llama.png"
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
        