context("disallowExplicitIntegerLinter")


test_that("lints correctly", {
# the following is adapted from 'https://github.com/jimhester/lintr', originally under MIT-license by James Hester
# Original file:
# https://github.com/jimhester/lintr/blob/edb3b12aac25d57759fb20dcd0171ba510d6242f/tests/testthat/test-implicit_integer_linter.R

  linter <- disallowExplicitIntegerLinter
  msg <- escape("Integers should be implicit. Don't use the 1L form.")

  expect_lint("x <<- 1", NULL, linter)
  expect_lint("1.0/-Inf -> y", NULL, linter)
  expect_lint("y <- 1+i", NULL, linter)
  expect_lint("y <- 1L+i", list(message=msg, line_number=1L, column_number=7L), linter)
  expect_lint("z <- 1e5L", list(message=msg, line_number=1L, column_number=9L), linter)
  expect_lint("cat(1L:n)", list(message=msg, line_number=1L, column_number=6L), linter)
  expect_lint("552L^9L",
              list(
                list(message=msg, line_number=1L, column_number=4L),
                list(message=msg, line_number=1L, column_number=7L)
              ),
              linter)

})
