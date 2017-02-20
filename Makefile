#
# Copyright (c) 2016 Aaron Poffenberger <akp@hypernote.com>
#
# Permission to use, copy, modify, and distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
#


#
# OpenBSD Thumbdrive Utilities Makefile
#
# Requirements:
#    rsync
#
# Targets:
#    check - Check for changes to snapshots
#    check-rel - Check for changes to the current release
#    get - Get the current snapshot for the selected ARCH
#    get-rel - Get the current releaes for the selected ARCH
#    disk - Make disk using the current snapshot for the selected ARCH
#    disk-rel - Make disk using the current release for the selected ARCH
#
#
# Variables:
#    Override in Makefile.inc or with `make VAR=VALUE`.
#
#    SERVER - Server to check via rsync
#    REL - Which release to track (from rsync $(SERVER)::)
#    ARCH - default: `uname -m`
#    CUR_DIR - default: $(ARCH)/cur/
#    REL_DIR - default: $(ARCH)/($REL)/
#    CUR_IMAGE - default: highest numbered installnn.fs in $(CUR_DIR)
#    REL_IMAGE - default: $(REL_DIR)/install$(REL).fs
#
# NOTE:
#    SERVER has no default, with SERVER=value or create Makefile.inc
#
#    Excluded in .gitignore
#
# Examples:
#    Download snapshot for current machine architecture
#    make SERVER=ftp5.usa.openbsd.org get
#
#    Download release for current machine architecture
#    make SERVER=ftp5.usa.openbsd.org get-rel
#
#    Download snapshot for i386
#    make ARCH=i386 SERVER=ftp5.usa.openbsd.org get
#
#    Make snapshot disk for current machine architecture
#    make disk
#
#    Make release disk for current machine architecture
#    make disk-rel
#
#    Make Current Snapshot for i386
#    make ARCH=i386 disk
#
# TODO:
#    Add support for architectures that don't have an installnn.fs
#    Perhaps write cdnn.iso to CD drive
#

.include "Makefile.inc"

REL?!=rsync -v $(SERVER):: 2>/dev/null| grep 'release (' | tail -n 1 | cut -d ' ' -f 1

# Fail if SERVER is empty
.poison empty SERVER


ARCH?!=uname -m
CUR_DIR?=./$(ARCH)/cur
REL_DIR?=./$(ARCH)/$(REL)

CUR_IMAGE?!=find $(CUR_DIR) -name 'install*.fs' -print | sort -r | head -n 1
REL_IMAGE?!=find $(REL_DIR) -name 'install*.fs' -print | sort -r | head -n 1

CURPATH?=$(SERVER)::snapshots/$(ARCH)/
RELPATH?=$(SERVER)::$(REL)/$(ARCH)/

FLAGS:=--include=INSTALL.$(ARCH) --include=SHA256 --include=index.txt --include=install*.fs --exclude=* --progress


check: $(CUR_DIR)
	@echo Check for changes to snapshots for  for $(ARCH)
	rsync -aHvz $(CURPATH) $(CUR_DIR) $(FLAGS) --dry-run

get: $(CUR_DIR)
	@echo Get snapshot for $(ARCH)
	rsync -aHvz $(CURPATH) $(CUR_DIR) $(FLAGS)

disk: $(CUR_DIR)
	@echo Make disk using the current snapshot for $(ARCH)
	@./usbdisk_make $(CUR_IMAGE)

$(CUR_DIR):
	mkdir -p $(CUR_DIR)

.ifdef REL
check-rel: $(REL_DIR)
	@echo Check for changes to the current release for $(ARCH)
	rsync -aHvz $(RELPATH) $(REL_DIR) $(FLAGS) --dry-run

get-rel: $(REL_DIR)
	@echo Get release for $(ARCH)
	rsync -aHvz $(RELPATH) $(REL_DIR) $(FLAGS)

disk-rel: $(REL_DIR)
	@echo Make disk using the current release for $(ARCH)
	@./usbdisk_make $(REL_IMAGE)

$(REL_DIR):
	mkdir -p $(REL_DIR)
.endif
