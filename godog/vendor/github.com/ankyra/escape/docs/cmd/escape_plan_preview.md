---
date: 2017-11-11 00:00:00
title: "escape plan preview"
slug: escape_plan_preview
type: "reference"
layout: "cmd"
toc: true
wip: false
---
## escape plan preview

Preview the Escape plan

### Synopsis


Preview the Escape plan

```
escape plan preview [flags]
```

### Options

```
  -d, --deployment string     Deployment name (default is the package's "project/name")
  -e, --environment string    The logical environment to target (default "dev")
  -h, --help                  help for preview
      --plan string           The location of the Escape plan. (default "escape.yml")
  -r, --remote-state string   Use remote state project.
  -s, --state string          Location of the Escape state file (ignored when --remote-state is set) (default "escape_state.json")
      --use-profile-state     Instead of using the Escape state file specified in --state, read the 'state_path' value from the configuration profile.
```

### Options inherited from parent commands

```
      --collapse-logs    Collapse log sections. (default true)
  -c, --config string    Local of the global Escape configuration file (default "~/.escape_config")
  -l, --level string     Log level: debug, success, info, warn, error (default "info")
      --logger string    Logger: default, json (default "default")
      --profile string   Configuration profile
```

### SEE ALSO
* [escape plan](../escape_plan/)	 - Manage the Escape plan

###### Auto generated by spf13/cobra on 27-Nov-2018
