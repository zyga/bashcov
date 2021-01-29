include z.mk
bashcov.Interpreter=bash
$(eval $(call ZMK.Expand,Script,bashcov))
bashunit.Interpreter=bash
$(eval $(call ZMK.Expand,Script,bashunit))

check:: bashunit bashcov $(wildcard *_test.sh)
	./bashunit
