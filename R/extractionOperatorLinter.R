
# the following is adapted from 'https://github.com/jimhester/lintr', originally under MIT-license by James Hester
# Original file: https://github.com/jimhester/lintr/blob/edb3b12aac25d57759fb20dcd0171ba510d6242f/R/extraction_operator_linter.R
# change: allow `$`
extractionOperatorLinter <- function (source.file)  {
  tokens <- source.file$parsed_content
  tokens <- source.file$parsed_content <- tokens[tokens$token != "expr", ]
  lapply(ids_with_token(source.file, c("'['"), fun = `%in%`),
    function(token_num) {
      if (is_bracket_extract(token_num, tokens)) {
        token <- with_id(source.file, token_num)
        start_col_num <- token$col1
        end_col_num <- token$col2
        line_num <- token$line1
        line <- source.file$lines[[as.character(line_num)]]
        Lint(filename = source.file$filename, line_number = line_num,
          column_number = start_col_num, type = "warn",
          message = sprintf("Use `[[` instead of `%s`  to extract an element.",
            token$text), line = line, linter = "modified_extraction_operator_linter",
          ranges = list(c(start_col_num, end_col_num)))
      }
  })
}
