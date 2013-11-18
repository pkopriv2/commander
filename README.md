# Commander 

Commander attempts to generalize the basic cli command pattern in bash.   For tools that tend to have
a tree like command structure, this tool makes calling those subcommands trivial.  For example, given 
the following project structure:

```
bin/tool
commands/test.sh
commands/sub/test.sh
commands/sub2/test.sh
```

Given commander, they could be run via:  
```
tool test
tool sub test
tool sub2 test
```

Arguments can be passed through transparently and are correctly expanded.

# Installation

Commander does not come with any executable scripts.  It must be required by other bashum projects.

In a project.sh file:

```
depends 'commander'
```

# Usage

Inside an executable:

```
#! /usr/bin/env bash

require_bashum 'commander'
require 'lib/commander/commander.sh'

commander_run "$@"
```

Done!


## Copyright

Copyright 2013 Preston Koprivica (pkopriv2@gmail.com)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
