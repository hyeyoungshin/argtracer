if (TRUE) {
  test_that("trace my_add1", {
    start <- Sys.time()
    record::open_db("test_db/db_my_add", create = TRUE)

    r <- trace_args(code = {
      my_add <- function(x, y) {x + y}
      my_add(1, 1)
    })

    expect_equal(record::size_db(),  2)
    record::close_db()
    end <- Sys.time()
    print(end - start)
  })


  test_that("trace my_add2", {
  start <- Sys.time()
  record::open_db("test_db/db_my_add", create = FALSE)

  r <- trace_args(code = {
    my_add <- function(x, y) {x + y}
    my_add(2, 3)
  })

  expect_equal(record::size_db(), 4)
  record:::report()
  record::close_db()
  end <- Sys.time()
  print(end - start)
})


  test_that("trace all", {
    start <- Sys.time()
    record::open_db("test_db/db_all", create = TRUE)

    if_true <- function (x) {
      if (add_one(x) == 2) TRUE else FALSE
    }
    add_one <- function (x) { x + 1 }
    
    r <- trace_args(code = {
      my_fun <- function(x, y) {
        if (if_true(x)) y else x
      }
      my_fun (1,2) # collect 1, 2, TRUE
      my_fun (3,0) # collect 3, 4, FALSE          0 is not forced, so is not collected
    })

    expect_equal(record::size_db(), 6)
    record:::report()
    record::close_db()
    end <- Sys.time()
    print(end - start)
})

  test_that("trace recursively", {
    start <- Sys.time()
    record::open_db("test_db/db_rec", create = TRUE)

    add_one <- function (x) { x + 1 }
    if_true <- function (x) {
      add_one(100)                           # 100, 101
      if (add_one(x) == 2) TRUE else FALSE   # 12, FALSE
    }

    r <- trace_args(code = {
      my_fun <- function(x, y) {
        add_one(0)                           # 0, 1
        if (if_true(x)) y else x
      }
      my_fun(add_one(10),2)                  # 10, 11
    })

    expect_equal(record::size_db(), 8)
    record:::report()
    record::close_db()
    end <- Sys.time()
    print(end - start)
  })


test_that("trace stringr::str_detect", {
  record::open_db("test_db/db_str_detect", create = TRUE)

  r <- trace_args(code = {
    stringr::str_detect("AB", "A")
  })

  expect_equal(record::size_db(), 16)
  ## 1213
  record:::report()
  record::close_db()
})


test_that("trace ggplot2::aes_all", {
  start <- Sys.time()
  record::open_db("test_db/db_aes_all", create = TRUE)

  r <- trace_args(code = {
    ggplot2::aes_all(names(mtcars))
    ggplot2::aes_all(c("x", "y", "col", "pch"))
  })

  expect_equal(record::size_db(), 85)
  ## 9958
  record:::report()
  record::close_db()
  end <- Sys.time()
  print(end - start)
  ## "collected 10599 promises + return vals from ggplot2::aes_all"
})

  test_that("check tracing package loading", {
    record::open_db("test_db/db_pl", create = TRUE)

    r <- trace_args(code = {
      library(ggplot2)
    })

    expect_equal(record::size_db(), 292)
    record::report()
    record::close_db()
  })

} else {

test_that("trace my_add1", {
  start <- Sys.time()

  r <- trace_args(code = {
    my_add <- function(x, y) {x + y}
    my_add(1, 1)
  })

  end <- Sys.time()
  print(end - start)
})


test_that("trace my_add2", {
  start <- Sys.time()

  r <- trace_args(code = {
    my_add <- function(x, y) {x + y}
    my_add(2, 3)
  })

  end <- Sys.time()
  print(end - start)
})


test_that("trace all", {
  start <- Sys.time()

  if_true <- function (x) {
    if (add_one(x) == 2) TRUE else FALSE
  }
  add_one <- function (x) { x + 1 }
  r <- trace_args(code = {
    my_fun <- function(x, y) {
      if (if_true(x)) y else x
    }
    my_fun (1,2) # collect 1, 2, TRUE
    my_fun (3,0) # collect 3, 4, FALSE          0 is not forced, so is not collected
  })

  browser()
  end <- Sys.time()
  print(end - start)
})


test_that("trace stringr::str_detect", {
  start <- Sys.time()

  r <- trace_args(code = {
    stringr::str_detect("AB", "A")
  })

  end <- Sys.time()
  print(end - start)
  ## "collected 6417 promises + return vals from stringr::str_detect"
})


test_that("trace ggplot2::aes_all", {
  start <- Sys.time()

  r <- trace_args(code = {
    ggplot2::aes_all(names(mtcars))
    ## ggplot2::aes_all(c("x", "y", "col", "pch"))
  })

  end <- Sys.time()
  print(end - start)
  ## "collected 105799 promises + return vals from ggplot2::aes_all"
})

}
