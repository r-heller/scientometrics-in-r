test_that("palette_sci returns correct number of colours", {
  cols <- palette_sci(4)
  expect_length(cols, 4)
  expect_true(all(grepl("^#[0-9A-Fa-f]{6}", cols)))
})

test_that("theme_sci returns a ggplot theme", {
  thm <- theme_sci()
  expect_s3_class(thm, "theme")
})
