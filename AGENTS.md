# AGENTS.md

## Cookbook Purpose

Provides custom resources for creating and mounting filesystems

## Agent Findings

* This cookbook is in an incremental modernization pass. Preserve existing public recipes and attributes unless a later full migration is explicitly selected.
* Dependency management should use `Policyfile.rb`; do not reintroduce Berkshelf.

## Known Limitations

## Product Scope

This cookbook manages generic Linux filesystems. It does not install a single
vendor product or external package repository. Filesystem utilities are installed
from the target operating system package repositories when a resource needs them.

## Package Availability

### APT (Debian/Ubuntu)

* Debian 12 and 13 provide core filesystem utilities through the standard APT repositories.
* Ubuntu 22.04 and 24.04 provide core filesystem utilities through the standard APT repositories.
* The default `filesystem_tools` map installs `e2fsprogs` for ext2, ext3, and ext4; `xfsprogs` for XFS; and `btrfs-progs` for Btrfs.

### DNF/YUM (RHEL Family, Fedora, Amazon Linux)

* AlmaLinux 9 and 10, CentOS Stream 9 and 10, Oracle Linux 9 and 10, Rocky Linux 9 and 10, Fedora 43, and Amazon Linux 2023 use the standard DNF/YUM package repositories.
* The default `filesystem_tools` map installs `e2fsprogs` for ext2, ext3, and ext4; `xfsprogs` for XFS; and `btrfs-progs` for Btrfs.

### Zypper (openSUSE)

* openSUSE Leap 16.0 uses the standard Zypper repositories.
* The default `filesystem_tools` map installs `e2fsprogs` for ext2, ext3, and ext4; `xfsprogs` for XFS; and `btrfs-progs` for Btrfs.
* Minimal openSUSE Leap 16.0 Dokken images need `util-linux-systemd` to provide `findmnt`, which Chef's built-in `mount` resource requires.

## Architecture Limitations

* The cookbook does not enforce architecture-specific behavior.
* CI uses Dokken images, which are available for the tested platforms and commonly publish amd64 and arm64 images for current releases.

## Source/Compiled Installation

The cookbook does not compile filesystem utilities from source.

## Platform Lifecycle Notes

* CentOS Linux 7 and 8 are discontinued and removed from Kitchen coverage.
* CentOS Stream 8 is EOL and removed from Kitchen coverage.
* Debian 9, 10, and 11 are removed from Kitchen coverage; Debian 12 and 13 remain.
* Ubuntu 18.04, 20.04, and 23.04 are removed from Kitchen coverage; Ubuntu 22.04 and 24.04 remain.
* openSUSE Leap 15.x coverage is replaced by openSUSE Leap 16.0.
* Oracle Linux 7 is removed because basic support ended on 31 December 2024.

## Evidence

* OS lifecycle data was checked against endoflife.date on 24 April 2026.
* Dokken image availability was checked for the Kitchen platforms on Docker Hub on 24 April 2026.
