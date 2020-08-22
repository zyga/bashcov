#!/bin/bash
hello_world() {
	echo "Hello, World"
}

if [ "${0##*/}" = example.sh ]; then
    hello_world
fi

