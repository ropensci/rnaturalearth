# Lintr configuration for R package development
# This provides opinionated linting rules for code quality and consistency

linters <- lintr::all_linters(
  packages = "lintr",

  # Enforce 80 character line length
  line_length_linter(80L),

  # Disable some opinionated linters that may be too strict for your workflow
  # Uncomment any of these if you want stricter checking:
  object_length_linter = NULL,        # Don't enforce object name length limits
  object_name_linter = NULL,          # Don't enforce specific naming conventions
  object_usage_linter = NULL,         # Don't check for unused objects
  unused_import_linter = NULL,        # Don't check for unused imports
  one_call_pipe_linter = NULL,        # Allow single-call pipes
  consecutive_mutate_linter = NULL,   # Allow multiple consecutive mutate() calls
  unnecessary_nesting_linter = NULL,  # Don't flag nested code

  # Prefer modern R functions from cli and fs packages
  # This encourages using more robust and user-friendly alternatives
  undesirable_function_linter = undesirable_function_linter(
    fun = modify_defaults(
      defaults = default_undesirable_functions,

      # Prefer cli:: functions for better error messages and formatting
      abort = "use cli::cli_abort()",
      inform = "use cli::cli_inform()",
      message = "use cli::cli_inform()",
      stop = "use cli::cli_abort()",
      warn = "use cli::cli_warn()",
      warning = "use cli::cli_warn()",
      cli_alert_danger = "use cli::cli_inform()",
      cli_alert_info = "use cli::cli_inform()",
      cli_alert_success = "use cli::cli_inform()",
      cli_alert_warning = "use cli::cli_inform()",

      # Prefer fs:: functions for better cross-platform file operations
      basename = "use path_file()",
      dirname = "use path_dir()",
      dir = "use dir_ls()",
      dir.create = "use dir_create()",
      file.copy = "use file_copy()",
      file.create = "use file_create()",
      file.exists = "use file_exists()",
      file.info = "use file_info()",
      file.path = "use path()",
      normalizePath = "use path_real()",
      unlink = "use file_delete()",

      # Prefer readr:: functions for better file I/O
      readLines = "use read_lines()",
      writeLines = "use write_lines()",

      # Allow library() calls (commonly needed in scripts/vignettes)
      library = NULL
    ),
    symbol_is_undesirable = FALSE
  ),

  # Flag undesirable operators (e.g., <<-, :::)
  undesirable_operator_linter(
    op = all_undesirable_operators
  )
)
