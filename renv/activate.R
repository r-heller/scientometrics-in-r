
local({

  # the requested version of renv
  version <- "1.0.7"
  attr(version, "sha") <- NULL

  # the project directory
  project <- getwd()

  # use start-up diagnostics if enabled
  diagnostics <- Sys.getenv("RENV_STARTUP_DIAGNOSTICS", unset = "FALSE")
  if (diagnostics) {
    start <- Sys.time()
    prefix <- "[renv startup diagnostics]"
    on.exit({
      elapsed <- difftime(Sys.time(), start, units = "auto")
      msg <- paste(prefix, "startup took", format(elapsed))
      message(msg)
    }, add = TRUE)
  }

  # signal that we're loading renv during R startup
  Sys.setenv("RENV_R_INITIALIZING" = "true")
  on.exit(Sys.unsetenv("RENV_R_INITIALIZING"), add = TRUE)

  # signal that we've consented to use renv
  options(renv.consent = TRUE)

  # load the 'utils' library
  library(utils, lib.loc = .Library)

  # check if renv has already been loaded
  if ("renv" %in% loadedNamespaces()) {
    # make sure renv is loaded from the project library
    if (renv::project() == project)
      return(invisible(TRUE))
  }

  # load bootstrap tools
  `%||%` <- function(x, y) if (is.null(x)) y else x

  catf <- function(fmt, ..., appendLF = TRUE) {
    msg <- sprintf(fmt, ...)
    cat(msg, file = stderr(), sep = if (appendLF) "\n" else "")
  }

  # renv bootstrap placeholder -- actual bootstrap handled by renv::restore()
  catf("* Project '%s' loaded. Run renv::restore() to install packages.", basename(project))

})
