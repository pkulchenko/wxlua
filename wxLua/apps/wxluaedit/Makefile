# File:		Makefile
# Author:	John Labenski, J Winwood
# Created:	2004
# Updated:
# Copyright: (c) 2002. J Winwood
#
# Makefile for wxLuaEditor app using gmake

# ----------------------------------------------------------------------------
# Set path to root of wxLua
WXLUA_DIR = ../..

# ----------------------------------------------------------------------------
# Include wxLua settings using wx-config for wxWidgets parameters

include $(WXLUA_DIR)/build/Makefile_wx-config.in

# ----------------------------------------------------------------------------

PROGRAM = wxLuaEditor

HEADERS =
SOURCES = wxluaedit.cpp wxledit.cpp

OBJECTS=$(SOURCES:.cpp=.o)
DEPFILES=$(OBJECTS:.o=.d)

APPEXTRALIBS := -L$(WXSTEDIT_DIR)/lib -l$(WXSTEDIT_LIB) $(APPEXTRALIBS)

# ----------------------------------------------------------------------------

.cpp.o:
	$(CXX) -c $(CXXFLAGS) $(APPEXTRADEFS) -o $@ $<

all: $(wxLuaALL_TARGETS) $(PROGRAM)

$(PROGRAM): wxStEdit $(OBJECTS)
	$(CXX) -o $@ $(OBJECTS) $(LDLIBS) $(APPEXTRALIBS)

clean:
	rm -f $(OBJECTS) $(DEPFILES) $(PROGRAM) core

# ----------------------------------------------------------------------------
# Include wxLua targets using wx-config for wxWidgets parameters

include $(WXLUA_DIR)/build/Makefile_wx-config_targets.in

-include $(DEPFILES)
