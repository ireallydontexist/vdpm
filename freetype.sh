#!/bin/sh

NAME=freetype
VERSION=2.7
URL=http://download.savannah.gnu.org/releases/freetype/freetype-2.7.tar.bz2
TYPE=tar.gz
LICENSE="FreeType License"

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
	for dep in zlib libpng; do
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
	export CFLAGS=
	cmake ../_${NAME}_work/src/configure
		-DWITH_ZLIB=ON \
		-DWITH_BZip2=OFF \
		-DWITH_PNG=ON \
		-DWITH_HarfBuzz=OFF \
		-DCMAKE_SYSTEM_NAME=Generic \
		-DCMAKE_C_COMPILER=arm-vita-eabi-gcc \
		-DCMAKE_CXX_COMPILER=arm-vita-eabi-g++ \
		-DCMAKE_FIND_ROOT_PATH=/usr/local/vitadev \
		-DCMAKE_INSTALL_PREFIX=$PREFIX
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

