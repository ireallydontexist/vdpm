NAME=zlib
VERSION=develop
URL=https://github.com/madler/zlib
TYPE=git
LICENSE=zlib

TAR_STRIP      := 1

include ../include.mk

all: build

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
	export CHOST=arm-vita-eabi
	export LD=arm-vita-eabi-ld
	export CC=arm-vita-eabi-gcc
	export prefix=$PREFIX
	../_${NAME}_work/src/configure --static
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
		DESTDIR=$1 make -C "_${NAME}_build" LIBS=libz.a install-libs
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

