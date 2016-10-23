NAME           := libvita2d
VERSION        := git
URL            ?= https://github.com/xerpi/libvita2d
TYPE           ?= git
DISTNAME       := $(NAME)-master
LICENSE        := MIT
CONFIGURE      ?= custom

TAR_STRIP      := 1

include ../include.mk

configure: _work
build: configure
	$(MAKE) -C _work/libvita2d
install: build
	$(MAKE) -C _work/libvita2d install PREFIX=$(PREFIX)
all: build
