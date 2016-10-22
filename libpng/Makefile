NAME           := libpng
VERSION        := 1.6.23
URL            ?= http://download.sourceforge.net/libpng/libpng-1.6.23.tar.gz
TYPE           ?= tar.gz
DISTNAME       := $(NAME)_$(VERSION)
LICENSE        := libpng license
CONFIGURE      ?= autotools
CONFIGURE_ARGS ?= --disable-shared --enable-static --enable-arm-neon
CFLAGS         ?= -DPNG_NO_CONSOLE_IO
DEPENDS        := zlib

TAR_STRIP      := 1

include ../include.mk

install: inc-install
build: inc-build
confgure: inc-configure
all: build
