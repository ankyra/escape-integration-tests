---
date: 2017-11-11 00:00:00
title: "escape config"
slug: escape_config
type: "reference"
layout: "cmd"
toc: true
wip: false
---
## escape config

Manage the escape client configuration

### Synopsis


Manage the escape client configuration

```
escape config [flags]
```

### Options

```
  -h, --help   help for config
      --json   Output profile in JSON format
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
* [escape](../escape/)	 - Package and deployment manager
* [escape config active-profile](../escape_config_active-profile/)	 - Show the currently active profile name
* [escape config create-profile](../escape_config_create-profile/)	 - Set the active Escape profile
* [escape config list-profiles](../escape_config_list-profiles/)	 - List the currently available Escape profiles
* [escape config profile](../escape_config_profile/)	 - Show the currently active Escape profile
* [escape config set-profile](../escape_config_set-profile/)	 - Set the active Escape profile

###### Auto generated by spf13/cobra on 27-Nov-2018
