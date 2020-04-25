context("commentLinter")

test_that("lints correctly", {

  msgA <- escape("Inline-Comment should be preceded by exactly two spaces")
  msgB <- escape("Comment should always start with # or #' followed by at least one space.")
  linter <- commentLinter

  expect_lint("# beginning
   # some more beginning
   if (x == 0) {  # doing things right
# no problem here
    # move along
  FALSE  # still right
  }", NULL, linter)

  expect_lint("test # problem", list(message=msgA, line_number=1, column_number=5), linter)
  expect_lint("test# problem", list(message=msgA, line_number=1, column_number=5), linter)
  expect_lint("test   # problem", list(message=msgA, line_number=1, column_number=5), linter)
  expect_lint("test  #problem", list(message=msgB, line_number=1, column_number=8), linter)
  expect_lint("test   #problem", list(
      list(message=msgA, line_number=1, column_number=5),
      list(message=msgB, line_number=1, column_number=9)
    ), linter
  )



})
