#!/bin/sh

NAME=libpng
VERSION=1.6.23
URL=http://download.sourceforge.net/libpng/libpng-1.6.23.tar.gz
TYPE=tar.gz
LICENSE="libpng license"

SCRIPT_NAME=$0

download()
{
	mkdir -p "_${NAME}_work"
	cd "_${NAME}_work"
	if [ ! -f "${NAME}-${VERSION}.${TYPE}" ]; then
	\curl -o "${NAME}-${VERSION}.${TYPE}" "${URL}"
	fi
	mkdir -p src
	tar xf "${NAME}-${VERSION}.${TYPE}" --strip-components=1 -C src
	cd -
}

configure()
{
	OK=true
	for dep in zlib; do
		if [ ! -f /usr/local/vitadev/arm-vita-eabi/lib/vdpm/$dep ]; then
			./${dep}.sh install
		fi
		if [ ! -f /usr/local/vitadev/arm-vita-eabi/lib/vdpm/$dep ]; then
			OK=false
		fi
	done
	if ! $OK; then
		echo "Dependencies not met."
		exit 1
	fi
	if [ -z "$1" ]; then
		PREFIX=/usr/local/vitadev/arm-vita-eabi
	else
		PREFIX=$PREFIX
	fi
	mkdir -p "_${NAME}_build"
	cd "_${NAME}_build"
	export CFLAGS=-DPNG_NO_CONSOLE_IO
	../_${NAME}_work/src/configure --disable-shared --enable-static \
		--enable-arm-neon --host=arm-vita-eabi --prefix="$PREFIX"
	cd -
}

build()
{
	if [ ! -d "_${NAME}_build" ]; then
		echo "Please run ${SCRIPT_NAME} configure"
	else
		make -C "_${NAME}_build"
	fi
}

install()
{
	if [ ! -d "_${NAME}_build" ]; then
		echo "Please run ${SCRIPT_NAME} configure build"
	else
		DESTDIR=$1 make -C "_${NAME}_build" install
	fi
	: > /usr/local/vitadev/arm-vita-eabi/lib/vdpm/${NAME}
}

package()
{
	mkdir "_${NAME}_stage"
	install "_${NAME}_stage"
}

all()
{
	download
	configure
	build
	install
	package
}

clean()
{
	rm -rf "_${NAME}_build"
}

if [ "$#" -lt 1 ]; then
	all
else
	for step in $@; do
		eval $step
	done
fi

