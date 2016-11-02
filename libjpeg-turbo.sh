NAME           := libjpeg-turbo
VERSION        := 1.5.0
URL            ?= http://downloads.sourceforge.net/libjpeg-turbo/libjpeg-turbo-1.5.0.tar.gz
TYPE           ?= tar.gz
DISTNAME       := $(NAME)_$(VERSION)
LICENSE        := FreeType License
CONFIGURE_ARGS ?= --disable-shared --enable-static --without-simd
CONFIGURE      ?= autotools

TAR_STRIP      := 1

-include ../include.mk

confgure: inc-configure
build: configure
	$(MAKE) -C build PROGRAMS=
install: build
	$(MAKE) -C build install-libLTLIBRARIES install-data-am
all: build
