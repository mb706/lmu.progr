





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


if (test(
    arg = 1,
    arh = 2
)) {
  return(FALSE)
}

function (n = test(
    arg = 1,
    arh = 2
  )) {
  return(FALSE)
}


# - "complex" espressions vs. "simple" expression. Complex if:
#   - control statements: if, for, while, repeat, function
#   - [redundant] anything involving curly braces
#   - function calls with more than one argument if any argument is named
#   - [redundant?] something containing complex expressions
#   - [redundant] something containing open form
#   - something involving multiple lines
# - "singular" vs. "grouped" positioning: whether a function argument is on its own line
#   - complex expressions are always singular
#   - expressions with non-standard operator spacing is singular
#   - [redundant] open forms are always singular
#     - open forms opening and closing part can be grouped
# - "open" form vs. "closed" form: position of opening and closing braces
#   - what is open / closed?
#     - curly braces always have open form
#     - function calls may have open form
#     - function calls must have open form if they involve singular expressions
#     - everything else: parens in if, while, for loops, function definitions and arithmetic grouping must have closed form
#       - but may have content that has open form
#   - what does it look like?
#     - closing paren on its own line
#     - or together with other closing parens (not braces) if it is (1) the last enclosed expression and (2) starts on the first line of the enclosed expression
# - indentation
#   - function call parens and braces lift indentation level
#   - expression continuation
#   - control statements do not affect indentation; if they continue to the next line they must have braces



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


# good
list(1, 2, 3)
list(1, 2, x = 3)
list(1, 2,
  3, 4, 5)
list(x = 1, y = 2)

list(c(1, 1, 1))
list(1 + 2)
list(1 + 2, 3 + 4)
# bad
list(1, 2, 3
)
list(1 +
  2)
list(c(a = 1, 2, 3))
list(if (1 == 1) 1 else 2)
list(repeat TRUE)
list(while (1 == 0) TRUE)
list(for (i in 0:10) i)
list({ 1 })


#

SYMBOL  # also: CONST
{ EXPR ; EXPR ; EXPR }
( EXPR )
-EXPR
~EXPR
EXPR %operator% EXPR
EXPR <- EXPR
function (SYMBOL_FORMALS, SYMBOL_FORMALS = EXPR) FUNCTION
EXPR (SYMBOL_SUB, SYMBOL_SUB = EXPR, )
if ( EXPR ) EXPR
if ( EXPR ) EXPR else EXPR
for ( SYMBOL in EXPR ) EXPR
while ( EXPR ) EXPR
repeat EXPR
EXPR [[ SYMBOL_SUB, SYMBOL_SUB = EXPR, ]]
EXPR [ SYMBOL_SUB, SYMBOL_SUB = EXPR, ]




# RULES
# --> paren that is on its own line closes at least one
# -->








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

# TODO: check that spaces before comments are ignored
# TODO: check that camelCase objects are functions, and that
# CamelCase objects return S3-objects of the same class OR are R6-classes


#
