
            library(ggplot2)
            library(palmerpenguins)
            built_answer <- tryCatch(
                {
                    set.seed(42)
                    ggplot(penguins, aes(x = species, y = body_mass_g, fill = species)) + geom_boxplot() + facet_wrap(~ island) + theme_classic() + labs(title = "Body Mass by Species and Island", x = "Species", y = "Body Mass (g)")
                    suppressWarnings(
                        if (!file.exists("/sandbox/figures/body-mass_species_boxplot_facet_island_theme_labs_answer.png")) {
                            ggsave(
                                width = 3,
                                height = 3,
                                "/sandbox/figures/body-mass_species_boxplot_facet_island_theme_labs_answer.png"
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

ggplot(penguins, aes(y = body_mass_g, x = species, fill = species)) +
  geom_boxplot() +
  facet_wrap(~island) +
  theme_classic() +
  labs(title = "Body Mass by Species and Island", x = "Species", y = "Body Mass (g)")
                    suppressWarnings(
                        ggsave(
                            width = 3,
                            height = 3,
                            "figures/body-mass_species_boxplot_facet_island_theme_labs_submission_granite.png"
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
        