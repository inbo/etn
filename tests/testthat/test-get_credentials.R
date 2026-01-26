test_that("get_credentials() returns list with values from sys.env", {
  expect_type(
    withr::with_envvar(
      list(ETN_USER = "testid",
           ETN_PWD = "testpwd"),
      get_credentials()
    ),
    "list"
  )
  expect_identical(
    withr::with_envvar(
      list(ETN_USER = "testid",
           ETN_PWD = "testpwd"),
      get_credentials()
    ),
    list(username = "testid",
         password = "testpwd")
  )
})

test_that("get_credentials() prompts the user for credentials if not stored", {
  with_mocked_bindings(
    code = {
      expect_identical(
        withr::with_envvar(
          new = list( # Reset credentials
            ETN_USER = NULL,
            ETN_PWD = NULL
          ),
          suppressMessages(get_credentials())
        ),
        list(username = "entered_id", password = "entered_pwd")
      )
    },
    ask_pass = function(...) "entered_pwd",
    prompt_user = function(...) "entered_id",
    is_interactive = function(...) TRUE
  )

  with_mocked_bindings(
    code = {
      expect_message(
        withr::with_envvar(
          new = list( # Reset credentials
            ETN_USER = NULL,
            ETN_PWD = NULL
          ),
          get_credentials()
        ),
        "No credentials stored, prompting..",
        fixed = TRUE
      )
    },
    ask_pass = function(...) "entered_pwd",
    prompt_user = function(...) "entered_id",
    is_interactive = function(...) TRUE
  )
})

test_that("get_credentials() does not store prompted credentials", {
  # This used to be a feature in v2.3-Beta, but was removed because it goes
  # against best practise and makes password resetting more difficult.

  # Mock a user entering some credentials after being prompted
  with_mocked_bindings(
    code = {
      withr::with_envvar(
        new = list( # Reset credentials
          ETN_USER = NULL,
          ETN_PWD = NULL
        ),
        code = {
          # Run get_credentials() this should not result in a change of env var
          suppressMessages(get_credentials())
          # Check that the credentials are still unset
          expect_identical(
            list(
              Sys.getenv("ETN_USER", unset = "id_unset"),
              Sys.getenv("ETN_PWD", unset = "pwd_unset")
            ),
            list("id_unset", "pwd_unset")
          )
        }
      )
    },
    ask_pass = function(...) "entered_pwd",
    prompt_user = function(...) "entered_id",
    is_interactive = function(...) TRUE
  )
})

test_that("get_credentials() returns error when no credentials are stored and run in non interactive mode", {
  with_mocked_bindings(
    code = {
      expect_error(
        withr::with_envvar(
          new = list( # Reset credentials
            ETN_USER = NULL,
            ETN_PWD = NULL
          ),
          get_credentials()
        ),
        "No credentials stored, not running in interactive mode"
      )
    },
    ask_pass = function(...) "entered_pwd",
    prompt_user = function(...) "entered_id"
  )
})
