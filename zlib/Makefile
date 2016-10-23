NAME           := zlib
VERSION        := develop
URL            ?= https://github.com/madler/zlib
TYPE           ?= git
DISTNAME       := $(NAME)_$(VERSION)
LICENSE        := zlib
CONFIGURE      ?= autotools
CONFIGUREARGS  ?= --static
DEFAULT_CONFIGURE ?= NO
export CHOST    = arm-vita-eabi
export LD       = arm-vita-eabi-ld
export CC       = arm-vita-eabi-gcc
CFLAGS         ?= -ffast-math

TAR_STRIP      := 1

include ../include.mk

confgure: inc-configure
install: build
	make -C _build
build: inc-configure
	make -C _build LIBS=libz.a install-libs
all: build
