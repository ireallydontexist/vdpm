ifneq ($(wildcard $(CURDIR)/Makefile.local),)
-include $(CURDIR)/Makefile.local
endif

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
	@\git clone --recursive "$(URL)" "_work"
endif
endif

.PHONY: configure
ifeq ($(strip $(CONFIGURE)),autotools)
inc-configure: _work
	@mkdir -p "$(CURDIR)/_build"
	cd "$(CURDIR)/_build" && ../_work/configure $(CONFIGUREARGS)
else ifeq ($(strip $(CONFIGURE)),cmake)
inc-configure: _work
	@mkdir -p "$(CURDIR)/_build"
	cd "$(CURDIR)/_build" && cmake ../_work/ $(CONFIGUREARGS)
else ifeq ($(strip $(CONFIGURE)),custom)
else
$(error "Unknown $$(CONFIGURE) type.")
endif

.PHONY: inc-build
inc-build: inc-patch inc-configure
	$(MAKE) -C _build

.PHONY: inc-all
inc-all: inc-build
	echo "$(strip $(CONFIGURE))"

.DEFAULT_GOAL := all
