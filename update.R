# Update `_palettes.qmd` with the latest iterm palettes in ggsci

pal_name <- ggsci::iterm_palettes()

pal_slug <- pal_name |>
  tolower() |>
  gsub("\\+", " plus ", x = _) |>
  gsub("\\(", " ", x = _) |>
  gsub("\\)", " ", x = _) |>
  gsub("[^a-z0-9]+", "-", x = _) |>
  gsub("-+", "-", x = _) |>
  gsub("^-", "", x = _) |>
  gsub("-$", "", x = _) |>
  (\(x) {
    x[!nzchar(x)] <- "palette"
    x
  })() |>
  make.unique(sep = "-")

chunk_label <- sprintf("ggsci-iterm-%s", pal_slug)

content <- character(0L)

for (i in seq_along(pal_name)) {
  content <- c(
    content,
    sprintf("## %s", pal_name[i]),
    "",
    sprintf("```{r, %s}", chunk_label[i]),
    sprintf('p1 <- p1 + scale_color_iterm("%s")', pal_name[i]),
    sprintf('p2 <- p2 + scale_fill_iterm("%s")', pal_name[i]),
    "grid.arrange(p1, p2, ncol = 2)",
    "```",
    ""
  )
}

writeLines(content, "_palettes.qmd")

cat(sprintf("Wrote %d palettes to _palettes.qmd\n", length(pal_name)))
