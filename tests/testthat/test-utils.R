test_that("dedupe_by_doi removes duplicates", {
  df <- tibble::tibble(
    doi = c("10.1000/a", "10.1000/b", "10.1000/a", NA, NA),
    title = c("A", "B", "A2", "C", "D")
  )
  result <- dedupe_by_doi(df)
  expect_equal(nrow(result), 4)
  expect_equal(sum(result$doi == "10.1000/a", na.rm = TRUE), 1)
  expect_equal(sum(is.na(result$doi)), 2)
})

test_that("compute_h_index works correctly", {
  expect_equal(compute_h_index(c(10, 8, 5, 4, 3)), 4L)
  expect_equal(compute_h_index(c(25, 8, 5, 3, 3)), 3L)
  expect_equal(compute_h_index(c(0, 0, 0)), 0L)
  expect_equal(compute_h_index(integer(0)), 0L)
  expect_equal(compute_h_index(c(100)), 1L)
})

test_that("field_normalize computes MNCS", {
  cites <- c(10, 5, 0)
  means <- c(5, 5, 5)
  result <- field_normalize(cites, means)
  expect_equal(result, c(2, 1, 0))
})

test_that("field_normalize handles zero field means", {
  result <- field_normalize(c(5, 0), c(0, 3))
  expect_true(is.na(result[1]))
  expect_equal(result[2], 0 / 3)
})
