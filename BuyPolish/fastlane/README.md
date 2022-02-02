fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew install fastlane`

# Available Actions
## iOS
### ios bump_version
```
fastlane ios bump_version
```
Bump version and build number
    Options:  
    - version - new version number
    
### ios deploy
```
fastlane ios deploy
```
Bump version and build number
    Options:  
    - version - new version number
    
### ios generate_code
```
fastlane ios generate_code
```
Generate code using Sourcery. Require pod installation before.
### ios tests
```
fastlane ios tests
```

### ios record_snapshots
```
fastlane ios record_snapshots
```

### ios check_project_structure
```
fastlane ios check_project_structure
```

### ios check_formatting
```
fastlane ios check_formatting
```

### ios format
```
fastlane ios format
```

### ios lint
```
fastlane ios lint
```


----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
