# File:		Makefile
# Author:	John Labenski, J Winwood
# Created:	2004
# Updated:
# Copyright: (c) 2002. J Winwood
#
# Makefile for wxLua standalone sample using gmake

# ----------------------------------------------------------------------------
# Set path to root of wxLua
WXLUA_DIR = ../../..

# ----------------------------------------------------------------------------
# Include wxLua settings using wx-config for wxWidgets parameters

include $(WXLUA_DIR)/build/Makefile_wx-config.in

# ----------------------------------------------------------------------------

#OBJECTS=luamodule.o
#DEPFILES=$(OBJECTS:.o=.d)

.cpp.o:
	$(CXX) -c $(CXXFLAGS) $(APPEXTRADEFS) -o $@ $<

all: $(wxLuaALL_TARGETS) wx.so

wx.so: luamodule.cpp $(OBJECTS) $(LUA_LIBS) $(wxLuaALL_TARGETS)
	$(CXX) $(CXXFLAGS) $(APPEXTRADEFS) -g -O -shared -o wx.so -fPIC \
	$(LDLIBS) $(APPEXTRALIBS) \
	luamodule.cpp

clean:
	rm -f $(OBJECTS) $(DEPFILES) $(PROGRAM) core

# ----------------------------------------------------------------------------
# Include wxLua targets using wx-config for wxWidgets parameters

include $(WXLUA_DIR)/build/Makefile_wx-config_targets.in

-include $(DEPFILES)
