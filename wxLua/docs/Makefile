# Make all the docs in Linux or in Cygwin.

# The root wxLua directory.
WXLUA_DIR    = ../

#----------------------------------------------------------------------------

ALL_DOCS = binding FAQ install wxlua

# Always try to build all targets, let the other Makefiles do dep checking
.PHONY: all clean $(ALL_DOCS)

# These have to be in order of their dependencies
all: $(ALL_DOCS)

#----------------------------------------------------------------------------
# Only make the docs if the .md file is modified

binding:
    ifneq ("$(shell git status -s binding.md)", "")
	@echo Generating binding.html
	pandoc -f markdown -t html -c wxlua.css binding.md > binding.html
    else
	@echo binding.html is up to date.
    endif

FAQ:
    ifneq ("$(shell git status -s FAQ.md)", "")
	@echo Generating FAQ.html
	pandoc -f markdown -t html -c wxlua.css FAQ.md > FAQ.html
    else
	@echo FAQ.html is up to date.
    endif

install:
    ifneq ("$(shell git status -s install.md)", "")
	@echo Generating install.html
	pandoc -f markdown -t html -c wxlua.css install.md > install.html
    else
	@echo install.html is up to date.
    endif

wxlua:
    ifneq ("$(shell git status -s wxlua.md)", "")
	@echo Generating wxlua.html
	pandoc -f markdown -t html -c wxlua.css wxlua.md > wxlua.html
    else
	@echo wxlua.html is up to date.
    endif

# ---------------------------------------------------------------------------
# do nothing to clean

clean:
