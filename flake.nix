{
  description = "A Nix-flake-based R package development environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  # Track arf on main; run `nix flake update arf` (or `nix flake update`) to upgrade
  inputs.arf = {
    url = "github:eitsupi/arf";
    flake = false;
  };

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
      lib = inputs.nixpkgs.lib;
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
        # Build arf (modern Rust-based R console) from the flake input.
        # To upgrade: nix flake update arf  (or just: nix flake update)
        # If cargoHash breaks after upgrade, set it to lib.fakeHash → run `nix develop` → paste the "got: sha256-..." value.
        arf = final.rustPlatform.buildRustPackage {
          pname = "arf";
          version = inputs.arf.shortRev or "unstable";

          src = inputs.arf;

          cargoHash = "sha256-N5BsmDx8mR0PxJFTsr5bqbLJNZlyrJzL4O//vxoiELU=";

          # Two cd/tilde tests fail in the Nix sandbox (no $HOME), skip them
          doCheck = false;

          buildInputs = with final; lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];
          nativeBuildInputs = with final; [ pkg-config ];

          meta = {
            description = "A modern Rust-based R console with fuzzy history, tree-sitter highlighting, and vi/emacs modes";
            homepage = "https://github.com/eitsupi/arf";
            license = lib.licenses.mit;
            mainProgram = "arf";
          };
        };

        # ==============================================================================
        # SPECIAL PACKAGES (built from GitHub sources)
        # ==============================================================================

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

        # ==============================================================================
        # YOUR PACKAGE'S DEPENDENCIES (from DESCRIPTION Imports:)
        # ==============================================================================
        runtimeDeps = with final.rPackages; [
          cli
          httr
          jsonlite
          sf
          terra
        ];

        # Data packages from GitHub (not on CRAN)
        githubDeps = [
          rnaturalearthdata
          rnaturalearthhires
        ];

        # ==============================================================================
        # BUILD YOUR PACKAGE
        # ==============================================================================
        rnaturalearth = final.rPackages.buildRPackage {
          name = "rnaturalearth";
          src = ./.;
          propagatedBuildInputs = runtimeDeps ++ githubDeps;
        };

        # ==============================================================================
        # DEVELOPMENT PACKAGES
        # ==============================================================================
        devPackages = with final.rPackages; [
          # Package development tools
          devtools
          roxygen2
          testthat
          usethis
          pkgdown
          rcmdcheck
          pak
          urlchecker

          # IDE support (R.nvim / LSP)
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
          fs
        ];

        # Combine: runtime deps + github deps + dev tools
        rPackageList = runtimeDeps ++ githubDeps ++ devPackages;

        # ==============================================================================
        # WRAP R WITH ALL PACKAGES
        # ==============================================================================
        wrappedR = final.rWrapper.override { packages = rPackageList; };
      };

      devShells = forEachSupportedSystem (
        { pkgs }:
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              wrappedR # R with packages for LSP
              arf # modern Rust-based R console
              jarl # fast R linter (from nixpkgs)
              qpdf # PDF compression checks

              # Additional system tools for package development
              pandoc # Document conversion (for vignettes)
              html-tidy # HTML validation for R CMD check
              (texlive.combine {
                inherit (texlive)
                  scheme-small
                  inconsolata # Required for PDF manual generation
                  ;
              })

              # Podman for revdepcheck (uses rocker/geospatial image)
              # Run with: ./revdep-check.sh --clean
              podman
            ];

            shellHook = ''
              export R_HOME=$(R RHOME)
              export R_LIBS_SITE=$(strings "$(command -v R)" | grep -oP '/nix/store/[^:]+/library' | sort -u | paste -sd: -)
              export R_LIBS_USER="$PWD/.r-libs"
              mkdir -p "$R_LIBS_USER"
              export R_QPDF="${pkgs.qpdf}/bin/qpdf"
            '';
          };
        }
      );
    };
}
