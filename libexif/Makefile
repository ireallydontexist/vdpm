NAME           := libexif
VERSION        := 0.6.21
URL            ?= http://sourceforge.net/projects/libexif/files/libexif/0.6.21/libexif-0.6.21.tar.bz2
TYPE           ?= tar.bz2
DISTNAME       := $(NAME)_$(VERSION)
LICENSE        := LGPL2.1
CONFIGURE_ARGS ?= --disable-shared --enable-static
CONFIGURE      ?= autotools

TAR_STRIP      := 1

-include ../include.mk

install: inc-install
build: inc-build
confgure: inc-configure
all: build
