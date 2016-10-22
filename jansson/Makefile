NAME           := jansson
VERSION        := 2.7
URL            ?= http://www.digip.org/jansson/releases/jansson-2.7.tar.bz2
TYPE           ?= tar.bz2
DISTNAME       := $(NAME)_$(VERSION)
LICENSE        := MIT
CONFIGURE      ?= autotools
CONFIGURE_ARGS ?= --disable-shared --enable-static --without-simd
CFLAGS         ?= -ffast-math

TAR_STRIP      := 1

-include ../include.mk

install: inc-install
build: inc-build
confgure: inc-configure
all: build
