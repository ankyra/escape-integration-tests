---
date: 2017-11-11 00:00:00
title: "escape plan init"
slug: escape_plan_init
type: "docs"
toc: true
wip: true
---
## escape plan init

Initialize a new Escape plan

### Synopsis


Initialize a new Escape plan

```
escape plan init [flags]
```

### Options

```
  -f, --force           Overwrite output file if it exists
  -h, --help            help for init
  -m, --minify          Minify the generated Escape plan
  -n, --name string     The release name (eg. hello-world)
  -o, --output string   The output location (default "escape.yml")
```

### Options inherited from parent commands

```
      --collapse-logs    Collapse log sections. (default true)
  -c, --config string    Local of the global Escape configuration file (default "~/.escape_config")
  -l, --level string     Log level: debug, success, info, warn, error (default "info")
      --profile string   Configuration profile
```

### SEE ALSO
* [escape plan](../escape_plan/)	 - Manage the Escape plan

###### Auto generated by spf13/cobra on 2-Feb-2018