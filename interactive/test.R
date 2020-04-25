

x <- function(a, b, c = 1, d = function() NULL, e = 2 + 2) {  # test
  a +  b

  (TRUE)
  {
    TRUE
  }
  -1
  ~1
  !1
  ?lint
  1:10
  y = 1
  x <- y
  y -> x
  x %operator% y
  while (TRUE) {
    break
    next
  }
  for (i in seq(
    1, 2
    )) {

  }

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
  list({
      1
  })
  df <- data.frame(1:10, 2:11)
  df[[1, 1]]
  df[[1, ]]
  df[, 1]
  df[1, 1]
  1 + 2 * (1 + 1)
  (function(x) { })(x=, , , )
  (function() NULL)()
}
