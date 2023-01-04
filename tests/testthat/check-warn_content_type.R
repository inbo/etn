test_that("check_content_type() returns an error for the wrong content-type", {
  response <- httr::GET("https://catfact.ninja/fact")
  expect_error(check_content_type(
    response, "image/png",
    "Server returned object of type application/json instead of image/png"
  ))
})
test_that("check_content_type() is quiet when the content-type is correct", {
  response <- httr::GET("https://dog.ceo/api/breeds/image/random")
  expect_no_error(check_content_type(response, "application/json"))
  response <- httr::GET("https://catfact.ninja/fact")
  expect_no_error(check_content_type(response, "application/json"))
})
