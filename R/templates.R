#' Helpers for project setup with jdtdown
#'
#' These helper are mostly inspired by the one in **usethis** from the tidyverse
#' team and are useful to setup a new pkgdown project with **jdtdown**
#'
#' @details
#'
#' + `use_coc()`: put _CODE\_OF\_CONDUCT.md_ in `.github/` directory setting the
#' contact email to jdt's.
#'
#' + `use_contributing()`: Add a _CONTRIBUTING.md_ file in `.github/` following
#' a template in **jdtdown**. Inspired by `usethis::use_tidy_contributing()`.
#'
#' + `use_readme_jdt()`: Add a _README.md_ file in the structure used by JDT's
#' packages.
#'
#' + `use_gha_pkgdown()`: Add a GitHub Actions workflow for deploying the
#' 'pkgdown' site and copy terminal code necessary to create an orphan
#' 'gh-pages' branch.
#'
#' @name setup-helpers
#'
#'
NULL

#' @export
#' @rdname setup-helpers
use_coc <- function() {
  check_installed("usethis")
  use_dot_github()
  data <- list(Package = project_name())
  use_template("CODE_OF_CONDUCT.md",
               file.path(".github", "CODE_OF_CONDUCT.md"),
               data = data)
}

#' @export
#' @rdname setup-helpers
use_contributing <- function() {
  check_installed("usethis")
  use_dot_github()
  data <- list(Package = project_name())
  use_template("CONTRIBUTING.md",
               file.path(".github", "CONTRIBUTING.md"),
               data = data)
}

#' @export
#' @rdname setup-helpers
use_readme_jdt <- function() {
  check_installed("usethis")
  data <- list(Package = project_name())
  use_template("jdt-readme.md",
               file.path("README.md"),
               data = data)
}

#' @export
#' @param config_file Path to the pkgdown yaml config file - could be set to be
#'   `pkgdown/` subfolder.
#' @param destdir Target directory for pkgdown docs. By default, it will be in
#'   `docs` sub directory for packages using **jdtdown**.
#' @rdname setup-helpers
use_jdtdown <- function(config_file = "_pkgdown.yml", destdir = "docs") {
  check_installed("usethis")
  if (!file.exists(usethis::proj_path("README.md"))) use_readme_jdt()
  usethis::ui_info("Creating assets for using jdtdown templated pkgdown website.")
  # Create destdir if it does not exist
  usethis::use_directory(destdir)

  # Add pkgdown config to use with jdtdown
  usethis::ui_info("Adding pkgdown config for jdtdown-like project.")
  data <- list(Package = project_name(),
               destdir = destdir,
               github_url = github_url())
  use_template("pkgdown-config.yaml", "_pkgdown.yml", data = data)
  usethis::use_build_ignore(c(config_file, destdir, "pkgdown"))
  usethis::use_git_ignore(destdir)

  # Add folder for articles
  usethis::ui_info("Adding articles subdir in 'vignettes/' folder.")
  articles_dir <- "vignettes/articles"
  usethis::use_directory(articles_dir)
  usethis::use_build_ignore(articles_dir)

  # Add vignette used as Get Started.
  usethis::ui_info("Adding package named vignette for Get Started section.")
  use_template("vignette-intro.Rmd",
               intro_rmd <- file.path("vignettes", paste0(data$Package, ".Rmd")),
               data = data, ignore = FALSE, open = FALSE)

  # Add Code Of Conduct and Contributing
  usethis::ui_info("Adding more assets if missing")
  use_coc()
  use_contributing()

  # TODOS
  usethis::ui_info("What is left to be done ?")
  usethis::ui_todo("Add a logo in {usethis::ui_field('man/figures/logo.png')}. \\
                   with {usethis::ui_code('usethis::use_logo()')}.")
  usethis::ui_todo("Check and adapt configuration in {usethis::ui_field(config_file)}.")
  usethis::ui_todo("Add learning resources to  {usethis::ui_field(intro_rmd)} for the Get Started section.")
  usethis::ui_todo("Add github action workflow with {usethis::ui_code('jdtdown::use_gha_pkgdown()')}")
}

#' @export
#' @rdname setup-helpers
use_gha_pkgdown <- function() {
  check_installed("usethis")
  use_dot_github()
  template <- find_template("pkgdown-gha.yaml", package = "jdtdown")
  usethis::use_github_action(url = template, save_as = "pkgdown.yaml", ignore = TRUE, open = FALSE)
  usethis::ui_todo("Create a gh-pages branch by typing the following into the terminal:
                 {usethis::ui_code_block(\"
                   git checkout --orphan gh-pages
                   git rm -rf .
                   git commit --allow-empty -m 'Initial gh-pages commit'
                   git push origin gh-pages
                   git checkout master
                   \", copy = TRUE)}")
  usethis::ui_info("For more information on the above terminal code, or deploying to GitHub Pages, visit
                   {usethis::ui_value('<https://orchid00.github.io/actions_sandbox/websites-using-pkgdown-bookdown-and-blogdown.html>')}")
  usethis::ui_todo("Be sure to register the {usethis::ui_field('CNAME')} for {project_name()}.jdtrat.com/ on {usethis::ui_value('<https://netlify.com/>')}.")
}
