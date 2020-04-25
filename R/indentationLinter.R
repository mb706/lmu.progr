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


# make sure complex expressions and expressions with nonstandard operator spacing are singular
singularExpressionLinter <- function(source_file) {
  # get all non-singular expressions
  pc <- source_file$parsed_content
  pc$row <- seq_len(nrow(pc))
  funparens <- ids_with_token(source_file, c("'['", "LBB"), fun = `%in%`)
  # `[` and `[[` are always funparens. `(` is a funparent if preceded by `expr` (invocation) or FUNCTION (fun def)
  funparens <- c(funparens, Filter(
      function(id) pc$token[pc$parent[[id]] == pc$parent] %in% c("expr", "FUNCTION"),
      ids_with_token(source_file, "(")
  ))

  id.eqformals <- ids_with_token(source_file, c("EQ_FORMALS", "EQ_SUB"), fun = `%in%`)
  appendrows <- vector("list", length(id.eqformals))
  maxid <- max(pc$id)
  maxrow <- nrow(pc)
  for (iter in seq_along(id.eqformals)) {
    # EQ_FORMALS is always immediately preceded by SYMBOL_FORMALS
    # and succeeded (if not immediately) by `expr`
    # we turn the SYMBOL_FORMALS + EQ_FORMALS + expr into its own `expr`-node
    curid <- id.eqformals[[iter]]

    curparent <- pc$parent[[curid]]
    previd <- curid - 1
    nextid <- c(which(pc$parent == curparent & pc$row > curid), curid)[1]  # fall back to curid in case we have call(x = )
    if (pc$token[[nextid]] != "expr") {
      nextid <- curid  # in case we have call(x = , y = )
    }

    stopifnot(pc$token[[previd]] %in% c("SYMBOL_SUB", "SYMBOL_FORMALS"))

    pc$parent[[previd]] <- maxid + iter
    pc$parent[[curid]] <- maxid + iter
    pc$parent[[nextid]] <- maxid + iter

    appendrows[[iter]] <- list(line1 = pc$line1[[previd]], col1 = pc$col1[[previd]],
      line2 = pc$line2[[nextid]], col2 = pc$col2[[nextid]], id = maxid + iter,
      parent = curparent, token = "expr", terminal = FALSE, text = "", row = maxrow + iter)
  }
  names(appendrows) <- maxid + seq_along(id.eqformals)

  pc <- do.call(rbind, c(list(pc), appendrows))
  pc <- source_file$parsed_content <- pc[order(pc$line1, pc$col1, pc$line2, pc$col2, pc$id), ]
  pc$row <- seq_len(nrow(pc))


  # complex expressions:
  #  - if, for, while, repeat, function
  #  - curly braces
  #  - multi-line expressions
  #  - if we wanted to allow non-braced control statements we would remove everything but `"'{'"`
  pc$is.complex <- pc$token %in% c("FUNCTION", "IF", "WHILE", "REPEAT", "FOR", "'{'") | (pc$line1 != pc$line2)
  #  - AND: function calls with more than one argument if any is named (which is what follows)


  named.funarg.expr <- match(pc$parent[pc$token == "EQ_SUB"], pc$id)  # id of a function argument called like (name = value)
  stopifnot(all(pc$token[named.funarg.expr] == "expr"))

  named.funarg.expr.multi <- Filter(x = named.funarg.expr, f = function(fae) {
    sum(pc$parent == pc$parent[[fae]]) <= 4  # containing just `expr`, `(`, `<the named argument>`, `)` --> not complex
  })
  complex.funcalls <- match(pc$parent[named.funarg.expr.multi], pc$id)

  pc$is.complex[complex.funcalls] <- TRUE

  # look for nonstandard operator spacing, i.e. more than one space
  for (operator.id in which(pc$token %in% operators)) {
    surrounding <- pc[pc$parent == pc$parent[[operator.id]] & pc$id != operator.id, ]
    curpar <- pc[operator.id, ]

    if (any(c(curpar$col1 - surrounding$col2, surrounding$col1 - curpar$col2) > 2)) {
      pc$is.complex[[operator.id]] <- TRUE
    }
  }

  # propagate complex up the tree
  complexify <- which(pc$is.complex)
  root <- match(0, pc$parent)
  while (length(complexify)) {
    print(complexify)
    complexify <- match(pc$parent[complexify], pc$id, root)  # make root node point to itself; gets swallowed by following line
    complexify <- complexify[!pc$is.complex[complexify]]  # if parent is already marked complex we don't need to go further
    pc$is.complex[complexify] <- TRUE
  }

  pc
#  singular.obligate <- Filter(function(id) {
#      if (pc$line1[[id]] != pc$line2[[id]]) return(TRUE)  # multiline --> must be singular
#  }, parenexpressions)

}



operators <- c("':'", "'+'", "'-'", "'*'", "'/'", "'^'", "SPECIAL",
  "'%'", "'~'", "'?'", "LT", "LE", "EQ", "NE", "GE", "GT", "AND", "OR", "AND2", "OR2",
  "LEFT_ASSIGN", "RIGHT_ASSIGN", "EQ_ASSIGN", "EQ_SUB", "EQ_FORMALS", "'@'", "'$'")
