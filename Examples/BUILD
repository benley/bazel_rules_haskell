load("//rules:haskell.bzl", "hs_library", "hs_binary")

hs_library(
    name = "blarg",
    srcs = [
        "Ch4_3.hs",
        "Foo.hs",
    ],
)

hs_binary(
    name = "hello",
    srcs = ["Hello/main.hs"],
    deps = [":blarg"],
)
