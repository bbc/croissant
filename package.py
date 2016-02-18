def package(builder):
    builder.spec.build_arch = "x86_64"
    builder.run(["tar", "-C", builder.root, "-zcf", builder.sources_dir + "/" + builder.name + ".tar.gz", "src"])
    tar_source = builder.spec.add_source(builder.name + ".tar.gz")

    builder.spec.add_install_steps([
        ["mkdir", "-p", "%{buildroot}/app %{buildroot}/home/component %{buildroot}/log"],
        ["tar", "-C", "%{buildroot}/app", "-xzf", tar_source, "--strip 1"]
    ])

    builder.spec.add_post_steps([
        ['/bin/chown', '-R', 'component:component', '/app/.gems']
    ])

    builder.spec.add_files(["/app", "/log"])
