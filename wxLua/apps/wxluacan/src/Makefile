# File:		Makefile
# Author:	John Labenski, J Winwood
# Created:	2004
# Updated:
# Copyright: (c) 2002. J Winwood
#
# Makefile for wxLuaCan app using gmake

# ----------------------------------------------------------------------------
# Set path to root of wxLua
WXLUA_DIR = ../../..

# ----------------------------------------------------------------------------
# Include wxLua settings using wx-config for wxWidgets parameters

include $(WXLUA_DIR)/build/Makefile_wx-config.in

# ----------------------------------------------------------------------------

PROGRAM = wxLuaCan

HEADERS =
SOURCES = cancom.cpp canlua.cpp cansim.cpp wxluacan_bind.cpp

OBJECTS=$(SOURCES:.cpp=.o)
DEPFILES=$(OBJECTS:.o=.d)

#APPEXTRALIBS :=

# ----------------------------------------------------------------------------

.cpp.o:
	$(CXX) -c $(CXXFLAGS) $(APPEXTRADEFS) -o $@ $<

all: $(wxLuaALL_TARGETS) $(PROGRAM)

$(PROGRAM): $(OBJECTS) $(LUA_LIBS)
	$(CXX) -o $@ $(OBJECTS) $(LDLIBS) $(APPEXTRALIBS)

genwxbind:
	$(LUA) -e"rulesFilename=\"wxluacan_rules.lua\"" $(WXLUA_DIR)/bindings/genwxbind.lua

clean:
	rm -f $(OBJECTS) $(DEPFILES) $(PROGRAM) core

# ----------------------------------------------------------------------------
# Include wxLua targets using wx-config for wxWidgets parameters

include $(WXLUA_DIR)/build/Makefile_wx-config_targets.in

-include $(DEPFILES)
