# TODO: space after comment

commentLinter <- function(source_file) {
  comment.ids <- ids_with_token(source_file, "COMMENT")
  spaces.before.lints <- lapply(comment.ids, function(id) {
    token <- with_id(source_file, id)
    beginning <- substr(source_file$lines[[as.character(token$line1)]], 1, token$col1 - 1)
    match <- re_matches(beginning, rex(anything, non_space), locations = TRUE)$end
    if (is.na(match)) return(NULL)  # entire line is empty
    if (token$col1 - 3 != match) {
      Lint(filename = source_file$filename, line_number = token$line1,
        column_number = match + 1, type = "style",
        message = "Inline-Comment should be preceded by exactly two spaces",
        line = source_file$lines[[as.character(token$line1)]],
        ranges = list(c(match + 1, token$col1 - 1)),
        linter = "comment_linter")
    }
  })
  spaces.after.lints <- lapply(comment.ids, function(id) {
    token <- with_id(source_file, id)
    text <- token$text
    if (!re_matches(text, rex(start, "#", maybe(single_quote), space))) {
      Lint(filename = source_file$filename, line_number = token$line1,
        column_number = token$col1 + 1 + startsWith(text, "#'"), type = "style",
        message = "Comment should always start with # or #' followed by at least one space.",
        line = source_file$lines[[as.character(token$line1)]],
        linter = "comment_linter")
    }
  })
  c(spaces.before.lints, spaces.after.lints)
}
