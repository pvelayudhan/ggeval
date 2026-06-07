
            library(ggplot2)
            library(palmerpenguins)
            built_answer <- tryCatch(
                {
                    set.seed(42)
                    ggplot(penguins, aes(x = island, fill = species)) + geom_bar() + scale_fill_manual(values = c(Adelie = "#FF6B6B", Chinstrap = "#4ECDC4", Gentoo = "#45B7D1"))
                    suppressWarnings(
                        if (!file.exists("/sandbox/figures/species_island_bar_stacked_scale_fill_manual_answer.png")) {
                            ggsave(
                                width = 3,
                                height = 3,
                                "/sandbox/figures/species_island_bar_stacked_scale_fill_manual_answer.png"
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
                    ggplot(data = penguins, aes(x = island)) +
  geom_bar(aes(y = ..count.., fill = species), stat = "identity") +
  scale_fill_manual(values = c("#FF6B6B", "#4ECDC4", "#45B7D1")) +
  theme_minimal()
                    suppressWarnings(
                        ggsave(
                            width = 3,
                            height = 3,
                            "figures/species_island_bar_stacked_scale_fill_manual_submission_qwen.png"
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
        