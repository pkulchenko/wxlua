#----------------------------------------------------------------------------
# Purpose:     wxLua application Makefile
# Author:      Daniel Collins
# Created:     21/09/2025
# Copyright:   (c) 2025 Daniel Collins
# Licence:     wxWidgets licence
#----------------------------------------------------------------------------

# This compiles a stand-alone application (wxLua) and demonstrates how to make
# use of the wxLua library Makefile from another project.

ifeq ($(OS),Windows_NT)
	APP := wxlua.exe
else
	APP := wxlua
endif

OBJS := \
	wxlua.o

.PHONY: all
all: $(APP)

# Define WXLUA_ROOT so the library Makefile file knows where the sources are.
WXLUA_ROOT := ../../
include ../../Makefile

# Depend on wxlua-clean to run the library clean target too.
clean: wxlua-clean
	rm -f $(OBJS)
	rm -f $(APP)

# We take advantage of the library Makefile to provide us compiler flags for
# building against Lua and wxWidgets. If we were compiling wxLua as a part of a
# larger application we could instead handle that ourselves and ensure the flag
# variables are set prior to including the library Makefile for it to use ours
# instead.

$(APP): $(OBJS) $(WXLUA_LIB) $(WXLUA_DEBUGGER_LIB) $(WXLUA_DEBUG_LIB) $(WXBIND_LIB)
	$(CXX) $(CXXFLAGS) -o $@ $^ $(LUA_LIBS) $(WX_LIBS)

# We add $(WXLUA_BIND_HEADERS) as a prerequisite here to ensure all of wxLua's
# bindings are built before our sources. This is a bit of a crude sledgehammer
# solution to the issue of build ordering, but unless you're making frequent
# changes to wxLua within the scope of a large application its probably not
# worth the extra effort of tracking which of your sources depend on which of
# wxLua's bindings.

%.o: %.cpp $(WXLUA_BIND_HEADERS)
	$(CXX) $(CXXFLAGS) $(LUA_CFLAGS) $(WX_CXXFLAGS) -I$(WXLUA_ROOT)/include/ -c -o $@ $<
