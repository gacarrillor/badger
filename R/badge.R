##' badge of bioconductor release version
##'
##'
##' @title badge_bioc_release
##' @param pkg package. If \code{NULL} (the default) the package
##'   is determined via the DESCRIPTION file.
##' @param color badge color
##' @return badge in markdown syntax
##' @export
##' @author Guangchuang Yu
##' @importFrom rvcheck check_bioc
badge_bioc_release <- function(pkg = NULL, color) {
    pkg <- currentPackageName(pkg)
    v <- check_bioc(pkg)$latest_version
    url <- paste0("https://www.bioconductor.org/packages/", pkg)
    badge_custom("release version", v, color, url)
}


##' badge of devel version
##'
##'
##' @title badge_github_version
##' @param pkg package. If \code{NULL} (the default) the package
##'   is determined via the DESCRIPTION file.
##' @param color badge color
##' @return badge in markdown syntax
##' @export
##' @author Guangchuang Yu
badge_github_version <- function(pkg = NULL, color) {
    pkg <- currentGitHubRef(pkg)
    v <- ver_devel(pkg)
    url <- paste0("https://github.com/", pkg)
    badge_custom("devel version", v, color, url)
}

##' badge of devel version
##'
##'
##' @title badge_devel
##' @inheritParams badge_github_version
##' @export
##' @return badge in markdown syntax
badge_devel <- badge_github_version

##' get devel version number of specific package
##'
##'
##' @title ver_devel
##' @param pkg package. If \code{NULL} (the default) the package
##'   is determined via the DESCRIPTION file.
##' @return devel version
##' @author Guangchuang
##' @importFrom rvcheck check_github
##' @export
ver_devel <- function (pkg = NULL) {
    ## flag <- FALSE
    ## if (file.exists("DESCRIPTION")) {
    ##     x <- readLines("DESCRIPTION")
    ##     flag <- TRUE
    ## } else if (file.exists("../DESCRIPTION")) {
    ##     x <- readLines("../DESCRIPTION")
    ##     flag <- TRUE
    ## }
    ## if (flag) {
    ##     y <- x[grep("^Version", x)]
    ##     v <- sub("Version: ", "", y)
    ##     if ((as.numeric(gsub("\\d+\\.(\\d+)\\.\\d+", "\\1", v))%%2) == 1) {
    ##         return(v)
    ##     }
    ## }
    pkg <- currentGitHubRef(pkg)
    ver <- tryCatch(desc::desc_get_field("Version"), error = function(e) NULL)
    if (is.null(ver ))
        ver <- check_github(pkg)$latest_version
    return(ver)
}

##' badge of bioconductor download number
##'
##'
##' @title badge_bioc_download
##' @param pkg package. If \code{NULL} (the default) the package
##'   is determined via the DESCRIPTION file.
##' @param by one of total or month
##' @param color badge color
##' @param type one of distinct and total
##' @return badge in markdown syntax
##' @export
##' @author Guangchuang Yu
##' @importFrom dlstats bioc_stats
badge_bioc_download <- function(pkg = NULL, by, color, type="distinct") {
    pkg <- currentPackageName(pkg)
    type <- match.arg(type, c("distinct", "total"))
    dl <- "Nb_of_downloads"
    if (type == "distinct")
        dl <- "Nb_of_distinct_IPs"

    nb <- tryCatch(bioc_stats(pkg)[, dl], error=function(e) NULL)

    if (is.null(nb)) {
        res <- "NA"
    } else if (by == "total") {
        res <- sum(nb)
    } else if (by == "month") {
        res <- nb[length(nb) -1]
    }
    res <- paste0(res, "/", by)

    url <- paste0("https://bioconductor.org/packages/stats/bioc/", pkg)
    badge_custom("download", res, color, url)
}

##' official Bioconductor download badge (download ranking)
##'
##'
##' @title badge_bioc_download_rank
##' @rdname biocRanking
##' @param pkg package. If \code{NULL} (the default) the package
##'   is determined via the DESCRIPTION file.
##' @return bioc download ranking badge
##' @export
##' @author guangchuang yu
badge_bioc_download_rank <- function(pkg = NULL) {
    pkg <- currentPackageName(pkg)
    paste0("[![download](http://www.bioconductor.org/shields/downloads/release/",
           pkg, ".svg)](https://bioconductor.org/packages/stats/bioc/", pkg, ")")

}

##' @rdname biocRanking
##' @export
badge_download_bioc <- badge_bioc_download_rank

##' doi badge
##'
##'
##' @title badge_doi
##' @param doi doi
##' @param color color
##' @return badge
##' @author Guangchuang
##' @export
##' @examples
##' badge_doi("10.1111/2041-210X.12628", "green")
badge_doi <- function(doi, color) {
    url <- paste0("https://doi.org/",doi)
    badge_custom("doi", doi, color, url)
}

##' custom badge
##'
##'
##' @title badge_custom
##' @param x field 1
##' @param y field 2
##' @param color color
##' @param url optional url
##' @return customize badge
##' @author Guangchuang Yu
##' @export
badge_custom <- function(x, y, color, url=NULL) {
    x <- gsub(" ", "%20", x)
    y <- gsub(" ", "%20", y)
    x <- gsub('-', '--', x)
    y <- gsub('-', '--', y)
    badge <- paste0("![](https://img.shields.io/badge/", x, "-", y, "-", color, ".svg)")
    if (is.null(url))
        return(badge)

    paste0("[", badge, "](", url, ")")
}

##' altmetric badge
##'
##'
##' @title badge_altmetric
##' @param id altmetric id
##' @param color color of badge
##' @return badge in markdown syntax
##' @author Guangchuang
##' @examples
##' \dontrun{
##' badge_altmetric("2788597", "blue")
##' }
##' @export
badge_altmetric <- function(id, color) {
    url <- paste0("https://www.altmetric.com/details/", id)
    x <- readLines(url)
    score <- gsub("^.*score=(\\d+)\\D+.*$", '\\1', x[grep("style=donut&score=", x)])
    badge_custom("Altmetric", score, color, url)
}

##' SCI citation badge
##'
##'
##' @title badge_sci_citation
##' @param url Web of Science url
##' @param color color of badge
##' @return badge in markdown syntax
##' @author Guangchuang
##' @export
badge_sci_citation <- function(url, color) {
    x <- suppressWarnings(readLines(url))
    cites <- sub("\\D+(\\d+)\\D+", "\\1", x[grep("Times Cited$", x)])
    badge_custom("cited in Web of Science Core Collection", cites, color, url)
}

##' lifecycle badge
##'
##'
##' @title badge_lifcycle
##' @param stage lifecycle stage See
##'   \href{https://lifecycle.r-lib.org/articles/stages.html}{https://lifecycle.r-lib.org/articles/stages.html}
##' @param color color of the badge. If missing, the color is determined by the stage.
##' @return badge in markdown syntax
##' @export
##' @author Gregor de Cillia, Waldir Leoncio
badge_lifecycle <- function(stage = "experimental", color = NULL) {
  url <- paste0("https://lifecycle.r-lib.org/articles/stages.html#", stage)
  if (is.null(color)) {
    color <- switch(
      stage,
      stable       = "brightgreen",
      deprecated   = "orange",
      superseded   = "blue",
      experimental = "orange",
      stop("invalid stage: ", stage)
    )
  }
  badge_custom("lifecycle", stage, color, url)
}

##' repostatus.org badge
##'
##'
##' @title badge_repostatus
##' @param status project status (Concept, WIP, Suspended, Abandoned, Active,
##' Inactive, Unsupported, Moved). See
##' \href{https://www.repostatus.org/lifecycle}{https://www.repostatus.org/lifecycle}
##' for more details.
##' @param alt Alternative text
##' @return badge in markdown syntax
##' @export
##' @author Waldir Leoncio
badge_repostatus <- function(status, alt = NULL) {
  status <- tolower(status)
  svg <- paste0("https://www.repostatus.org/badges/latest/", status, ".svg")
  url <- paste0("https://www.repostatus.org/#", status)
  if (is.null(alt)) {
    alt <- switch(
      status,
      concept     = "Concept - Minimal or no implementation has been done yet, or the repository is only intended to be a limited example, demo, or proof-of-concept.",
      wip         = "WIP - Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.",
      suspended   = "Suspended - Initial development has started, but there has not yet been a stable, usable release; work has been stopped for the time being but the author(s) intend on resuming work.",
      abandoned   = "Abandoned - Initial development has started, but there has not yet been a stable, usable release; the project has been abandoned and the author(s) do not intend on continuing development.",
      active      = "Active - The project has reached a stable, usable state and is being actively developed.",
      inactive    = "Inactive - The project has reached a stable, usable state but is no longer being actively developed; support/maintenance will be provided as time allows.",
      unsupported = "Unsupported - The project has reached a stable, usable state but the author(s) have ceased all work on it. A new maintainer may be desired.",
      moved       = "Moved to http://example.com - The project has been moved to a new location, and the version at that location should be considered authoritative.",
      stop("invalid status: ", status)
    )
    alt <- paste("Project Status:", alt)
  }
  badge_out <- paste0("[![", alt, "](", svg, ")](", url, ")")
  if (status == "moved") {
    warning("Please remember to replace 'http://example.com' with the new URL")
    paste(badge_out, "to [http://example.com](http://example.com)")
  } else {
    paste(badge_out)
  }
}


##' last commit badge
##'
##'
##' @title badge_last_commit
##' @param ref Reference for a GitHub repository. If \code{NULL}
##'   (the default), the reference is determined by the URL
##'   field in the DESCRIPTION file.
##' @param branch The GitHub branch. If \code{NULL}
##'   (the default), the default branch is automatically determined.
##' @return badge in markdown syntax
##' @export
##' @author Gregor de Cillia
badge_last_commit <- function(ref = NULL, branch = NULL) {
  ref    <- currentGitHubRef(ref)
  branch <- defaultBranch(branch)
  url    <- paste0("https://github.com/", ref, "/commits/", branch)
  svg    <- paste0("https://img.shields.io/github/last-commit/", ref, ".svg")
  paste0("[![](", svg, ")](", url, ")")
}

##' travis-ci badge
##'
##'
##' @title badge_travis
##' @param ref Reference for a GitHub repository. If \code{NULL}
##'   (the default), the reference is determined by the URL
##'   field in the DESCRIPTION file.
##' @param is_commercial Flag to indicate whether or not to use
##'   https://travis-ci.com
##' @param branch The GitHub branch. If \code{NULL}
##'   (the default), the default branch is automatically determined.
##' @return badge in markdown syntax
##' @export
##' @author Gregor de Cillia
badge_travis <- function(ref = NULL, is_commercial = FALSE, branch = NULL) {
  ref    <- currentGitHubRef(ref)
  branch <- defaultBranch(branch)
  ext    <- ifelse(is_commercial, "com/", "org/")
  svg    <- paste0("https://travis-ci.", ext, ref, ".svg?branch=", branch)
  url    <- paste0("https://travis-ci.", ext, ref)
  paste0("[![](", svg, ")](", url, ")")
}

##' badge of GitHub code size
##'
##'
##' @title badge_code_size
##' @param ref Reference for a GitHub repository. If \code{NULL}
##'   (the default), the reference is determined by the URL
##'   field in the DESCRIPTION file.
##' @return badge in markdown syntax
##' @export
##' @author Gregor de Cillia
badge_code_size <- function(ref = NULL) {
  ref <- currentGitHubRef(ref)
  svg <- paste0("https://img.shields.io/github/languages/code-size/",
                ref, ".svg")
  url <- paste0("https://github.com/", ref)
  placeholder <- "GitHub code size in bytes"
  paste0("[![](", svg, ")](", url, ")")
}

##' badge of CRAN version
##'
##'
##' @title badge_cran_release
##' @param pkg package. If \code{NULL} (the default) the package
##'   is determined via the DESCRIPTION file.
##' @param color color of badge
##' @return badge in markdown syntax
##' @export
##' @author Gregor de Cillia
badge_cran_release <- function(pkg = NULL, color = NULL) {
  pkg <- currentPackageName(pkg)
  svg <- paste0("https://www.r-pkg.org/badges/version/", pkg)
  if (!is.null(color)) {svg <- paste0(svg, "?color=", color)}
  url <- paste0("https://cran.r-project.org/package=", pkg)
  placeholder <- "CRAN link"
  paste0("[![](", svg, ")](", url, ")")
}

##' badge of coveralls code coverage
##'
##'
##' @title badge_coveralls
##' @param ref Reference for a GitHub repository. If \code{NULL}
##'   (the default), the reference is determined by the URL
##'   field in the DESCRIPTION file.
##' @param branch The GitHub branch. If \code{NULL}
##'   (the default), the default branch is automatically determined.
##' @return badge in markdown syntax
##' @export
##' @author Gregor de Cillia
badge_coveralls <- function(ref = NULL, branch = NULL) {
  ref    <- currentGitHubRef(ref)
  branch <- defaultBranch(branch)
  svg    <- paste0(
    "https://coveralls.io/repos/github/", ref, "/badge.svg?branch=", branch
  )
  url    <- paste0("https://coveralls.io/github/", ref)
  paste0("[![](", svg, ")](", url, ")")
}

##' badge of codecov code coverage
##'
##'
##' @title badge_codecov
##' @param ref Reference for a GitHub repository. If \code{NULL}
##'   (the default), the reference is determined by the URL
##'   field in the DESCRIPTION file.
##' @param token Codecov graphing token, needed for private repositories.
##'   It can be obtained at https://codecov.io/gh/USER/REPO/branch/BRANCH/graph/
##' @param branch The GitHub branch. If \code{NULL}
##'   (the default), the default branch is automatically determined.
##' @return badge in markdown syntax
##' @export
##' @author Gregor de Cillia
badge_codecov <- function(ref = NULL, token = NULL, branch = NULL) {
  ref    <- currentGitHubRef(ref)
  branch <- defaultBranch(branch)
  svg    <- paste0(
    "https://codecov.io/gh/", ref, "/branch/", branch, "/graph/badge.svg"
  )
  if (!is.null(token)) {
    svg <- paste0(svg, "?token=", token)
  }
  url <- paste0("https://codecov.io/gh/", ref)
  paste0("[![](", svg, ")](", url, ")")
}

##' badge of CRAN downloads
##'
##'
##' @title badge_cran_download
##' @param pkg package. If \code{NULL} (the default) the package
##'   is determined via the DESCRIPTION file.
##' @param type type of stats. \code{last-month}, \code{last-week} or \code{"grand-total"}
##' @param color color of badge
##' @return badge in markdown syntax
##' @export
##' @author Gregor de Cillia
badge_cran_download <- function(pkg = NULL, type = c("last-month", "last-week", "grand-total"),
                                color = NULL) {
  pkg <- currentPackageName(pkg)
	type <- match.arg(type)
  svg <- paste0("http://cranlogs.r-pkg.org/badges/", type, "/", pkg)
  if (!is.null(color)) {svg <- paste0(svg, "?color=", color)}
  url <- paste0("https://cran.r-project.org/package=", pkg)
  placeholder <- "CRAN link"
  paste0("[![](", svg, ")](", url, ")")
}

##' dependency badge
##'
##' @title badge_depedencies
##' @param pkg package. If \code{NULL} (the default) the package
##'   is determined via the DESCRIPTION file.
##' @return badge in markdown syntax
##' @export
##' @author Dirk Eddelbuettel
badge_dependencies <- function(pkg = NULL) {
    pkg <- currentPackageName(pkg)
    badge <- paste0("https://tinyverse.netlify.com/badge/", pkg)
    url <- paste0("https://cran.r-project.org/package=", pkg)
    placeholder <- "Dependencies"
    paste0("[![", placeholder, "](", badge, ")](", url, ")")
}

##' CRAN checks badge
##'
##' @title badge_cran_checks
##' @param pkg package. If \code{NULL} (the default) the package
##'   is determined via the DESCRIPTION file.
##' @param worst logical; if FALSE (default) return "summary" badge. If TRUE,
##'   return "worst" badge.
##' @return badge in Markdown syntax
##' @export
##' @author Scott Chamberlain (badges API), Maëlle Salmon (function)
badge_cran_checks <- function(pkg = NULL, worst = FALSE) {
  pkg <- currentPackageName(pkg)
  stopifnot(is.logical(worst))
  # badge <- paste0("https://cranchecks.info/badges/summary/", pkg)
  badge <- if (worst) {
    badge <- paste0("https://badges.cranchecks.info/worst/", pkg, ".svg")
  } else {
    badge <- paste0("https://badges.cranchecks.info/summary/", pkg, ".svg")
  }
  url <- paste0("https://cran.r-project.org/web/checks/check_results_",
                pkg, ".html")
  placeholder <- "CRAN checks"
  paste0("[![", placeholder, "](", badge, ")](", url, ")")
}

#' License badge
#'
#' @param license The license to use. If \code{NULL} (the default), the license
#'   is determined via the DESCRIPTION file.
#' @param color badge color
#' @param url The URL of the LICENSE text. If \code{NULL} (the default), links
#'   to the CRAN Package License page. This leads to a broken link if package
#'   uses a non-CRAN compatible license.
#'
#' @return badge in markdown syntax
#' @export
#' @author Alexander Rossell Hayes
badge_license <- function(license = NULL, color = "blue", url = NULL) {
  if (is.null(license)) {
    license <- gsub(" \\+.*", "", desc::desc_get_field("License"))
  }
  badge <- paste0("https://img.shields.io/badge/license-",
                  gsub("-", "--", license), "-", color, ".svg")
  if (is.null(url)) {
    url <- paste0("https://cran.r-project.org/web/licenses/", license)
  }
  placeholder <- paste("License:", license)
  paste0("[![", placeholder, "](", badge, ")](", url, ")")
}


##' GitHub Actions badge
##'
##' @param ref Reference for a GitHub repository. If \code{NULL} (the default),
##'   the reference is determined by the URL field in the DESCRIPTION file.
##' @param action The name of the GitHub actions workflow. Defaults to
##'   \code{"R-CMD-CHECK"}.
##'
##' @return badge in markdown syntax
##' @export
##' @author Alexander Rossell Hayes
badge_github_actions <- function(ref = NULL, action = "R-CMD-check") {
  ref <- currentGitHubRef(ref)
  svg <- paste0("https://github.com/", ref, "/workflows/", action, "/badge.svg")
  url <- paste0("https://github.com/", ref, "/actions")
  paste0("[![R build status](", svg, ")](", url, ")")
}

##' CodeFactor badge
##'
##' @param ref Reference for a GitHub repository. If \code{NULL} (the default),
##'   the reference is determined by the URL field in the DESCRIPTION file.
##'
##' @return badge in markdown syntax
##' @export
##' @author Alexander Rossell Hayes
badge_codefactor <- function(ref = NULL) {
  ref <- currentGitHubRef(ref)
  url <- paste0("https://www.codefactor.io/repository/github/", ref)
  svg <- paste0(url, "/badge")
  paste0("[![CodeFactor](", svg, ")](", url, ")")
}

##' r-universe badge
##'
##' @param pkg Package name. If \code{NULL} (the default),
##'   the name is determined by the URL field in the DESCRIPTION file.
##' @param user User name. If \code{NULL} (the default),
##'   the name is determined by the URL field in the DESCRIPTION file.
##'
##' @return badge in markdown syntax
##' @export
##' @author Alexander Rossell Hayes
badge_runiverse <- function(pkg = NULL, user = NULL) {
  if (is.null(pkg) || is.null(user)) {
    ref <- currentGitHubRef(pkg)
    ref <- strsplit(ref, "/")[[1]]
  }

  user <- user %||% ref[[1]]
  pkg <- pkg %||% ref[[2]]

  paste0(
    "[![r-universe status badge]",
    "(https://", user, ".r-universe.dev/badges/", pkg, ")]",
    "(https://", user, ".r-universe.dev/", pkg, ")"
  )
}
