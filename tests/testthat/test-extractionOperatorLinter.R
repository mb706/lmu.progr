context("extractionOperatorLinter")

test_that("lints correctly", {
# the following is adapted from 'https://github.com/jimhester/lintr', originally under MIT-license by James Hester
# Original file:  https://github.com/jimhester/lintr/blob/edb3b12aac25d57759fb20dcd0171ba510d6242f/tests/testthat/test-extraction_operator_linter.R
  msg <- escape("Use `[[` instead of `[` to extract an element.")
  linter <- extractionOperatorLinter

  expect_lint("x[[1]]", NULL, linter)
  expect_lint("x[-1]", NULL, linter)
  expect_lint("x[[1]]", NULL, linter)
  expect_lint("x[-1]", NULL, linter)
  expect_lint("x[1, 'a']", NULL, linter)
  expect_lint("self$a", NULL, linter)
  expect_lint(".self $\na", NULL, linter)
  expect_lint("x$a", NULL, linter)
  expect_lint("x $\na", NULL, linter)
  expect_lint("x[NULL]", list(message=msg, line_number=1L, column_number=2L), linter)
  expect_lint("x[++ + 3]", list(message=msg, line_number=1L, column_number=2L), linter)

  expect_lint("c(x['a'], x [ 1 ])", list(
      list(message=msg, line_number=1L, column_number=4L),
      list(message=msg, line_number=1L, column_number=13L)
    ), linter
  )


})
