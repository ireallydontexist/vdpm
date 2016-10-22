NAME           := fftw
VERSION        := 3.3.5
URL            ?= http://www.fftw.org/fftw-3.3.5.tar.gz
TYPE           ?= tar.gz
DISTNAME       := $(NAME)_$(VERSION)
LICENSE        := GPLv2+
CONFIGURE      ?= autotools
CONFIGURE_ARGS ?= --disable-shared --enable-static --disable-fortran --without-g77-wrappers
CFLAGS         ?= -ffast-math

TAR_STRIP      := 1

-include ../include.mk

confgure: inc-configure
install: inc-install
build: inc-build
all: build
