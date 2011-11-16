# File:		Makefile
# Author:	John Labenski, J Winwood
# Created:	2004
# Updated:
# Copyright: (c) 2002. J Winwood
#
# Makefile for wxLuaFreeze sample using gmake

PROGRAM = wxLuaFreeze

# ----------------------------------------------------------------------------
# Set path to root of wxLua
WXLUA_DIR = ../../..

# ----------------------------------------------------------------------------
# Include wxLua settings using wx-config for wxWidgets parameters

include $(WXLUA_DIR)/build/Makefile_wx-config.in

# ----------------------------------------------------------------------------

HEADERS =
SOURCES = wxluafreeze.cpp

OBJECTS=$(SOURCES:.cpp=.o)
DEPFILES=$(OBJECTS:.o=.d)

#APPEXTRALIBS := $(APPEXTRALIBS)

# ----------------------------------------------------------------------------

.cpp.o:
	$(CXX) -c $(CXXFLAGS) $(APPEXTRADEFS) -o $@ $<

all: $(wxLuaALL_TARGETS) $(PROGRAM)

$(PROGRAM): $(OBJECTS) $(LUA_LIBS) $(wxLuaALL_TARGETS)
	$(CXX) -o $@ $(OBJECTS) $(LDLIBS) $(APPEXTRALIBS)

clean:
	rm -f $(OBJECTS) $(DEPFILES) $(PROGRAM) core

# ----------------------------------------------------------------------------
# Include wxLua targets using wx-config for wxWidgets parameters

include $(WXLUA_DIR)/build/Makefile_wx-config_targets.in

-include $(DEPFILES)
