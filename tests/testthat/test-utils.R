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

test_that("compute_mncs adds mncs column", {
  df <- tibble::tibble(
    cited_by_count = c(10, 5, 20, 8),
    field = c("A", "A", "B", "B"),
    year = c(2020, 2020, 2020, 2020)
  )
  result <- compute_mncs(df)
  expect_true("mncs" %in% names(result))
  expect_true("field_mean" %in% names(result))
  expect_equal(nrow(result), 4)
  a_mean <- mean(c(10, 5))
  expect_equal(result$mncs[result$field == "A"], c(10, 5) / a_mean)
})

test_that("build_coauth_graph returns igraph", {
  works <- tibble::tibble(
    id = c("W1", "W1", "W2", "W2", "W2"),
    authorships = list(
      tibble::tibble(au_id = "A1", au_display_name = "Alice"),
      tibble::tibble(au_id = "A2", au_display_name = "Bob"),
      tibble::tibble(au_id = "A1", au_display_name = "Alice"),
      tibble::tibble(au_id = "A2", au_display_name = "Bob"),
      tibble::tibble(au_id = "A3", au_display_name = "Carol")
    )
  )
  works_nested <- tibble::tibble(
    id = c("W1", "W2"),
    authorships = list(
      tibble::tibble(au_id = c("A1", "A2"),
                     au_display_name = c("Alice", "Bob")),
      tibble::tibble(au_id = c("A1", "A2", "A3"),
                     au_display_name = c("Alice", "Bob", "Carol"))
    )
  )
  g <- build_coauth_graph(works_nested)
  expect_s3_class(g, "igraph")
  expect_true(igraph::vcount(g) >= 2)
})

test_that("kleinberg_bursts returns data frame", {
  skip_if_not_installed("bursts")
  set.seed(42)
  n <- 100
  kw <- sample(c("open access", "bibliometrics", "h-index"), n, replace = TRUE)
  dates <- as.Date("2020-01-01") + sort(sample(1:1000, n))
  result <- kleinberg_bursts(kw, dates, top_n = 3)
  expect_true(is.data.frame(result))
  if (nrow(result) > 0) {
    expect_true("keyword" %in% names(result))
  }
})
