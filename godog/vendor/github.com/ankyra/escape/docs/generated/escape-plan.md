---
date: 2017-11-11 00:00:00
title: "The Escape Plan"
slug: escape-plan
type: "reference"
toc: true
wip: false
---

Everything starts with a plan. An Escape plan.

The Escape plan gets compiled into release metadata at build time.


Field | Type | Description
------|------|-------------
|<a name='name'></a>name|`string`|The package name is a required field. The name can be qualified by a project name, but if no project is specified then the default project `_` will be used. 
|||Format: `/([a-za-z]+[a-za-z0-9-]*\/)?[a-za-z]+[a-za-z0-9-]*/` 
|||Examples: 
|||* Fully qualified: `name: my-project/my-package` 
|||* Default project: `name: my-package` 
|<a name='version'></a>version|`string`|The version is a required field. Escape uses semantic versioning to version packages.  Either specify the full version or use the '@' symbol to let Escape pick the next version at build time. See [here](/docs/guides/versioning/) for more versioning approaches. 
|||Format: `/[0-9]+(\.[0-9]+)*(\.@)?/` 
|||Examples: 
|||* Build version 1.5: `version: 1.5` 
|||* Build the next minor release in the 1.* series: `version: 1.@` 
|||* Build the next patch release in the 1.1.* series: `version: 1.1.@` 
|<a name='description'></a>description|`string`|A description for this package. Only used for presentation purposes. 
|<a name='logo'></a>logo|`string`|A path to an image. Only used for presentation purposes. 
|<a name='license'></a>license|`string`|The license. For example `Apache Software License`, `BSD License`, `GPLv3`, etc. Currently no input validation is performed on this field. 
|<a name='metadata'></a>metadata|`{string:string}`|Metadata key value pairs. 
|||[Escape Script](/docs/scripting-language/) can be used to programmatically set values using the [default context](/docs/scripting-language/#context). 
|||Example: 
|||metadata: author: Fictional Character co_author: $dependency.metadata.author 
|<a name='depends'></a>depends|`[string]`, [Dependencies](/docs/reference/dependencies/)|Reference depedencies by their full ID or use the `@` symbol to resolve versions at build time. 
|<a name='extends'></a>extends|`[string]`, [Extensions](/docs/reference/extensions/)|
|<a name='includes'></a>includes|`[string]`|The files to includes in this release. The files don't have to exist and can be produced during build time. Globbing patterns are supported. Directories are added recursively. 
|<a name='generates'></a>generates|`[string]`|Files that are generated during the build phase. Globbing patterns are supported.  Directories are added recursively. The main reason to use this over `includes` is that the `generates` field is copied to the parent release, when a release gets extended, but `includes` aren't. 
|<a name='provides'></a>provides|`[string]`, [Consumers](/docs/reference/providers-and-consumers/)|The release can declare zero or more providers so that consumers can loosely depend on it at deploy time. 
|<a name='consumes'></a>consumes|`[string]`, [Consumers](/docs/reference/providers-and-consumers/)|At deploy time a package can consume zero or more providers from the target environment. 
|<a name='build_consumes'></a>build_consumes|`[string]`, [Consumers](/docs/reference/providers-and-consumers/)|Same as `consumes`, but scoped to the build stage (ie. the consumer is not required/available at deploy time). 
|<a name='deploy_consumes'></a>deploy_consumes|`[string]`, [Consumers](/docs/reference/providers-and-consumers/)|Same as `consumes`, but scoped to the deploy stage (ie. the consumer is not required/available at build time). 
|<a name='inputs'></a>inputs|`[string]`, [Variables](/docs/reference/input-and-output-variables/)|Input variables. 
|<a name='build_inputs'></a>build_inputs|`[string]`, [Variables](/docs/reference/input-and-output-variables/)|Same as `inputs`, but all variables are scoped to the build phase (ie. the variables won't be required/available at deploy time). 
|<a name='deploy_inputs'></a>deploy_inputs|`[string]`, [Variables](/docs/reference/input-and-output-variables/)|Same as `inputs`, but all variables are scoped to the deployment phase (ie. the variables won't be required/available at build time). 
|<a name='outputs'></a>outputs|`[string]`, [Variables](/docs/reference/input-and-output-variables/)|Output variables. 
|<a name='build_outputs'></a>build_outputs|`[any]`|Same as `outputs`, but all variables are scoped to the build phase (ie. the variables won't be required/available at deploy time). 
|<a name='deploy_outputs'></a>deploy_outputs|`[any]`|Same as `outputs`, but all variables are scoped to the deployment phase (ie. the variables won't be required/available at build time). 
|<a name='build'></a>build|`any`|Build script. 
|<a name='pre_build'></a>pre_build|`any`|Pre-build script. The script has access to all the build scoped input variables. 
|<a name='post_build'></a>post_build|`any`|Post-build script. The script has access to all the build scoped input and output variables. 
|<a name='test'></a>test|`any`|Test script.  Generally run after a build as part of the release process, but can be triggered separately using `escape run test`.  The script has access to all the build scoped input and output variables. 
|<a name='deploy'></a>deploy|`any`|Deploy script. The script has access to the deployment input variables, and can define outputs by writing a JSON object to .escape/outputs.json. 
|<a name='pre_deploy'></a>pre_deploy|`any`|Pre-deploy script. The script has access to all the deploy scoped input variables. 
|<a name='post_deploy'></a>post_deploy|`any`|Post-deploy script. The script has access to all the deploy scoped input and output variables. 
|<a name='activate_provider'></a>activate_provider|`any`|Activate provider script. This script is run when this release is being consumed as a provider by another release during a build or deployment. The script has access to all the deploy scoped input and output variables. 
|<a name='deactivate_provider'></a>deactivate_provider|`any`|Deactive provider script. This script is run when this release is being done being consumed by another release using it as a provider. The script has access to all the deploy scoped input and output variables. 
|<a name='smoke'></a>smoke|`any`|Smoke test script. 
|<a name='destroy'></a>destroy|`any`|Destroy script. 
|<a name='pre_destroy'></a>pre_destroy|`any`|Pre-destroy script. 
|<a name='post_destroy'></a>post_destroy|`any`|Post-destroy script. 
|<a name='errands'></a>errands|{string:[Errands](/docs/reference/errands/)}|Errands are scripts that can be run against the deployment of this release. The scripts receive the deployment's inputs and outputs as environment variables. 
|<a name='templates'></a>templates|[Templates](/docs/reference/templates/)|Templates. 
|<a name='build_templates'></a>build_templates|[Templates](/docs/reference/templates/)|Same as `templates`, but all the templates are scoped to the build stage (ie. templates won't be rendered at deploy time). 
|<a name='deploy_templates'></a>deploy_templates|[Templates](/docs/reference/templates/)|Same as `templates`, but all the templates are scoped to the deploy stage (ie. templates won't be rendered at deploy time). 
|<a name='downloads'></a>downloads|[Downloads](/docs/reference/downloads/)|Downloads. 

