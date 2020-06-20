# source("code/generate-chapter-code.R")
# based on https://github.com/geocompr/geocompkg/blob/master/R/generate-chapter-code.R
library(tidytext)
library(dplyr)
library(ggplot2)
library(forcats)

# Generate a data frame of book statistics per chapter
generate_book_stats = function(dir = ".") {
  rmd_files = list.files(path = dir, pattern = ".Rmd")
  rmd_files = rmd_files[grep("[0-9]", rmd_files)]
  chapters = lapply(rmd_files, readLines)
  chapters = lapply(chapters, function(x)
    data_frame(line = 1:length(x), text = x))
  # chapters[[1]] %>%
  #   unnest_tokens(words, text)
  n_words = sapply(chapters, function(x)
    nrow(unnest_tokens(x, words, text)))
  chapter = 1:length(n_words)
  date = Sys.Date()
  data_frame(n_words, chapter, date)
}

book_stats = readr::read_csv("extdata/word-count-time.csv", col_types = ("iiDd"))

# to prevent excessive chapter count
if (Sys.Date() > max(book_stats$date) + 5) {
  book_stats_new = generate_book_stats()
  book_stats = bind_rows(book_stats, book_stats_new)
  readr::write_csv(book_stats, "extdata/word-count-time.csv")
}

book_stats$chapter = formatC(
  book_stats$chapter,
  width = 2,
  format = "d",
  flag = "0"
)
book_stats$chapter = fct_rev(as.factor(book_stats$chapter))
book_stats$n_pages = book_stats$n_words / 300

ggplot(book_stats) +
  geom_area(aes(date, n_pages, fill = chapter), position = "stack") +
  ylab("Estimated number of pages") +
  xlab("Date") +
  scale_x_date(
    date_breaks = "2 month",
    limits = c(min(book_stats$date) - 100, as.Date("2022-10-01")),
    date_labels = "%b %Y"
  ) +
  coord_cartesian(ylim = c(0, 350))
