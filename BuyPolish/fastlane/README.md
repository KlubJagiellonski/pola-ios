fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios bump_version

```sh
[bundle exec] fastlane ios bump_version
```

Bump version and build number
    Options:  
    - version - new version number
    

### ios deploy

```sh
[bundle exec] fastlane ios deploy
```

Bump version and build number
    Options:  
    - version - new version number
    

### ios generate_code

```sh
[bundle exec] fastlane ios generate_code
```

Generate code using Sourcery. Require pod installation before.

### ios tests

```sh
[bundle exec] fastlane ios tests
```



### ios record_snapshots

```sh
[bundle exec] fastlane ios record_snapshots
```



### ios check_project_structure

```sh
[bundle exec] fastlane ios check_project_structure
```



### ios check_formatting

```sh
[bundle exec] fastlane ios check_formatting
```



### ios format

```sh
[bundle exec] fastlane ios format
```



### ios lint

```sh
[bundle exec] fastlane ios lint
```



----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
