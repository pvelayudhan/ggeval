
            library(ggplot2)
            library(palmerpenguins)
            built_answer <- tryCatch(
                {
                    set.seed(42)
                    ggplot(penguins, aes(x = island, fill = species)) + geom_bar(position = "dodge")
                    suppressWarnings(
                        if (!file.exists("/sandbox/figures/species_island_bar_dodged_answer.png")) {
                            ggsave(
                                width = 3,
                                height = 3,
                                "/sandbox/figures/species_island_bar_dodged_answer.png"
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
                    ggplot(penguins, aes(x=island, fill=species)) + geom_bar(position=position_dodge())
                    suppressWarnings(
                        ggsave(
                            width = 3,
                            height = 3,
                            "figures/species_island_bar_dodged_submission_command-a-plus.png"
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
        