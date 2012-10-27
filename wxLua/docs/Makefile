# Make all the docs in Linux or in Cygwin.

# The root wxLua directory.
WXLUA_DIR    = ../

#----------------------------------------------------------------------------

ALL_DOCS = binding FAQ install wxlua

# Always try to build all targets, let the other Makefiles do dep checking
.PHONY: all clean $(ALL_BINDINGS)

# These have to be in order of their dependencies
all: $(ALL_DOCS)

#----------------------------------------------------------------------------
# Only make the docs if the .txt file is modified in SVN.

binding:
    ifneq ("$(shell svn status binding.txt)", "")
	@echo Generating binding.html
	pandoc -f markdown -t html -c wxlua.css binding.txt > binding.html
    else
	@echo binding.html is up to date.
    endif

FAQ:
    ifneq ("$(shell svn status FAQ.txt)", "")	
	@echo Generating FAQ.html
	pandoc -f markdown -t html -c wxlua.css FAQ.txt > FAQ.html
    else
	@echo FAQ.html is up to date.
    endif

install:
    ifneq ("$(shell svn status install.txt)", "")
	@echo Generating install.html
	pandoc -f markdown -t html -c wxlua.css install.txt > install.html
    else
	@echo install.html is up to date.
    endif

wxlua:
    ifneq ("$(shell svn status wxlua.txt)", "")
	@echo Generating wxlua.html
	pandoc -f markdown -t html -c wxlua.css wxlua.txt > wxlua.html
    else
	@echo wxlua.html is up to date.
    endif

# ---------------------------------------------------------------------------
# do nothing to clean

clean:
