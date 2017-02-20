# OpenBSD Thumbdrive Utilities

Tools to fetch and install OpenBSD images to a thumbdrive.

# WARNING:
**These utilities can cause irreperable damage to disk data!**

**Make sure you understand what they do before using.**


## FILES:
* Makefile
* Makefile.inc.sample
* usb_make
* README.md

## Targets
* check - Check for changes to snapshots
* check-rel - Check for changes to the current release
* get - Get the current snapshot for the selected ARCH
* get-rel - Get the current releaes for the selected ARCH
* disk - Make disk using the current snapshot for the selected ARCH
* disk-rel - Make disk using the current release for the selected ARCH

# Variables:
  Override in Makefile.inc or with `make VAR=VALUE`.
  
* SERVER - Server to check via rsync
* REL - Which release to track (from rsync $(SERVER)::)
* ARCH - default: `uname -m`
* CUR_DIR - default: $(ARCH)/cur/
* REL_DIR - default: $(ARCH)/($REL)/
* CUR_IMAGE - default: highest numbered installnn.fs in $(CUR_DIR)
* REL_IMAGE - default: $(REL_DIR)/install$(REL).fs
* INCLUDES - files to download
* EXCLUDES - default: *

## NOTE:
SERVER has no default, with SERVER=value or create Makefile.inc

# Makefile.inc
Use to set install-specific overrides.

Excluded in .gitignore

# Examples:
## Download snapshot for current machine architecture
```
make SERVER=ftp5.usa.openbsd.org get
```

## Download relase for current machine architecture
```
make SERVER=ftp5.usa.openbsd.org get-rel
```

## Download snapshot for i386
```
make ARCH=i386 SERVER=ftp5.usa.openbsd.org get
```

## Make snapshot disk for current machine architecture
```
make disk
```

## Make release disk for current machine architecture
```
make disk-rel
```

## Make Current Snapshot for i386
```
make ARCH=i386 disk
```

# TODO:
* Add support for architectures that don't have an installnn.fs
* Perhaps write cdnn.iso to CD drive







