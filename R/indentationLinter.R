# TODO this is not yet done


indentationLinter <- function(source_file) {
  if (!"full_parsed_content" %in% names(source_file)) return(NULL)  # only operate on globally parsed file object
  opening_parens <- c("'['", "'{'", "'('")
  closing_parens <- c("']'", "'}'", "')'")
  level_down <- which(source_file$full_parsed_content$token %in% opening_parens)
  level_up <- which(source_file$full_parsed_content$token %in% closing_parens)
  downs <- table(source_file$full_parsed_content[level_down, "line1"])
  ups <- table(source_file$full_parsed_content[level_up, "line1"])
  linenames <- as.character(seq_along(source_file$file_lines))
  indentmat <- cbind(downs = downs[linenames], ups = ups[linenames])
  indentmat[is.na(indentmat)] <- 0
  expected_indent <- cumsum(c(0, 2 * (indentmat[, "downs"] - indentmat[, "ups"])))
  expected_indent <- expected_indent[-length(expected_indent)]
  startparens <- rex::re_matches(source_file$file_lines, "^[[:space:]]*([})\\]][[:space:]})\\]]*)")[[1]]
  startparens <- trimws(startparens)
  startparen_counts <- sapply(strsplit(startparens, "[]})]"), function(x) if (is.na(x[1])) 0 else length(x))
  expected_indent <- expected_indent - 2 * startparen_counts
  real_indent <- re_matches(source_file$file_lines, rex(non_space), locations = TRUE)$end - 1
  from_problem = pmin(real_indent, expected_indent) + 1
  to_problem = pmax(real_indent, expected_indent)
  lapply(which(real_indent != expected_indent), function(id) {
    Lint(filename = source_file$filename, line_number = id,
      column_number = real_indent[id] + 1, type = "style",
      message = sprintf("Indentation should be %s spaces here but is %s spaces", expected_indent[id], real_indent[id]),
      line = source_file$file_lines[id], ranges = list(c(from_problem[id], to_problem[id])),
      linter = "indentation_linter")
  })
}
