NAME           := zlib
VERSION        := 1.2.8
URL            ?= http://zlib.net/zlib-1.2.8.tar.gz
TYPE           ?= tar.gz
DISTNAME       := $(NAME)_$(VERSION)
LICENSE        := zlib
CONFIGURE      ?= cmake
CFLAGS         ?= -ffast-math

TAR_STRIP      := 1

include ../include.mk

install: inc-install
build: inc-build
confgure: inc-configure
all: build
