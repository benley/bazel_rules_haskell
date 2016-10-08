def _hs_library_impl(ctx):
  outs = []
  for src in ctx.files.srcs:
    base = src.basename.rsplit(".", 1)[0]
    outs += [ctx.new_file(base + ".hi"),
             ctx.new_file(base + ".o")]
  ctx.action(
      inputs = ctx.files.srcs,
      outputs = outs,
      command = (
          "HOME=/fake ghc -c " +
          "-outputdir %s " % outs[0].dirname +
          "-i%s " % ctx.configuration.bin_dir.path +
          cmd_helper.join_paths(" ", set(ctx.files.srcs))
      ),
      use_default_shell_env = True,
  )

def _hs_binary_impl(ctx):
  # Currently broken.
  ctx.action(
      inputs = list(ctx.files.srcs + ctx.files.deps),
      outputs = [ctx.outputs.o],
      command = (
          "HOME=/fake ghc -c " +
          "-outputdir %s " % ctx.outputs.o.dirname +
          "-i%s " % ctx.configuration.bin_dir.path +
          cmd_helper.join_paths(" " , set(ctx.files.srcs))
      ),
      use_default_shell_env = True,
  )

  ctx.action(
      inputs = list(ctx.files.srcs + ctx.files.deps),
      outputs = [ctx.outputs.executable],
      command = (
          "HOME=/fake ghc -o %s " % ctx.outputs.executable.path +
          "-i%s " % ctx.configuration.bin_dir.path +
          cmd_helper.join_paths(" ", set(ctx.files.srcs) + set(ctx.files.deps))
      ),
      use_default_shell_env = True,
  )

def _gen_hs_lib_outs(srcs, deps):
  outs = {}
  for src in srcs:
    base = src.name.rsplit(".", 1)[0]
    outs[base+"_o"] = base + ".o"
    outs[base+"_hi"] = base + ".hi"
  return outs

hs_library = rule(
    implementation = _hs_library_impl,
    attrs = {
        "srcs": attr.label_list(
            allow_files = FileType([".hs"]),
        ),
        "deps": attr.label_list(
            allow_files = False,
        ),
    },
    outputs = _gen_hs_lib_outs,
)

hs_binary = rule(
    implementation = _hs_binary_impl,
    attrs = {
        "srcs": attr.label_list(
            allow_files = FileType([".hs"]),
        ),
        "deps": attr.label_list(
            allow_files = FileType([".o"]),
        ),
    },
    outputs = {
        "o": "%{name}.o",
    },
    executable = True,
)
