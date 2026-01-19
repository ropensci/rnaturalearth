#!/usr/bin/env bash
# Run reverse dependency checks using Docker and rocker/geospatial

set -e

echo "🔍 Running reverse dependency checks..."
echo ""

# Clean up old revdep state if requested
if [ "$1" = "--clean" ]; then
  echo "🧹 Cleaning old revdep state..."
  rm -rf revdep
fi

# Remove .direnv if it exists (Nix symlinked R doesn't work in containers)
if [ -d ".direnv" ]; then
  echo "🧹 Removing .direnv (Nix symlinks don't work in container)..."
  rm -rf .direnv
fi

# Run revdepcheck in Docker container
podman run --rm -it \
  --ulimit nofile=65536:65536 \
  --shm-size=2gb \
  --ulimit nproc=4096:4096 \
  -v "$(pwd)":/home/rstudio/project \
  -w /home/rstudio/project \
  rocker/geospatial:4.5 \
  R --vanilla -e "
    # Install pak
    install.packages('pak', repos = 'https://cloud.r-project.org')

    # Install GitHub data packages
    # pak::pkg_install(c('ropensci/rnaturalearthdata', 'ropensci/rnaturalearthhires'))

    # Set repos for revdepcheck (CRAN only - we need the prod version as baseline)
    options(repos = c(
      CRAN = 'https://cloud.r-project.org'
    ))

    # Install revdepcheck and devtools
    pak::pkg_install(c('r-lib/revdepcheck', 'devtools'))


    revdepcheck::revdep_check(num_workers = 1L)

    # Generate reports
    cat('📝 Generating summary reports...\n')
    revdepcheck::revdep_report()

    # Print summary
    cat('\n✅ Revdep check complete!\n')
    cat('📊 Results:\n')
    revdepcheck::revdep_summary()
  "

echo ""
echo "📊 Results in: revdep/README.md and revdep/problems.md"
