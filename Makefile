ifndef VERBOSE
.SILENT:
endif

build:
	cd tex && lualatex -halt-on-error -file-line-error main.tex 2>&1 \
  | grep -E '^!|^.+:[0-9]+:'

