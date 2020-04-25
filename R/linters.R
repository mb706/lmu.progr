

# "you did X, I want you to do Y instead because it is cleaner"
linters.best.practices <- list(
    T_and_F_symbol_linter,
    nonportable_path_linter,
    absolute_path_linter,
    seq_linter,
    unneeded_concatenation_linter)

# "you did X, I want you to do Y instead because I say so"
style.linters <- list(
    assignment_linter,
    semicolon_terminator_linter,
    single_quotes_linter,
    extraction_operator_linter = extractionOperatorLinter,
    disallow_explicit_integer_linter = disallowExplicitIntegerLinter,
    object_name_linter(c("dotted.case", "camelCase", "CamelCase")))

linters.functions.limit.import <- list(
    undesirable_function_linter(list(
      attach = "access elements directly",
      library = NA,
      require = NA,
      setwd = "access files by paths relative to base directory",
      .libPaths = NA)),
    undesirable_operator_linter(list(
      `:::` = NA,
      `::` = NA,
      `<<-` = NA,
      `->>` = NA,
      `->` = "use <- only")))

linters.functions <- list(
    undesirable_function_linter(list(
      setwd = "access files by paths relative to base directory",
      .libPaths = NA)),
    undesirable_operator_linter(list(
      `<<-` = NA,
      `->>` = NA,
      `->` = "use <- only")))

# "this looks like an error to me"
static.check.linters <- list(
    object_usage_linter,
    equals_na_linter,
    cyclocomp_linter(25))

space.linters <- list(
    paren_brace_linter,
    commas_linter,
    spaces_left_parentheses_linter,
    open_curly_linter(TRUE),
    closed_curly_linter(TRUE),
    spaces_inside_linter,
    function_left_parentheses_linter,
    infix_spaces_linter,
    line_length_linter(120),
    no_tab_linter,
    trailing_blank_lines_linter,
    trailing_whitespace_linter,
    comment_linter = commentLinter,
    indentation_linter = indentationLinter)

#' @export
linters.all.limit.import <- c(linters.best.practices, style.linters,
  linters.functions.limit.import, static.check.linters, space.linters)

#' @export
linters.all.unlimited <- c(linters.best.practices, style.linters,
  linters.functions, static.check.linters, space.linters)
