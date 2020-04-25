# TODO: space after comment

commentLinter <- function(source_file) {
  lapply(ids_with_token(source_file, "COMMENT"), function(id) {
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
}
