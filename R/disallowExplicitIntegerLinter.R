# the following is adapted from 'https://github.com/jimhester/lintr', originally under MIT-license by James Hester
# Original file: https://github.com/jimhester/lintr/blob/edb3b12aac25d57759fb20dcd0171ba510d6242f/R/implicit_integer_linter.R
# change: we forbid L, instead of allowing it

disallowExplicitIntegerLinter <- function(source_file) {
  lapply(ids_with_token(source_file, "NUM_CONST"), function(id) {
    token <- with_id(source_file, id)
    if (!(endsWith(token$text, "L"))) return(NULL)
    line_num <- token$line2
    end_col_num <- token$col2
    start_col_num <- token$col1
    Lint(filename = source_file$filename, line_number = line_num,
      column_number = end_col_num, type = "style",
      message = "Integers should be implicit. Don't use the 1L form.",
      line = source_file$lines[[as.character(line_num)]],
      ranges = list(c(start_col_num, end_col_num)),
      linter = "implicit_integer_linter")
  })
}
