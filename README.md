# Xcode iOS Project Configuration

Waiting on permission to open source this project. It should be coming soon!

**Features:**

- Clean and organised directory structure mapping filesystem directories to Xcode groupings.
- Pre-configured unit testing target with OCUnit.
- Highly customisable and extendable continuous integration toolkit written in Ruby. Existing tasks include:
    - Increment the build number
    - Overlay the build number on the application icon
    - Build the app
    - Run unit tests
    - Generate an .ipa artefact
- [CocoaPods](http://cocoapods.org) initialised xcworkspace for management of third party Objective-C dependencies.


## Requirements

As Mac OSX users and iOS developers it's most likely that the following are installed anyway, but just in case, ensure installation of:

1. **Xcode's command line tools:** (in the download tab of the Xcode preferences menu).

2. **Homebrew:** Two dependencies are installed with [Homebrew](http://mxcl.github.io/homebrew/) OSX package manager - [Facebook's xctool](https://github.com/facebook/xctool) for human readable CLI output and [ImageMagick](http://www.imagemagick.org) the code driven Photoshop. 

3. **Ruby Gems:** The continuous integration tooling is written in Ruby. [RubyGems](http://rubygems.org) is required to install some gems that power the toolkit, those being RMagick and Rake.

## Configuration

1. Fire up a terminal session and create a directory to house your new app:

        $ mkdir <CoolAppName>
2. Jump into the new directory:

        $ cd <CoolAppName>
3. Clone the repo:

        $ git clone git@github.com:adamwaite/XcodeProject.git
4. Run configure.rb:

        $ ruby configure.rb
   This will rename all the the paths, files and project setting to match the given application name, install: xctool, Imagemagick, RMagick, Rake, and finally trash any unecessary files such as this readme.
5. Write your app!

## Project Structure

In a Rails-like [convention over configuration](http://en.wikipedia.org/wiki/Convention_over_configuration) approach, and knowing that MVC is central to a good design for a Cocoa application, the application filesystem has been structured to house application code, tests, assets and data in an organised fashion. Filesystem directories are mapped to Xcode groups, no more messy project folders!

```
.
├── APPNAME
│   ├── APPNAME
│   │   ├── App
│   │   ├── AppDelegate.h
│   │   ├── AppDelegate.m
│   │   ├── Build
│   │   ├── Controllers
│   │   ├── Lib
│   │   ├── Models
│   │   ├── Resources
│   │   │   ├── Assets
│   │   │   │   ├── Images
│   │   │   │   │   ├── Default
│   │   │   │   │   │   ├── Default-568h@2x.png
│   │   │   │   │   │   ├── Default.png
│   │   │   │   │   │   └── Default@2x.png
│   │   │   │   │   └── Icon
│   │   │   │   │       ├── Icon.png
│   │   │   │   │       ├── Icon@2x.png
│   │   │   │   ├── Sound
│   │   │   │   └── Video
│   │   │   └── Data
│   │   ├── SupportingFiles
│   │   │   ├── APPNAME-Info.plist
│   │   │   ├── APPNAME-Prefix.pch
│   │   │   ├── en.lproj
│   │   │   └── main.m
│   │   ├── Vendor
│   │   └── Views
│   │       └── iPhone.storyboard
│   ├── APPNAME.xcodeproj
│   ├── APPNAME.xcworkspace
│   ├── APPNAMETests
│   │   ├── APPNAMETests.h
│   │   ├── APPNAMETests.m
│   │   ├── App
│   │   ├── Controllers
│   │   ├── Models
│   │   ├── SupportingFiles
│   │   │   ├── APPNAMETests-Info.plist
│   │   │   └── en.lproj
│   │   └── Views
│   ├── Podfile
│   ├── Podfile.lock
│   ├── Pods
│   │   ├── Manifest.lock
│   │   └── Pods.xcodeproj
│   │       └── project.pbxproj
│   └── Provisioning
├── ContiniOSIntegration
│   ├── Rakefile
│   ├── builds
│   │   └── README.md
│   ├── configs
│   │   └── config.yml
│   ├── continios_integration.rb
│   ├── reports
│   ├── tasks
│   │   ├── create_ipa.rb
│   │   ├── decorate_icon.rb
│   │   ├── increment_version.rb
│   │   ├── run_tests.rb
│   │   └── xcode_build.rb
│   └── utils
│       └── existing_version_number.rb
├── configure.rb
├── configure_backup.rb
└── img
    ├── create_ipa.png
    ├── decorate_icon.png
    ├── increment_version.png
    ├── run_tests.png
    ├── tasktemplate.png
    └── xcode_build.png
```

## OCUnit Testing Target

The app project has been configured with an OCUnit testing target. There is one existing test that compares `YES` to `NO` and fails miserably, just to make sure everything is working as it should.

## CocoaPods Dependency Management

The configuration uses CocoaPods for management of Objective-C dependencies. The *podspec* is blank as is, to add dependencies add pods to the *Podfile*:

    pod 'AFNetworking'
    pod 'SocketRocket'
    pod 'Kiwi'

and run:

    $ pod install
    
For more information [see the CocoaPods getting started guide](http://cocoapods.org)

## ContiniOS Integration Toolkit

**Warning:** This is yet to be used and tested alongside a continuous integration server such as Jenkins. It will likely require some care as-is.

The continuous integration and build system tooling is written in Ruby and executed with [Rake](http://rake.rubyforge.org). 

Options are passed to the Rake process in the form a YAML configuration file that describes the build tasks to be run and any further options. 

The task structure is modular, new tasks can be added with no disruption of the existing process. Some of the tasks (including the run_tests and the xcode_build task) wrap around [Facebook's xctool](https://github.com/facebook/xctool) system for human readable output.

**Features**

- Pass different configuration files to Rake to customise build process behaviour.
- Place new task modules in the *task/* directory to add new build functionality to the process.
- Included build modules:
	- increment_version - this increments the build number of the version in the plist
	- decorate_icon - uses RMagick to overlay the new version number on top of the icon files
	- xcode_build - build the application
	- run_tests - run the OCUnit tests
	- create_ipa - package the app into an .ipa file and place in the builds/ directory

### Configuration Files

Configuration files are in YAML format. The files are parsed by Ruby and passed to the Rake task for execution.

All commands under the `:run_tasks` symbol are executed based on the boolean that follows. For example: `increment_version: true` means that the system will look in the *tasks/* directory and execute the method defined in the `increment_version.rb` file (convention of the filename matching the task). Setting a task to `false` will ensure that the tool to skips that task.

Any parameters under the `:options` symbol can be used to override defaults. The system is designed to work with the directory structure provided above. For example, the system will look for the provisioning profiles to sign the app in the *../Provisioning/* directory. This behaviour can be overridden in the *:options*.

The default configuration looks like this:

```yaml
# iOS Build Process Configuration
# -------------------------------
# This is the default build configuration, override by copying the file and passing to the build tool with:
# $ `rake default [your_config_file.yml]`

:run_tasks:
  increment_version: true														# increments the build version number in the app-info.plist
  decorate_icon: true																# overlays the version number on the app icon	
  xcode_build: true																	# runs the xcodebuild command to build the app
  run_tests: true																		# run unit tests
  create_ipa: true																	# packages the app into an .ipa for distribution
:options:
  :app_name: "APPNAME"															# name of the application (this should auto-set running configure.rb)
  :app_dir:																					# app resources folder (default: APPNAME/APPNAME)
  :scheme:																					# build scheme (default: the "App" scheme included with the workspace)
  :build_configuration:															# build configuration (default: "Release")
  :code_sign:																				# code signing identity (find this next to your code signing identity in Xcode)
  :provisioning_path:																# provisioning profile directory (default: "APPNAME/Provisioning/")
  :provisioning_profile:														# provisioning profile file (defaults to the first provisioning profile found in :provisioning_path)
  :icon_path:																				# icon directory (defaults to "APPNAME/Resources/Assets/Images/Icon/")
  :build_dir_path:																	# path to build directory (default: "builds/")
  :sdk:																							# build SDK (default: "iphoneos")
```

Note that some tasks will gracefully fail if it depends on a parameter and it hasn't been provided in the config.

### Usage

Running:

    rake

Will launch the default build process and run the process defined in the **default configuration file:** *config.yml*.

Creating a custom config file in the configs directory and running:

    rake custom[configs/my_build_spec.yml]

Will launch a build process with the configuration specified in the *my_build_spec.yml* file. With this method multiple build processes may be defined by creating multiple config files.

### Existing Tasks

#### increment_version

Increments the version number in the app's plist:

![increment_version](img/increment_version.png)

#### decorate_icon

Decorates the icon with the version (new version if increment_version was run):

![decorate_icon](img/decorate_icon.png)

#### xcode_build

Builds the project:

![xcode_build](img/xcode_build.png)

### run_tests

Runs unit tests:

![run_tests](img/run_tests.png)

#### create_ipa

Creates an .ipa file for install.

![create_ipa](img/create_ipa.png)

### Creating a New Task

#### Writing the task

Create a new task by dropping a *new_task.rb* file in the tasks directory. The task must be of format:

```ruby
module ContiniOSIntegration
	def self.new_task
		puts "New task code goes here!"
	end
end
```

#### Running the task

To run the new task, simply add a line containing the new task to the `:run_tasks` list in a config file to be passed to Rake (for example: `new_task: true`).

The task runner instance is defined in *continios_integration.rb*. 

#### Task settings

There is an accessible settings and options hash that's accessible in any task through the runner instance.

Set a new value like this:

    runner = ContiniOSIntegration::CITaskRunner.instance
    runner.set_config :key, value

Get a value like this:

    runner = ContiniOSIntegration::CITaskRunner.instance
    runner.get_config :key

New utility methods can be added in the *utils/* folder - they must be `require`d in a task for usage.

## Roadmap

Potential future tasks:
- Auto updload to TestFlight using [@mattt](https://twitter.com/mattt)'s [Shenzhen](https://github.com/nomad/shenzhen).
- Save build reports in a report directory (probably extending the run_tests task by providing an option)

## Contributing

Pull requests welcome! Feel free to tidy up my Ruby and add any new modules to the CI system. Maybe you could create some interesting Podspecs? Or perhaps a fork using a different testing framework such as [Kiwi](https://github.com/allending/Kiwi)? Go wild.

## Contact

[@adamwaite](https://twitter.com/AdamWaite)

## License

MIT

Copyright (c) 2013 Adam Waite. All rights reserved.

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