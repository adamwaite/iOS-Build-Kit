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