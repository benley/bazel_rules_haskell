load("//rules:haskell.bzl", "hs_library", "hs_binary")

hs_library(
    name = "Foo",
    srcs = ["Foo.hs"],
    deps = [":Ch4_3"],
)

hs_library(
    name = "Ch4_3",
    srcs = ["Ch4_3.hs"],
)

hs_binary(
    name = "hello",
    srcs = ["Hello/main.hs"],
    deps = [":Ch4_3"],
)
