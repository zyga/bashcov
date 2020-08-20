.PHONY: check
check: bashunit bashcov $(wildcard *_test.sh)
	./bashunit
