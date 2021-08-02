
check_installed <- function(pkgs) {
  inst <- vapply(pkgs, requireNamespace, quietly = TRUE, FUN.VALUE = logical(1))
  if (all(inst)) {
    return()
  }
  stop("Must install the following packages to use this function:\n",
       paste0("* ", pkgs[!inst], "\n"), call. = FALSE)
}

use_template <- function(...) {
  usethis::use_template(..., package = "jdtdown")
}

github_url <- utils::getFromNamespace("github_url", "usethis")
project_name <- utils::getFromNamespace("project_name", "usethis")
use_dot_github <- utils::getFromNamespace("use_dot_github", "usethis")
