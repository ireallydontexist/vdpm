NAME           := freetype
VERSION        := 2.7
URL            ?= http://download.savannah.gnu.org/releases/freetype/freetype-2.7.tar.bz2
TYPE           ?= tar.gz
DISTNAME       := $(NAME)_$(VERSION)
LICENSE        := FreeType License
CONFIGURE_ARGS ?= -DWITH_ZLIB=ON -DWITH_BZip2=OFF -DWITH_PNG=ON -DWITH_HarfBuzz=OFF
CONFIGURE      ?= cmake

TAR_STRIP      := 1

-include ../include.mk

install: inc-install
build: inc-build
confgure: inc-configure
all: build
