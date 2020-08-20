# bashcov and bashunit - unit testing for bash

This repository contains two tools. `bashcov` is a generic execution coverage
tracer for bash. It can be used to examine code coverage of arbitrary script
executions. `bashunit` executes unit tests from files matching `*_test.sh`, and
generates coverage analysis for all the tested scripts.

## bashunit - unit testing for bash scripts

Using `bashunit` you can create practical unit tests for bash programs. Using
built-in coverage analysis and convention-based code organization, you can
incrementally integrate test code into an existing shell project.

Please review the unit tests for `bashcov` as an example.

## bashcov - execution coverage for bash scripts

Using `bashcov` you can run a bash script and measure execution coverage. This
can be useful for writing and measuring unit tests for bash programs.

## Example:

Using bashcov on itself, to print the help message and quit:

```
./bashcov ./bashcov
```

This executes bashcov under a trace, processes the trace file and creates
`bashcov.coverage`. In general all executed (or sourced and executed) scripts
are processed. The resulting coverage analysis is written to `bashcov.coverage`
and is modeled after `gcov` output.

For the example above, with most of the script body and license omitted, the
output looks as follows. The integer indicates the number of times a given line
was executed.

```
  -: #!/bin/bash
  Licence text omitted for brevity
  -: 
  1: declare -A -i cov_files  # set of files encountered
  1: declare -A -i cov_lines  # set of file:line pairs executed
  -: 
  -: main() {
  1: 	if [ $# -eq 0 ]; then
  1: 		echo "usage: bashcov SCRIPT [ARGUMENTS]"
  1: 		exit 0
  -: 	fi
  Body of "main", omitted for brevity
  -: }
  -: 
  1: main "$@"
```
