# File:		Makefile
# Author:	John Labenski, J Winwood
# Created:	2004
# Updated:
# Copyright: (c) 2002. J Winwood
#
# Makefile for wxLua standalone sample using gmake

# ----------------------------------------------------------------------------
# Set path to root of wxLua
WXLUA_DIR = ../..

# ----------------------------------------------------------------------------
# Include wxLua settings using wx-config for wxWidgets parameters

include $(WXLUA_DIR)/build/Makefile_wx-config.in

# ----------------------------------------------------------------------------

PROGRAM = wxLua

HEADERS =
SOURCES = wxlua.cpp lconsole.cpp

OBJECTS=$(SOURCES:.cpp=.o)
DEPFILES=$(OBJECTS:.o=.d)

#APPEXTRALIBS := -l$(WXSTC_LIB) $(APPEXTRALIBS)

# ----------------------------------------------------------------------------

.cpp.o:
	$(CXX) -c $(CXXFLAGS) $(APPEXTRADEFS) -o $@ $<

all: $(wxLuaALL_TARGETS) $(PROGRAM)

$(PROGRAM): $(OBJECTS) $(LUA_LIBS)
	$(CXX) -o $@ $(OBJECTS) $(LDLIBS) $(APPEXTRALIBS)

editor:
	$(LUA) $(WXLUA_DIR)/util/bin2c/bin2c.lua -t -lf -n editor_wx_lua -o editor.h $(WXLUA_DIR)/samples/editor.wx.lua

clean:
	rm -f $(OBJECTS) $(DEPFILES) $(PROGRAM) core

# ----------------------------------------------------------------------------
# Include wxLua targets using wx-config for wxWidgets parameters

include $(WXLUA_DIR)/build/Makefile_wx-config_targets.in

-include $(DEPFILES)
