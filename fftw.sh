#!/bin/sh

NAME=fftw
VERSION=3.3.5
URL=http://www.fftw.org/fftw-3.3.5.tar.gz
TYPE=tar.gz
LICENSE=GPLv2+

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
	if [ -z "$1" ]; then
		PREFIX=/usr/local/vitadev/arm-vita-eabi
	else
		PREFIX=$PREFIX
	fi
	mkdir -p "_${NAME}_build"
	cd "_${NAME}_build"
	export CFLAGS=-ffast-math
	../_${NAME}_work/src/configure --disable-shared --enable-static --disable-fortran \
	--without-g77-wrappers --host=arm-vita-eabi --prefix=$PREFIX
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

