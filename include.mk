ifneq ($(wildcard $(CURDIR)/Makefile.local),)
-include $(CURDIR)/Makefile.local
endif

VITADEV := /usr/local/vitadev
TARGET  := arm-vita-eabi
PREFIX  := $(VITADEV)/$(TARGET)
CC      := $(TARGET)-gcc
CXX     := $(TARGET)-g++

# package conformance
ifeq ($(strip $(NAME)),)
$(error "$$(NAME) not set.")
endif
ifeq ($(strip $(DISTNAME)),)
$(error "$$(DISTNAME) not set.")
endif
ifeq ($(strip $(VERSION)),)
$(error "$$(VERSION) not set.")
endif
ifeq ($(strip $(URL)),)
$(error "$$(URL) not set.")
endif
ifeq ($(strip $(CONFIGURE)),)
$(error "$$(CONFIGURE) not set.")
endif
ifeq ($(strip $(LICENSE)),)
$(error "$$(LICENSE) not set.")
endif
ifeq ($(strip $(TYPE)),)
$(error "$$(TYPE) not set.")
endif

# patches target
PATCHES ?= $(wildcard $(CURDIR)/patch/*.patch)
ifneq ($(PATCHES),)
.PHONY: %.patch
%.patch:
	cd _work && patch -p1 < "$@" && touch "_patch-$(notdir $@)"
	touch "_patch-$(notdir $@)"
.PHONY: inc-patch
inc-patch: $(PATCHES)
	echo "$<"
else
inc-patch:
	\true
endif

ifneq (,$(findstring tar,$(TYPE)))
.PRECIOUS: $(DISTNAME).$(TYPE)
$(DISTNAME).$(TYPE):
	@\curl -L -C - -o "$(DISTNAME).$(TYPE)" "$(URL)"
_work: $(DISTNAME).$(TYPE)
	mkdir -p _work/
ifneq ($(strip $(TAR_STRIP)),)
	\tar xf "$(DISTNAME).$(TYPE)" --strip-components=$(TAR_STRIP) -C _work/
else
	\tar xf "$(DISTNAME).$(TYPE)" -C _work/
endif
else ifeq ($(strip $(TYPE)),git)
_work:
ifneq ($(wildcard work),)
	@cd _work && git pull
else
	@\git clone --recursive -b "$(VERSION)" "$(URL)" "_work"
endif
endif

ifeq ($(strip $(CONFIGURE)),autotools)
_CONFIGUREARGS=$(CONFIGUREARGS) --host=$(TARGET) --target=$(TARGET) --prefix=$(PREFIX)
ifneq ($(strip $(DEFAULT_CONFIGURE)),NO)
_CONFIGUREARGS=$(CONFIGUREARGS) --host=$(TARGET) --target=$(TARGET) --prefix=$(PREFIX)
else
_CONFIGUREARGS=$(CONFIGUREARGS)
endif
export prefix=$(PREFIX)
export PREFIX
inc-configure: _work
	@mkdir -p "$(CURDIR)/_build"
	cd "$(CURDIR)/_build" && ../_work/configure $(_CONFIGUREARGS)
else ifeq ($(strip $(CONFIGURE)),cmake)
_CONFIGUREARGS=$(CONFIGUREARGS) -DCMAKE_SYSTEM_NAME=Generic -DCMAKE_C_COMPILER=$(CC) \
		-DCMAKE_CXX_COMPILER=$(CXX) -DCMAKE_INSTALL_PREFIX=$(PREFIX)
inc-configure: _work
	@mkdir -p "$(CURDIR)/_build"
	cd "$(CURDIR)/_build" && cmake ../_work/ $(_CONFIGUREARGS)
else ifeq ($(strip $(CONFIGURE)),custom)
else
$(error "Unknown $$(CONFIGURE) type.")
endif

inc-build: inc-patch inc-configure
	$(MAKE) -C _build

inc-install: inc-build
	$(MAKE) -C _build install

inc-all: inc-build
	echo "$(strip $(CONFIGURE))"

.DEFAULT_GOAL := all
