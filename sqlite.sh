NAME           := sqlite3
VERSION        := 3130000
URL            ?= https://www.sqlite.org/2016/sqlite-autoconf-3130000.tar.gz
TYPE           ?= tar.gz
DISTNAME       := $(NAME)_$(VERSION)
LICENSE        := zlib
CONFIGURE      ?= autotools
CONFIGURE_ARGS ?= --disable-shared --disable-threadsafe
CFLAGS         ?= -DSQLITE_OS_OTHER=1 -ffat-lto-objects -flto

TAR_STRIP      := 1

include ../include.mk

confgure: inc-configure
build: configure
	$(MAKE) -C _build libsqlite3.la
install: build
	$(MAKE) -C _build install-libLTLIBRARIES install-data-am
all: build
