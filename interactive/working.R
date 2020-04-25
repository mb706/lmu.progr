
devtools::document()
devtools::load_all()



debugonce(extractionOperatorLinter)


testthat::test_package("progr.lmu")


source_file <- lintr:::get_source_expressions("interactive/test.R")$expressions[[1]]

source_file$parsed_content

singularExpressionLinter(source_file)



getParseData("interactive/test2.R")
