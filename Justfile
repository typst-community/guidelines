root := justfile_directory()
main-src := root / 'src' / 'main.typ'
main-out := root / 'out' / 'api-and-style-guidelines.pdf'

export TYPST_ROOT := root
# export TYPST_FONT_PATHS := root / 'assets' / 'fonts'

# list the recipes by default
[private]
default:
	@just --list --unsorted

# prepare output folders and artifacts
[private]
init:
	mkdir --parents out

# run typst with the required environment variables
typst *args:
	typst {{ args }}

# run typst-preview on the main document
preview *args:
	typst-preview --root {{ root }} {{ main-src }} {{ args }}

# run typst compile on the main document
build *args: init (typst 'compile' main-src main-out args)

# run typst initwtch on the main document
watch *args: init (typst 'watch' main-src main-out args)
