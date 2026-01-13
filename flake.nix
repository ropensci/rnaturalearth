{
  description = "A Nix-flake-based R package development environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

  inputs.rNvim = {
    url = "github:R-nvim/R.nvim";
    flake = false;
  };

  inputs.rnaturalearthdata = {
    url = "github:ropensci/rnaturalearthdata";
    flake = false;
  };

  inputs.rnaturalearthhires = {
    url = "github:ropensci/rnaturalearthhires";
    flake = false;
  };

  inputs.crancache = {
    url = "github:r-lib/crancache";
    flake = false;
  };

  inputs.revdepcheck = {
    url = "github:r-lib/revdepcheck";
    flake = false;
  };

  outputs =
    { self, ... }@inputs:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forEachSupportedSystem =
        f:
        inputs.nixpkgs.lib.genAttrs supportedSystems (
          system:
          f {
            pkgs = import inputs.nixpkgs {
              inherit system;
              config.allowBroken = true;
              overlays = [ inputs.self.overlays.default ];
            };
          }
        );
    in
    {
      overlays.default = final: prev: rec {
        # ==============================================================================
        # SECTION 1: YOUR PACKAGE'S DEPENDENCIES (from DESCRIPTION file)
        # ==============================================================================
        # These are the packages YOUR package needs to run (Imports field)
        runtimeDeps = with final.rPackages; [
          cli
          httr
          jsonlite
          sf
          terra
        ];

        # These are data packages from GitHub that your package needs
        githubDataDeps = [
          rnaturalearthdata
          rnaturalearthhires
        ];

        # ==============================================================================
        # SECTION 2: BUILD SPECIAL PACKAGES (from GitHub, not from CRAN)
        # ==============================================================================
        # These packages aren't on CRAN, so we build them from source

        # Build nvimcom manually from R.nvim source
        nvimcom = final.rPackages.buildRPackage {
          name = "nvimcom";
          src = inputs.rNvim;
          sourceRoot = "source/nvimcom";

          buildInputs = with final; [
            R
            gcc
            gnumake
            qpdf
          ];

          meta = {
            description = "R.nvim communication package";
            homepage = "https://github.com/R-nvim/R.nvim";
            maintainers = [ ];
          };
        };

        # Build rnaturalearthdata from GitHub
        rnaturalearthdata = final.rPackages.buildRPackage {
          name = "rnaturalearthdata";
          src = inputs.rnaturalearthdata;

          meta = {
            description = "World Vector Map Data from Natural Earth";
            homepage = "https://github.com/ropensci/rnaturalearthdata";
            maintainers = [ ];
          };
        };

        # Build rnaturalearthhires from GitHub
        rnaturalearthhires = final.rPackages.buildRPackage {
          name = "rnaturalearthhires";
          src = inputs.rnaturalearthhires;

          meta = {
            description = "High Resolution World Vector Map Data from Natural Earth";
            homepage = "https://github.com/ropensci/rnaturalearthhires";
            maintainers = [ ];
          };
        };

        # Build crancache from GitHub
        crancache = final.rPackages.buildRPackage {
          name = "crancache";
          src = inputs.crancache;
          propagatedBuildInputs = with final.rPackages; [
            callr
            cranlike
            curl
            desc
            digest
            parsedate
            rappdirs
            rematch2
            withr
          ];
        };

        # Build revdepcheck from GitHub
        revdepcheck = final.rPackages.buildRPackage {
          name = "revdepcheck";
          src = inputs.revdepcheck;
          propagatedBuildInputs = with final.rPackages; [
            DBI
            RSQLite
            assertthat
            brio
            callr
            cli
            clisymbols
            crancache
            crayon
            curl
            desc
            glue
            gmailr
            hms
            httr
            jsonlite
            knitr
            pkgbuild
            prettyunits
            processx
            progress
            rcmdcheck
            rematch2
            remotes
            rlang
            sessioninfo
            tibble
            whoami
            withr
            yaml
          ];
        };

        # ==============================================================================
        # SECTION 3: BUILD YOUR PACKAGE
        # ==============================================================================
        rnaturalearth = final.rPackages.buildRPackage {
          name = "rnaturalearth";
          src = ./.;
          # Give it the runtime dependencies from Section 1
          propagatedBuildInputs = runtimeDeps ++ githubDataDeps;
        };

        # ==============================================================================
        # SECTION 4: DEVELOPMENT ENVIRONMENT PACKAGES
        # ==============================================================================
        # All the packages you want available when developing
        # This is SEPARATE from your package's runtime dependencies!

        devPackages = with final.rPackages; [
          # Development tools
          devtools
          roxygen2
          testthat
          usethis
          pkgdown
          rcmdcheck
          pak
          urlchecker
          crancache
          revdepcheck

          # Editor support (nvim, LSP, etc.)
          languageserver
          nvimcom
          httpgd
          lintr
          cyclocomp

          # Useful packages for development/testing
          dplyr
          ggplot2
          ggrepel
          pbapply
          tmap
          tibble
          cli
          fs
        ];

        # Combine: your package's dependencies + development tools
        # This is what goes into your R environment
        allPackages = runtimeDeps ++ githubDataDeps ++ devPackages;

        # ==============================================================================
        # SECTION 5: WRAP R AND RADIAN WITH ALL PACKAGES
        # ==============================================================================
        # Create rWrapper with packages (for LSP and R.nvim)
        baseWrappedR = final.rWrapper.override { packages = allPackages; };

        # Wrap R with R_QPDF environment variable
        wrappedR = final.symlinkJoin {
          name = "wrapped-r-with-qpdf";
          paths = [ baseWrappedR ];
          buildInputs = [ final.makeWrapper ];
          postBuild = ''
            wrapProgram $out/bin/R \
              --set R_QPDF "${final.qpdf}/bin/qpdf"
            wrapProgram $out/bin/Rscript \
              --set R_QPDF "${final.qpdf}/bin/qpdf"
          '';
        };

        # Create radianWrapper with same packages (for interactive use)
        baseWrappedRadian = final.radianWrapper.override { packages = allPackages; };

        # Wrap radian with R_QPDF environment variable
        wrappedRadian = final.symlinkJoin {
          name = "wrapped-radian-with-qpdf";
          paths = [ baseWrappedRadian ];
          buildInputs = [ final.makeWrapper ];
          postBuild = ''
            wrapProgram $out/bin/radian \
              --set R_QPDF "${final.qpdf}/bin/qpdf"
          '';
        };
      };

      devShells = forEachSupportedSystem (
        { pkgs }:
        {
          default = pkgs.mkShellNoCC {
            packages = with pkgs; [
              wrappedR # R with packages for LSP
              wrappedRadian # radian with packages for interactive use
              qpdf # PDF compression checks

              # Additional system tools for package development
              # git           # Version control
              pandoc # Document conversion (for vignettes)
              # quarto        # Modern publishing system
              html-tidy # HTML validation for R CMD check
              (texlive.combine {
                inherit (texlive)
                  scheme-small
                  inconsolata # Required for PDF manual generation
                  ;
              })
            ];

            shellHook = ''
              # Set R_QPDF environment variable for R CMD check
              export R_QPDF="${pkgs.qpdf}/bin/qpdf"

              echo "🔧 R Package Development Environment"
              echo ""
              echo "Quick commands:"
              echo "  devtools::load_all()        - Load package for testing"
              echo "  devtools::test()            - Run tests"
              echo "  devtools::document()        - Generate documentation"
              echo "  devtools::check()           - Run R CMD check"
              echo "  pkgdown::build_site()       - Build package website"
              echo ""
              echo "Start R with: radian"
            '';
          };
        }
      );

      templates = {
        default = {
          path = ./.;
          description = "R package development environment with nvimcom and R.nvim integration";
          welcomeText = ''
            # R Package Development Template

            ## Getting started
            1. Edit flake.nix and uncomment the sections you need
            2. Add your DESCRIPTION Imports to propagatedBuildInputs
            3. Add your DESCRIPTION Suggests to rPackageList
            4. Run `direnv allow` (if using direnv) or `nix develop`

            ## What's included
            - R with devtools, roxygen2, testthat, and usethis
            - languageserver and nvimcom for editor integration
            - radian (modern R console)
            - Helpful comments showing where to add dependencies
          '';
        };
      };
    };
}
