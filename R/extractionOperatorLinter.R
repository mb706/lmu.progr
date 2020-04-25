
# the following is adapted from 'https://github.com/jimhester/lintr', originally under MIT-license by James Hester
# Original file: https://github.com/jimhester/lintr/blob/edb3b12aac25d57759fb20dcd0171ba510d6242f/R/extraction_operator_linter.R
# change: allow `$`
extractionOperatorLinter <- function (source.file)  {
  tokens <- source.file$parsed_content
  tokens <- source.file$parsed_content <- tokens[tokens$token != "expr", ]
  lapply(ids_with_token(source.file, "'['"),
    function(token.num) {
      if (isBracketExtract(token.num, tokens)) {
        token <- with_id(source.file, token.num)
        start.col.num <- token$col1
        end.col.num <- token$col2
        line.num <- token$line1
        line <- source.file$lines[[as.character(line.num)]]
        Lint(filename = source.file$filename, line_number = line.num,
          column_number = start.col.num, type = "warn",
          message = sprintf("Use `[[` instead of `%s` to extract an element.",
            token$text), line = line, linter = "modified_extraction_operator_linter",
          ranges = list(c(start.col.num, end.col.num)))
      }
  })
}


isBracketExtract <- function(token.id, tokens) {
  # The sequence "[" + zero or more "+" symbols + a constant + "]".
  inside.tokens <- getTokensInParens(token.id, tokens)
  if (all(is.na(inside.tokens))) {
    FALSE
  } else {
    start_line <- 1L
    while (inside.tokens[start_line, "text"] == "+") {
      start_line <- start_line + 1L
    }
    inside.tokens <- inside.tokens[start_line:nrow(inside.tokens), ]
    nrow(inside.tokens) == 1L &&
      inside.tokens[1L, "token"] %in% c("STR_CONST", "NUM_CONST", "NULL_CONST")
  }
}

getTokensInParens <- function(token.id, tokens) {
  open.token <- tokens[token.id, ]
  countertoken.text.expected <- c("[" = "]", "{" = "}", "(" = ")", "[[" = "]]")[[open.token$text]]
  countertoken.id <- tail(which(tokens[, "parent"] == open.token$parent), 1)
  countertoken.text <- tokens[countertoken.id, "text"]
  if (countertoken.text != countertoken.text.expected) {
    return(NA)
  }
  tokens[
    if (token.id + 1 == countertoken.id) integer(0) else seq(token.id + 1, countertoken.id - 1),
  ]
}





