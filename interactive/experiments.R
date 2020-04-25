

devtools::load_all("rlib_styler")


tidyverse_style()


styler::start_comments_with_space


tidyverse_style()


create_style_guide


x <- 1
y <- 2

lst(x, y)

default_style_guide_attributes


initialize_newlines

lead






create_style_guide(
  # transformer functions
  initialize =
  line_break =
  space =
  token =
  indention =
  use_raw_indention =
  reindention =
  style_guide_name = "ProgrLMU",
  style_guide_version = 0.1)


x <- list(a = 1, b = 3, n = 100,
  x = list(a = 1, x = 9, b = 2, xaf = 100, c = 3),
  y = list(n = 9),
  zz1 = 199
)

x <- callMe(a = 1, b = 3,
  xx = callYou(1, 2, 3),
  yy = callMeMaybe(
    a = 1,
    another_argument = 100
  ),
  n = if (x) TRUE else {
    cat("y\n")
    FALSE
  }, z = 1, zz = 2, zzz = 3
)

x = list(list(list(
      n = 1
)))


# - "simple": no control expressions (if, for, while, repeat), no curly braces, no function calls with more than one argument if any argument is named,
#   nothing containing a complex expression, no "open" expression, no multiline expression
#   - parentheses or brackets containing only simple expressions may be "open" but are usually "closed"
#     - "open": closing paren on its own line
# - complex expressions go on their own line
#   - exception: complex expression may start at the first line if the opening paren (f-call) or opening brace is the last item on the line
#     - in this case if this complex expression is the last argument and has nothing following it then its paren is on the same line as the closing paren one level up and gets that parens' indentation
#       - this rule is applied recursively
#
# - indentation: once per function call. treat single expressions as function calls themselves: -> indent on newline
# - parens of non-functioncalls must not be alone

zz = 1 + 2 * (1 + 3 * (
  1 + 4 * 5))


nn <- list(x = 1, y = 2,
  z = 3,
  zz = 1 + 2 + f(
      3 + 4
  ),
  zz2 = 1 + 2 + f(
      3 + 4
    ) + 1

)

# newline rules
# at least one empty line between function defs
# up to two newlines allowed within function defs
# up to one newline allowed within calls






x = a + b + c
x = a + b +
  c
x = a + (
  b + c)
x = a +
  (b + c)
x = a +
  (b + c) +
  d

