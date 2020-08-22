#!/bin/bash

. example.sh

test_hello_world() {
	hello_world | grep -qFx 'Hello, World'
}

