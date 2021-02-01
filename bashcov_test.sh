#!/bin/bash

. ./bashcov


test_bashcov_help_text() {
	bashcov_main | grep -qFx 'usage: bashcov SCRIPT [ARGUMENTS]'
}

test_bashcov_help_exit_code() {
	bashcov_main
}

test_bashcov_trace_call() {
	trace_file="$(mktemp --suffix=.xtrace)"
	script="$(mktemp --suffix=.sh)"
	log_file="$(mktemp --suffix=.log)"

	# shellcheck disable=SC2064
	trap "rm -f $trace_file $script $log_file" RETURN
	{
		echo '#!/bin/sh'
		echo 'echo "nargs: $#"'
		# shellcheck disable=SC2016
		echo 'for i in $(seq 3); do'
		# shellcheck disable=SC2016
		echo '  echo "i=$i"'
		echo 'done'
	} >"$script"

	bashcov_trace_call "$trace_file" "$script" >"$log_file"

	# The log file contains the expected output
	grep -qFx 'nargs: 0' <"$log_file"
	grep -qFx 'i=1' <"$log_file"
	grep -qFx 'i=2' <"$log_file"
	grep -qFx 'i=3' <"$log_file"

	# The trace file contains leading bashcov trace which shows how tracing is configured.
	grep -E -qx '[+]./bashcov:[0-9]+# BASH_XTRACEFD=3' <"$trace_file"
	# The . below represents single quote that is easier to handle this way.
	grep -E -qx '[+]./bashcov:[0-9]+# PS4=.[+][$]BASH_SOURCE:[$]LINENO# .' <"$trace_file"
	grep -E -qx '[+]./bashcov:[0-9]+# set -e' <"$trace_file"
	grep -E -qx '[+]./bashcov:[0-9]+# set -x' <"$trace_file"
}

test_bashcov_parse_trace() {
	trace_file="$(mktemp)"
	# shellcheck disable=SC2064
	trap "rm -f $trace_file" EXIT
	{
		echo "+foo.sh:1# ..."
		# Nested execution is handled as well
		echo "++bar.sh:2# ..."
		# Repeated execution of the same line is counted
		echo "+froz.sh:3# first run"
		echo "+froz.sh:3# second run"
		# Traces from files matching *_test.sh are ignored.
		echo "+quux_test.sh:4# ..."
		# Traces without a file name are ignored.
		echo "+:5# ..."
	} >"$trace_file"
	# NOTE: we are not using echo ... | bashcov_parse_trace as that would
	# run the parser in a sub-shell, preventing us from getting the data out.
	bashcov_parse_trace <"$trace_file"

	test "${cov_files[foo.sh]}" -eq 1
	test "${cov_files[bar.sh]}" -eq 1
	test "${cov_files[froz.sh]}" -eq 1
	test "${cov_files[quux_test.sh]}" = ""
	test "${cov_lines[foo.sh:1]}" -eq 1
	test "${cov_lines[bar.sh:2]}" -eq 1
	test "${cov_lines[froz.sh:3]}" -eq 2
}
