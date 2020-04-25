#' @import rex
"_PACKAGE"

.onLoad = function(libname, pkgname) {
  backports::import(pkgname)
}
