
            library(ggplot2)
            library(palmerpenguins)
            built_answer <- tryCatch(
                {
                    set.seed(42)
                    ggplot(mean_bill, aes(x = species, y = mean_bill_length, fill = species)) + geom_bar(stat = "identity") + scale_fill_manual(values = c(Adelie = "#E69F00", Chinstrap = "#56B4E9", Gentoo = "#009E73")) + geom_text(aes(label = round(mean_bill_length, 1)), position = position_nudge(y = 0.5)) + theme(axis.title = element_text(size = 14))
                    suppressWarnings(
                        if (!file.exists("/sandbox/figures/bill-length_species_mean_bar_stat_identity_nudge_label_scale_fill_manual_answer.png")) {
                            ggsave(
                                width = 3,
                                height = 3,
                                "/sandbox/figures/bill-length_species_mean_bar_stat_identity_nudge_label_scale_fill_manual_answer.png"
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
                    ggplot(mean_bill, aes(x = species, y = mean_bill_length, fill = species)) +
  geom_bar(stat = "identity") +
  scale_fill_manual(values = c("Adelie" = "#E69F00", "Chinstrap" = "#56B4E9", "Gentoo" = "#009E73")) +
  geom_text(aes(label = round(mean_bill_length, 1)), position = position_nudge(y = 0.5)) +
  theme(axis.title = element_text(size = 14))
                    suppressWarnings(
                        ggsave(
                            width = 3,
                            height = 3,
                            "figures/bill-length_species_mean_bar_stat_identity_nudge_label_scale_fill_manual_submission_command-a-plus.png"
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
        