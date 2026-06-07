
            library(ggplot2)
            library(palmerpenguins)
            built_answer <- tryCatch(
                {
                    set.seed(42)
                    ggplot(penguins, aes(x = "", fill = species)) + geom_bar() + coord_polar(theta = "y") + scale_fill_manual(values = c(Adelie = "#E69F00", Chinstrap = "#56B4E9", Gentoo = "#009E73")) + theme_void()
                    suppressWarnings(
                        if (!file.exists("/sandbox/figures/species_count_pie_coord_polar_scale_fill_manual_answer.png")) {
                            ggsave(
                                width = 3,
                                height = 3,
                                "/sandbox/figures/species_count_pie_coord_polar_scale_fill_manual_answer.png"
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
                    library(palmerpenguins)
library(ggplot2)

ggplot(data = penguins, aes(x = "", fill = species)) +
  geom_bar() +
  coord_polar(theta = "y") +
  scale_fill_manual(values = c("Adelie" = "#E69F00", "Chinstrap" = "#56B4E9", "Gentoo" = "#009E73")) +
  theme_void()
                    suppressWarnings(
                        ggsave(
                            width = 3,
                            height = 3,
                            "figures/species_count_pie_coord_polar_scale_fill_manual_submission_phi4mini.png"
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
        