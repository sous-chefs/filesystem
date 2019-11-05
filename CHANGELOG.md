# Changelog

Change Log All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) and this project adheres to [Semantic Versioning](http://semver.org/).

## [unreleased]

## [1.0.0] - 2018-03-14

- Fix idempotence of 'wait for device' block
- Remove possible double format of disks if force
- Do not perform test mount if ignore_existing and force
- Use truthy value of ignore_existing rather than nil?
- updated mount resource in providers/default.rb to notify directory resource immediately to fix mount permissions after mounting
- Fix linting errors
- Updated default provider to notify directory resource immediately upon mounting filesystem. (#37)
- Reorganise code to only format disks once
- Fix missing /etc/fstab file in centos7 image
- Remove xfsprogs-devel

## [0.12.0] - 2017-04-24

- removed xfs dependency, installing packages in default.rb

## [0.11.1] - 2017-03-20

- fixed issue with frozen being a ruby default function

## [0.11.0] - 2017-03-13

- Added CHANGELOG.md
- Added CONTRIBUTING.md
- Removed Berksfile.lock
- Added CODE_OF_CONDUCT.md
- Added Delivery
- Added Travis
- Added Test-Kitchen, Kitchen-dokken
- updated Berksfile to supermarket
- updated lvm >= 1.1
- updated to sous-chefs

## [0.10.6] - 2016-01-21

## [0.10.2] - 2015-10-13

- dont wait for network devices they won't exist
- make fetches to fspackages not fail on unknown types

## Added

[0.10.2]: https://github.com/sous-chefs/filesystem/compare/v0.8.2...v0.10.2
[0.10.6]: https://github.com/sous-chefs/filesystem/compare/v0.10.2...v0.10.6
[0.11.0]: https://github.com/sous-chefs/filesystem/compare/v0.10.6...v0.11.0
[0.11.1]: https://github.com/sous-chefs/filesystem/compare/v0.11.0...v0.11.1
[0.12.0]: https://github.com/sous-chefs/filesystem/compare/v0.11.1...v0.12.0
[1.0.0]: https://github.com/sous-chefs/filesystem/compare/v0.12.0...v1.0.0
[unreleased]: https://github.com/sous-chefs/filesystem/compare/v0.12.0...HEAD
