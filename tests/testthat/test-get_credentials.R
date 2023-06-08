test_that("get_credentials() returns list with values from sys.env", {
  expect_type(
    withr::with_envvar(
      list(userid = "testid",
           pwd = "testpwd"),
      get_credentials()
    ),
    "list"
  )
  expect_identical(
    withr::with_envvar(
      list(userid = "testid",
           pwd = "testpwd"),
      get_credentials()
    ),
    list(username = "testid",
         password = "testpwd")
  )
})
