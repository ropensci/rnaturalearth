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
        # Define your package's runtime dependencies once (from DESCRIPTION Imports:)
        myPackageRuntimeDeps =
          (with final.rPackages; [
            cli
            httr
            jsonlite
            sf
            terra
          ])
          ++ [
            # GitHub-sourced packages
            rnaturalearthdata
            rnaturalearthhires
          ];

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

        # Build your R package
        rnaturalearth = final.rPackages.buildRPackage {
          name = "rnaturalearth";
          src = ./.;

          # Reuse the runtime dependencies defined above
          propagatedBuildInputs = myPackageRuntimeDeps;
        };

        # Define R packages for the development environment
        rPackageList =
          (with final.rPackages; [
            # ============================================================
            # CORE DEVELOPMENT TOOLS
            # These are essential for R package development and testing
            # ============================================================
            devtools # Package development tools (load_all, document, etc.)
            roxygen2 # Documentation generation from code comments
            testthat # Unit testing framework
            usethis # Workflow automation for package development
            pkgdown # Generate package website
            rcmdcheck # Run R CMD check from R
            pak
            dplyr
            ggplot2
            ggrepel
            pbapply
            tmap

            # ============================================================
            # EDITOR/IDE INTEGRATION
            # Required for R.nvim, LSP, and interactive development
            # ============================================================
            languageserver # LSP server for code completion and diagnostics
            nvimcom # R.nvim communication package
            httpgd # Modern graphics device for web-based plotting
            lintr # Static code analysis and linting
            cyclocomp # Code complexity analysis
            tibble
            cli # Modern CLI interfaces
            fs # File system operations
          ])
          ++ myPackageRuntimeDeps;

        # Create rWrapper with packages (for LSP and R.nvim)
        baseWrappedR = final.rWrapper.override { packages = rPackageList; };

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
        baseWrappedRadian = final.radianWrapper.override { packages = rPackageList; };

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
              pandoc        # Document conversion (for vignettes)
              # quarto        # Modern publishing system
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
