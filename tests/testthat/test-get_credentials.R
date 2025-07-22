test_that("get_credentials() returns list with values from sys.env", {
  expect_type(
    withr::with_envvar(
      list(ENT_USER = "testid",
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
  with_mocked_bindings(code = {
  expect_identical(
    withr::with_envvar(
      new = list( # Reset credentials
        ETN_USER = NULL,
        ETN_PWD = NULL
      ),
      suppressMessages(get_credentials())
    ),
    list(username = "entered_id", password = "entered_pwd")
  )},
  ask_pass = function(...) "entered_pwd",
  prompt_user = function(...) "entered_id",
  is_interactive = function(...) TRUE
  )

  with_mocked_bindings(code = {
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
    )},
    ask_pass = function(...) "entered_pwd",
    prompt_user = function(...) "entered_id",
    is_interactive = function(...) TRUE
  )
})

