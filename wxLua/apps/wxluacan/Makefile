#----------------------------------------------------------------------------
# Purpose:     wxLuaCan application Makefile
# Author:      Daniel Collins
# Created:     21/09/2025
# Copyright:   (c) 2025 Daniel Collins
# Licence:     wxWidgets licence
#----------------------------------------------------------------------------

# This compiles a stand-alone sample application (wxLuaCan) which has its own
# custom wxLua bindings and demonstrates how to make use of the wxLua library
# Makefile from another project.

ifeq ($(OS),Windows_NT)
	WXLUACAN_APP := wxluacan.exe
else
	WXLUACAN_APP := wxluacan
endif

WXLUACAN_OBJS := \
	cancom.o \
	canlua.o \
	cansim.o \
	wxluacan_bind.o

.PHONY: all
all: $(WXLUACAN_APP)

# Define WXLUA_ROOT so the library Makefile file knows where the sources are.
WXLUA_ROOT := ../../
include ../../Makefile

clean: wxlua-clean
	rm -f $(WXLUACAN_BINDING_OUTPUTS)
	rm -f $(WXLUACAN_OBJS)
	rm -f $(WXLUACAN_APP)

# We take advantage of the library Makefile to provide us compiler flags for
# building against Lua and wxWidgets. If we were compiling wxLua as a part of a
# larger application we could instead handle that ourselves and ensure the flag
# variables are set prior to including the library Makefile for it to use ours
# instead.

$(WXLUACAN_APP): $(WXLUACAN_OBJS) $(WXLUA_LIB) $(WXBIND_LIB)
	$(CXX) $(CXXFLAGS) -o $@ $(WXLUACAN_OBJS) $(WXLUA_LIB) $(WXBIND_LIB) $(LUA_LIBS) $(WX_LIBS)

# We add $(WXLUA_BIND_HEADERS) as a prerequisite here to ensure all of wxLua's
# bindings are built before our sources. This is a bit of a crude sledgehammer
# solution to the issue of build ordering, but unless you're making frequent
# changes to wxLua within the scope of a large application its probably not
# worth the extra effort of tracking which of your sources depend on which of
# wxLua's bindings.

%.o: %.cpp $(WXLUA_BIND_HEADERS)
	$(CXX) $(CXXFLAGS) $(LUA_CFLAGS) $(WX_CXXFLAGS) -I$(WXLUA_ROOT)/include/ -c -o $@ $<

# Ensure canlua.cpp isn't compiled until our bindings are built.
canlua.o: wxluacan_bind.h

# genwxbind.lua produces multiple files from a single command, this would
# ideally be handled as a Grouped Target, but those weren't introduced until
# GNU Make 4.3, so for the time being we have the old faithful hack of each
# of the output files depending on a dummy intermediate target which actually
# produces all of the outputs.

WXLUACAN_BINDING_FLAG_FILE := wxluacan_bind.flag

WXLUACAN_BINDING_INPUTS := \
	wxluacan_rules.lua \
	wxluacan.i \
	$(WXLUA_ROOT)bindings/wxwidgets/wx_datatypes.lua

WXLUACAN_BINDING_OUTPUTS := \
	wxluacan_bind.cpp \
	wxluacan_bind.h \
	wxluacan_datatypes.lua

# If any of the binding outputs are missing, we mark the intermediate as a
# phony target to force it to be re-run and produce any missing outputs.
ifneq ($(strip $(foreach x,$(WXLUACAN_BINDING_OUTPUTS),$(if $(wildcard $(x)),,$(x)))),)
.PHONY: $(WXLUACAN_BINDING_FLAG_FILE)
endif

$(WXLUACAN_BINDING_FLAG_FILE): $(WXLUACAN_BINDING_INPUTS)
	$(LUA) -e"rulesFilename=\"wxluacan_rules.lua\"" ../../bindings/genwxbind.lua
	touch $@

$(WXLUACAN_BINDING_OUTPUTS): $(WXLUACAN_BINDING_FLAG_FILE)
