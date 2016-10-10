def _hs_library_impl(ctx):
  """Haskell library

  At the moment this only really works with a single file in srcs.
  """
  # Using new_file here instead of ctx.outputs to keep it reusable within
  # _hs_binary_impl
  out_o = ctx.new_file(ctx.label.name + ".o")
  out_hi = ctx.new_file(ctx.label.name + ".hi")
  ctx.action(
      inputs = ctx.files.srcs + ctx.files.deps + ctx.files.data,
      outputs = [out_o, out_hi],
      command = " ".join([
          "HOME=/fake", "ghc", "-c",
          "-o", out_o.path,
          "-ohi", out_hi.path,
          "-i",
          "-i%s" % ctx.configuration.bin_dir.path,  # <-- not entirely correct
          cmd_helper.join_paths(" ", set(ctx.files.srcs))
      ]),
      use_default_shell_env = True,
  )
  return struct(obj = out_o,
                interface = out_hi)

def _hs_binary_impl(ctx):
  lib_self = _hs_library_impl(ctx)
  objects = [x.obj for x in ctx.attr.deps] + [lib_self.obj]
  ctx.action(
      inputs = objects + ctx.files.data,
      outputs = [ctx.outputs.executable],
      command = " ".join([
          "HOME=/fake", "ghc",
          "-o", ctx.outputs.executable.path,
          cmd_helper.join_paths(" ", set(objects))
      ]),
      use_default_shell_env = True,
  )

_hs_attrs = {
    "srcs": attr.label_list(
        allow_files = FileType([".hs"]),
    ),
    "deps": attr.label_list(
        allow_files = False,
    ),
    "data": attr.label_list(
        allow_files = True,
    ),
}

hs_library = rule(
    implementation = _hs_library_impl,
    attrs = _hs_attrs,
    outputs = {
        "obj": "%{name}.o",
        "interface": "%{name}.hi",
    },
)

hs_binary = rule(
    implementation = _hs_binary_impl,
    attrs = _hs_attrs,
    executable = True,
)
