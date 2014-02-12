# iOS BuildKit

BuildKit is a modular command line interface for automating iOS project builds.

Bundled build tasks include:

- Increment the build number
- Draw the build number on the app icon
- Build the app
- Run unit tests
- Generate an .ipa artefact

BuildKit is distributed as a Ruby gem with an executable that can be launched either in a continous integration server environment or on your development machine. The process is configured with a simple YAML file that describes the tasks to run and your project-specific options. This means that you can tailor the build process to meet your requirements.

**Note**

This repository was previosly known as Xcode-Project. It previously contained a project generator as well as a less developed build toolkit. The generator was removed due to the rapid advances in iOS technology. If you would like to continue using the previous version it's available [here](https://github.com/adamwaite/iOS-Build-Kit/releases).

## Requirements

- *Ruby 2.0+*: BuildKit is written and run with Ruby, you'll need a version higher than 2.0 because of the modern syntax. Check your Ruby version with `ruby -v`. [RVM](http://rvm.io/) makes it easy should you need to update.
- *Xcode command line tools*: `xcode-select --install`
- xctool: BuildKit uses [Facebook's xctool](https://github.com/facebook/xctool) to translate the standard Xcode CLI output from computer garbage to human readable form. Install with: `brew install xctool`
- *ImageMagick*: Command line graphics library used to draw on the app icon. Install with: `brew install imagemagick`.
- *GhostScript*: Command line text rendering library used to draw the version number on the app icon. Install with: `brew install ghostscript`.

## Installation

*NOTE: Gem being pushed to RubyGems soon, hang tight.*

After the requirments have been met, BuildKit can be installed with:

`gem install buildkit`

## Usage

BuildKit is launched from a command line environment with:

```
buildkit
```

Pass a configuration file to BuildKit with:

```
buildkit your-config-file.yml
```

### Configuration Files

The configuration file describes three things:

1. Task modules to run (and task-specific options)  
2. Project configuration
3. Preferences

An example configuration file:

```yaml
:tasks:
  :increment_version:
    :run: true
    :options:
  :decorate_icon:
    :run: true
    :options:
  :xcode_build:
    :run: true
    :options:
   		:log: true
  :run_tests:
    :run: true
    :options:
    	:log: true
  :create_ipa:
    :run: true
    :options:
    	:log: true

:configuration:
  :app_name: "BuildKit"
  :workspace: "/Users/adamwaite/iOS/Lib/BuildKit/iOS-Build-Kit/example/BuildKit.xcworkspace"
  :info_plist: "/Users/adamwaite/iOS/Lib/BuildKit/iOS-Build-Kit/example/BuildKit/BuildKit-Info.plist"
  :build_configuration: "Release"
  :scheme: "BuildKit"
  :sdk: "iphoneos"
  :provisioning_profile: "/Users/adamwaite/iOS/Lib/BuildKit/iOS-Build-Kit/example/Provisioning/BuildKitTest.mobileprovision"
  :code_sign: "iPhone Distribution: Alpaca Labs"
  :icon_dir: "/Users/adamwaite/iOS/Lib/BuildKit/iOS-Build-Kit/example/BuildKit/Icon/"
  :build_dir: "/Users/adamwaite/iOS/Lib/BuildKit/iOS-Build-Kit/example/Builds/"

:preferences:
  :reports: true
```

#### Tasks Configuration

The `:tasks:` symbol is used to define what tasks you would like your process to run. If `:run:` is set to `true`, that task will be executed as part of the process. Setting `:run:` to `false` will mean that the task is skipped (note that some tasks depend on others, and may cause a graceful failure).

Anything passed with the `:options:` symbol will be provided as an option. For example, taking the example configuration file above the `:log:` option on the `run_tests` task is set to `true` so the test output will be printed to the CLI.

The Tasks section in this document will describe all of the options in more detail.

#### Tasks Configuration

The `:tasks:` symbol is used to define what tasks you would like your process to run. If `:run:` is set to true, that task will be executed as part of the process. Setting `:run:` to false will mean that the task is skipped (note that some tasks depend on others, and may cause a graceful failure).




## Roadmap

- Create a build task module to enable artefact distribution by wrapping [Shenzhen](https://github.com/nomad/shenzhen).
- Add a means to allow custom task modules to be added to the process.

## Contributing

All pull requests welcome! Please ensure that all RSpec tests pass and that new code is covered with tests.

## Contact

[@adamwaite](https://twitter.com/AdamWaite)

## License

Copyright (c) 2014 Adam Waite. All rights reserved.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.