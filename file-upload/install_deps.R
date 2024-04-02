install_renv <- !require(renv)

if (install_renv) {
  install.packages("renv")
}

renv::restore(library = .libPaths())
