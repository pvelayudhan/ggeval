
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
                    library(ggplot2)
library(palmerpenguins)

ggplot(penguins, aes(x = species)) +
  geom_bar(fill = "blue") +
  labs(title = "Count of Penguins by Species",
       x = "Species",
       y = "Count")
                    suppressWarnings(
                        ggsave(
                            width = 3,
                            height = 3,
                            "figures/species_bar_count_submission_gemma.png"
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
        