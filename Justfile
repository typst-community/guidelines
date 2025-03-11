root := justfile_directory()

src := 'src'
out := 'out'

src-file := src / 'main.typ'
out-file := out / 'api-and-style-guidelines.pdf'

export TYPST_ROOT := root
# export TYPST_FONT_PATHS := root / 'assets' / 'fonts'

# list the recipes by default
[private]
default:
	@just --list --unsorted

# compile the document once
build *args: prepare
	typst compile {{ src-file }} {{ out-file }} {{ args }}

# watch the document for changes
watch *args: prepare
	typst watch {{ src-file }} {{ out-file }} {{ args }}

# remove build artifacts
clean:
	rm -rf {{ out }}

# prepare output folders and artifacts
[private]
prepare:
	mkdir -p {{ out }}
