#----------------------------------------------------------------------------
# Purpose:     wxLua library Makefile
# Author:      Daniel Collins
# Created:     19/09/2025
# Copyright:   (c) 2025 Daniel Collins
# Licence:     wxWidgets licence
#----------------------------------------------------------------------------

# Define this variable when this Makefile is included as part of another to
# prefix all the paths for building parts of wxLua within another project.
#
# NOTE: The trailing slash is REQUIRED! Also, the path should not contain any
# spaces (keep it relative to your project) or things will break.
#
# WXLUA_ROOT := foo/

# Wrapper around the $(shell) function that aborts the build if the command
# exits with a nonzero status.
shell-or-die = $\
	$(eval sod_out := $$(shell $(1); echo $$$$?))$\
	$(if $(filter 0,$(lastword $(sod_out))),$\
		$(wordlist 1, $(shell echo $$(($(words $(sod_out)) - 1))), $(sod_out)),$\
		$(error $(1) exited with status $(lastword $(sod_out))))

# Takes a list of space-separated package names and returns the first which is
# defined in the pkg-config database, or errors if none are.
pkg-select = $\
	$(eval found_pkg := $$(firstword $$(foreach pkg,$(1), $$(shell pkg-config --exists $$(pkg) && echo $$(pkg))))) $\
	$(if $(found_pkg),$(found_pkg),$(error Could not found any of the following packages using pkg-config: $(1)))

WXLUA_ROOT_ABS := $(if $(WXLUA_ROOT),$(call shell-or-die,cd "$(WXLUA_ROOT)" && pwd),$(call shell-or-die,pwd))

WXLUA_ALL_BINDINGS := \
	wxadv \
	wxaui \
	wxgl \
	wxhtml \
	wxmedia \
	wxnet \
	wxpropgrid \
	wxrichtext \
	wxstc \
	wxwebview \
	wxxml \
	wxxrc

WXLUA_ENABLE_BINDINGS ?= $(WXLUA_ALL_BINDINGS)

ifneq ($(filter-out $(WXLUA_ALL_BINDINGS),$(WXLUA_ENABLE_BINDINGS)),)
_ := $(error Unknown binding(s) specified in WXLUA_ENABLE_BINDINGS: $(filter-out $(WXLUA_ALL_BINDINGS),$(WXLUA_ENABLE_BINDINGS)))
endif

WX_CONFIG ?= wx-config
WX_USE_LIBS ?= propgrid webview gl xrc xml net media richtext aui stc html adv core base

WX_CXXFLAGS ?= $(call shell-or-die,$(WX_CONFIG) --cxxflags $(WX_USE_LIBS))
WX_LIBS     ?= $(call shell-or-die,$(WX_CONFIG) --libs $(WX_USE_LIBS))

BUILD_LUA ?= 5.1

ifeq ($(filter-out 0,$(BUILD_LUA)),)
	# BUILD_LUA is 0 or empty - use the system Lua.
	LUA_PKG    ?= $(call pkg-select,lua5.4 lua5.3 lua5.2 lua5.1 lua)
	LUA_CFLAGS ?= $(call shell-or-die,pkg-config $(LUA_PKG) --cflags)
	LUA_LIBS   ?= $(call shell-or-die,pkg-config $(LUA_PKG) --libs)
	
	LUA ?= lua
else
	# BUILD_LUA is the version of Lua to build.
	LUA_PREREQ := $(WXLUA_ROOT)modules/lua-$(BUILD_LUA)/install/lib/liblua.a
	LUA_CFLAGS := -I$(WXLUA_ROOT)modules/lua-$(BUILD_LUA)/install/include/
	LUA_LIBS   := $(WXLUA_ROOT)modules/lua-$(BUILD_LUA)/install/lib/liblua.a -ldl
	
	ifeq ($(BUILD_LUA),5.2)
		LUA_CFLAGS += -DLUA_COMPAT_MODULE
	endif
	
	LUA := $(WXLUA_ROOT_ABS)/modules/lua-$(BUILD_LUA)/install/bin/lua
endif

WXLUA_DIR := $(WXLUA_ROOT)modules/wxlua

WXLUA_LIB := $(WXLUA_ROOT)lib/wxlua.a
WXLUA_OBJS := \
	$(WXLUA_DIR)/bit.o \
	$(WXLUA_DIR)/lbitlib.o \
	$(WXLUA_DIR)/wxlbind.o \
	$(WXLUA_DIR)/wxlcallb.o \
	$(WXLUA_DIR)/wxlconsole.o \
	$(WXLUA_DIR)/wxllua.o \
	$(WXLUA_DIR)/wxlobject.o \
	$(WXLUA_DIR)/wxlstate.o \
	$(WXLUA_DIR)/wxlua_bind.o

WXLUA_DEBUG_LIB := $(WXLUA_ROOT)lib/wxlua-debug.a
WXLUA_DEBUG_OBJS := \
	$(WXLUA_DIR)/debug/wxldebug.o \
	$(WXLUA_DIR)/debug/wxlstack.o

WXLUA_DEBUGGER_LIB := $(WXLUA_ROOT)lib/wxlua-debugger.a
WXLUA_DEBUGGER_OBJS := \
	$(WXLUA_DIR)/debugger/wxldserv.o \
	$(WXLUA_DIR)/debugger/wxldtarg.o \
	$(WXLUA_DIR)/debugger/wxlsock.o \
	$(WXLUA_DIR)/debugger/wxluadebugger_bind.o

WXBIND_DIR := $(WXLUA_ROOT)modules/wxbind

WXBIND_LIB := $(WXLUA_ROOT)lib/wxbind.a

WXBIND_BASE_OBJS := \
	$(WXBIND_DIR)/src/wxbase_base.o \
	$(WXBIND_DIR)/src/wxbase_bind.o \
	$(WXBIND_DIR)/src/wxbase_config.o \
	$(WXBIND_DIR)/src/wxbase_data.o \
	$(WXBIND_DIR)/src/wxbase_datetime.o \
	$(WXBIND_DIR)/src/wxbase_file.o

WXBIND_CORE_OBJS := \
	$(WXBIND_DIR)/src/wxcore_appframe.o \
	$(WXBIND_DIR)/src/wxcore_bind.o \
	$(WXBIND_DIR)/src/wxcore_clipdrag.o \
	$(WXBIND_DIR)/src/wxcore_controls.o \
	$(WXBIND_DIR)/src/wxcore_core.o \
	$(WXBIND_DIR)/src/wxcore_defsutils.o \
	$(WXBIND_DIR)/src/wxcore_dialogs.o \
	$(WXBIND_DIR)/src/wxcore_event.o \
	$(WXBIND_DIR)/src/wxcore_gdi.o \
	$(WXBIND_DIR)/src/wxcore_geometry.o \
	$(WXBIND_DIR)/src/wxcore_graphics.o \
	$(WXBIND_DIR)/src/wxcore_help.o \
	$(WXBIND_DIR)/src/wxcore_image.o \
	$(WXBIND_DIR)/src/wxcore_mdi.o \
	$(WXBIND_DIR)/src/wxcore_menutool.o \
	$(WXBIND_DIR)/src/wxcore_picker.o \
	$(WXBIND_DIR)/src/wxcore_print.o \
	$(WXBIND_DIR)/src/wxcore_sizer.o \
	$(WXBIND_DIR)/src/wxcore_windows.o \
	$(WXBIND_DIR)/src/wxcore_wxlcore.o

WXBIND_OBJS := \
	$(WXBIND_BASE_OBJS) \
	$(WXBIND_CORE_OBJS) \
	$(foreach x,$(WXLUA_ENABLE_BINDINGS),$(WXBIND_DIR)/src/$(x)_bind.o) \
	$(if $(filter wxadv,$(WXLUA_ENABLE_BINDINGS)),$(WXBIND_DIR)/src/wxadv_wxladv.o) \
	$(if $(filter wxhtml,$(WXLUA_ENABLE_BINDINGS)),$(WXBIND_DIR)/src/wxhtml_wxlhtml.o)

WXBIND_ALL_OBJS := \
	$(WXBIND_BASE_OBJS) \
	$(WXBIND_CORE_OBJS) \
	$(foreach x,$(WXLUA_ALL_BINDINGS),$(WXBIND_DIR)/src/$(x)_bind.o) \
	$(WXBIND_DIR)/src/wxadv_wxladv.o \
	$(WXBIND_DIR)/src/wxadv_wxlhtml.o

ifeq ($(OS),Windows_NT)
	LUAMODULE := $(WXLUA_ROOT)lib/lua/wx.dll
	WX_LIBS += -lws2_32
else
	LUAMODULE := $(WXLUA_ROOT)lib/lua/wx.so
endif

LUAMODULE_OBJS := \
	$(WXLUA_ROOT)modules/luamodule/luamodule.o

.PHONY: wxlua-all
wxlua-all: $(WXLUA_LIB) $(WXLUA_DEBUG_LIB) $(WXLUA_DEBUGGER_LIB) $(WXBIND_LIB) $(LUAMODULE)

ifeq ($(WXLUA_ROOT),)
.PHONY: clean
clean: wxlua-clean
endif

.PHONY: wxlua-clean
wxlua-clean:
	rm -f $(WXLUA_LIB) $(WXLUA_OBJS)
	rm -f $(WXLUA_DEBUG_LIB) $(WXLUA_DEBUG_OBJS)
	rm -f $(WXLUA_DEBUGGER_LIB) $(WXLUA_DEBUGGER_OBJS)
	rm -f $(WXBIND_LIB) $(WXBIND_ALL_OBJS)
	rm -f $(LUAMODULE) $(LUAMODULE_OBJS)
	
	rm -f $(WXBASE_BINDING_TARGETS) $(WXBASE_BINDING_FLAG_FILE)
	rm -f $(WXCORE_BINDING_TARGETS) $(WXCORE_BINDING_FLAG_FILE)
	rm -f $(foreach x,$(WXLUA_ALL_BINDINGS),$(WXLUA_ROOT)bindings/wxwidgets/$(x)_datatypes.lua)
	rm -f $(foreach x,$(WXLUA_ALL_BINDINGS),$(WXLUA_ROOT)include/wxbind/$(x)_bind.h)
	rm -f $(foreach x,$(WXLUA_ALL_BINDINGS),$(WXLUA_ROOT)modules/wxbind/src/$(x)_bind.cpp)
	rm -f $(WXLUA_ROOT)bindings/wxwidgets/wx_datatypes.lua
	
	rm -f $(WXLUA_ROOT)include/wxlua/wxlua_bind.h $(WXLUA_ROOT)bindings/wxlua/wxlua_datatypes.lua $(WXLUA_ROOT)modules/wxlua/wxlua_bind.cpp
	rm -f $(WXLUA_ROOT)modules/wxlua/debugger/wxluadebugger_bind.h $(WXLUA_ROOT)bindings/wxlua_debugger/wxluadebugger_datatypes.lua $(WXLUA_ROOT)modules/wxlua/debugger/wxluadebugger_bind.cpp
	
	if [ -d $(WXLUA_ROOT)modules/lua-5.1/ ]; then $(MAKE) -C $(WXLUA_ROOT)modules/lua-5.1/ clean; fi
	rm -rf $(WXLUA_ROOT)modules/lua-5.1/install/
	
	if [ -d $(WXLUA_ROOT)modules/lua-5.2/ ]; then $(MAKE) -C $(WXLUA_ROOT)modules/lua-5.2/ clean; fi
	rm -rf $(WXLUA_ROOT)modules/lua-5.2/install/

$(WXLUA_LIB): $(WXLUA_OBJS)
	@mkdir -p $(dir $@)
	ar rcs $@ $(WXLUA_OBJS)

$(WXLUA_DEBUG_LIB): $(WXLUA_DEBUG_OBJS)
	@mkdir -p $(dir $@)
	ar rcs $@ $(WXLUA_DEBUG_OBJS)

$(WXLUA_DEBUGGER_LIB): $(WXLUA_DEBUGGER_OBJS)
	@mkdir -p $(dir $@)
	ar rcs $@ $(WXLUA_DEBUGGER_OBJS)

$(WXBIND_LIB): $(WXBIND_OBJS)
	@mkdir -p $(dir $@)
	ar rcs $@ $(WXBIND_OBJS)

$(LUAMODULE): $(LUAMODULE_OBJS) $(WXLUA_LIB) $(WXLUA_DEBUGGER_LIB) $(WXLUA_DEBUG_LIB) $(WXBIND_LIB)
	@mkdir -p $(dir $@)
	$(CXX) -o $@ -shared -fPIC $(CXXFLAGS) $(LUAMODULE_OBJS) $(WXLUA_LIB) $(WXLUA_DEBUGGER_LIB) $(WXLUA_DEBUG_LIB) $(WXBIND_LIB) $(LUA_LIBS) $(WX_LIBS)

$(WXLUA_ROOT)modules/lua-5.1/install/lib/liblua.a:
	# Lua's Makefile work with >1 concurrency.
	$(MAKE) -j1 -C $(WXLUA_ROOT)modules/lua-5.1/ linux install INSTALL_TOP="$(WXLUA_ROOT_ABS)/modules/lua-5.1/install/"

$(WXLUA_ROOT)modules/lua-5.2/install/lib/liblua.a:
	# Lua's Makefile work with >1 concurrency.
	$(MAKE) -j1 -C $(WXLUA_ROOT)modules/lua-5.2/ CFLAGS="-DLUA_COMPAT_MODULE -DLUA_USE_LINUX -fPIC" linux local
	touch $@

# wxWidgets library bindings

# The wxbase bindings produce multiple source files from a single command, this
# would ideally be handled as a Grouped Target, but those weren't introduced
# until GNU Make 4.3, which I'm not happy depending on yet so we go for the old
# faithful all-the-outputs-depend-on-a-dummy-target-which-actually-makes-them
# approach. If any of the targets are missing, then we flag that dummy as a
# phony target to ensure it gets run to build the missing file(s).

WXBASE_BINDING_TARGETS := \
	$(WXLUA_ROOT)bindings/wxwidgets/wxbase_datatypes.lua \
	$(WXLUA_ROOT)include/wxbind/wxbase_bind.h \
	$(WXLUA_ROOT)modules/wxbind/src/wxbase_base.cpp \
	$(WXLUA_ROOT)modules/wxbind/src/wxbase_bind.cpp \
	$(WXLUA_ROOT)modules/wxbind/src/wxbase_config.cpp \
	$(WXLUA_ROOT)modules/wxbind/src/wxbase_data.cpp \
	$(WXLUA_ROOT)modules/wxbind/src/wxbase_datetime.cpp \
	$(WXLUA_ROOT)modules/wxbind/src/wxbase_file.cpp

WXBASE_BINDING_DEPENDENCIES := \
	$(WXLUA_ROOT)bindings/wxwidgets/wxbase_rules.lua \
	$(WXLUA_ROOT)bindings/wxwidgets/wxbase_base.i \
	$(WXLUA_ROOT)bindings/wxwidgets/wxbase_config.i \
	$(WXLUA_ROOT)bindings/wxwidgets/wxbase_data.i \
	$(WXLUA_ROOT)bindings/wxwidgets/wxbase_datetime.i \
	$(WXLUA_ROOT)bindings/wxwidgets/wxbase_file.i \
	$(WXLUA_ROOT)bindings/wxwidgets/wxbase_override.hpp

WXBASE_BINDING_FLAG_FILE := \
	$(WXLUA_ROOT)bindings/wxwidgets/wxbase_bind.flag

ifneq ($(strip $(strip $(foreach x,$(WXBASE_BINDING_TARGETS),$(if $(wildcard $(x)),,$(x))))),)
.PHONY: $(WXBASE_BINDING_FLAG_FILE)
endif

$(WXBASE_BINDING_TARGETS): $(WXBASE_BINDING_FLAG_FILE)

$(WXBASE_BINDING_FLAG_FILE): $(WXBASE_BINDING_DEPENDENCIES) $(LUA_PREREQ)
	cd $(WXLUA_ROOT)bindings/ && $(LUA) -e"rulesFilename=\"wxwidgets/wxbase_rules.lua\"" genwxbind.lua
	touch $@

# The wxcore bindings produce multiple source files from a single command, this
# would ideally be handled as a Grouped Target, but those weren't introduced
# until GNU Make 4.3, which I'm not happy depending on yet so we go for the old
# faithful all-the-outputs-depend-on-a-dummy-target-which-actually-makes-them
# approach. If any of the targets are missing, then we flag that dummy as a
# phony target to ensure it gets run to build the missing file(s).

WXCORE_BINDING_TARGETS := \
	$(WXLUA_ROOT)bindings/wxwidgets/wxcore_datatypes.lua \
	$(WXLUA_ROOT)include/wxbind/wxcore_bind.h \
	$(WXLUA_ROOT)modules/wxbind/src/wxcore_appframe.cpp \
	$(WXLUA_ROOT)modules/wxbind/src/wxcore_bind.cpp \
	$(WXLUA_ROOT)modules/wxbind/src/wxcore_clipdrag.cpp \
	$(WXLUA_ROOT)modules/wxbind/src/wxcore_controls.cpp \
	$(WXLUA_ROOT)modules/wxbind/src/wxcore_core.cpp \
	$(WXLUA_ROOT)modules/wxbind/src/wxcore_defsutils.cpp \
	$(WXLUA_ROOT)modules/wxbind/src/wxcore_dialogs.cpp \
	$(WXLUA_ROOT)modules/wxbind/src/wxcore_event.cpp \
	$(WXLUA_ROOT)modules/wxbind/src/wxcore_gdi.cpp \
	$(WXLUA_ROOT)modules/wxbind/src/wxcore_geometry.cpp \
	$(WXLUA_ROOT)modules/wxbind/src/wxcore_graphics.cpp \
	$(WXLUA_ROOT)modules/wxbind/src/wxcore_help.cpp \
	$(WXLUA_ROOT)modules/wxbind/src/wxcore_image.cpp \
	$(WXLUA_ROOT)modules/wxbind/src/wxcore_mdi.cpp \
	$(WXLUA_ROOT)modules/wxbind/src/wxcore_menutool.cpp \
	$(WXLUA_ROOT)modules/wxbind/src/wxcore_picker.cpp \
	$(WXLUA_ROOT)modules/wxbind/src/wxcore_print.cpp \
	$(WXLUA_ROOT)modules/wxbind/src/wxcore_sizer.cpp \
	$(WXLUA_ROOT)modules/wxbind/src/wxcore_windows.cpp

WXCORE_BINDING_DEPDENDENCIES := \
	$(WXLUA_ROOT)bindings/wxwidgets/wxbase_datatypes.lua \
	$(WXLUA_ROOT)bindings/wxwidgets/wxcore_rules.lua \
	$(WXLUA_ROOT)bindings/wxwidgets/wxcore_appframe.i \
	$(WXLUA_ROOT)bindings/wxwidgets/wxcore_clipdrag.i \
	$(WXLUA_ROOT)bindings/wxwidgets/wxcore_controls.i \
	$(WXLUA_ROOT)bindings/wxwidgets/wxcore_core.i \
	$(WXLUA_ROOT)bindings/wxwidgets/wxcore_defsutils.i \
	$(WXLUA_ROOT)bindings/wxwidgets/wxcore_dialogs.i \
	$(WXLUA_ROOT)bindings/wxwidgets/wxcore_event.i \
	$(WXLUA_ROOT)bindings/wxwidgets/wxcore_gdi.i \
	$(WXLUA_ROOT)bindings/wxwidgets/wxcore_geometry.i \
	$(WXLUA_ROOT)bindings/wxwidgets/wxcore_graphics.i \
	$(WXLUA_ROOT)bindings/wxwidgets/wxcore_help.i \
	$(WXLUA_ROOT)bindings/wxwidgets/wxcore_image.i \
	$(WXLUA_ROOT)bindings/wxwidgets/wxcore_mdi.i \
	$(WXLUA_ROOT)bindings/wxwidgets/wxcore_menutool.i \
	$(WXLUA_ROOT)bindings/wxwidgets/wxcore_override.hpp \
	$(WXLUA_ROOT)bindings/wxwidgets/wxcore_picker.i \
	$(WXLUA_ROOT)bindings/wxwidgets/wxcore_print.i \
	$(WXLUA_ROOT)bindings/wxwidgets/wxcore_sizer.i \
	$(WXLUA_ROOT)bindings/wxwidgets/wxcore_windows.i

WXCORE_BINDING_FLAG_FILE := \
	$(WXLUA_ROOT)bindings/wxwidgets/wxcore_bind.flag

ifneq ($(strip $(strip $(foreach x,$(WXCORE_BINDING_TARGETS),$(if $(wildcard $(x)),,$(x))))),)
.PHONY: $(WXCORE_BINDING_FLAG_FILE)
endif

$(WXCORE_BINDING_TARGETS): $(WXCORE_BINDING_FLAG_FILE)

$(WXCORE_BINDING_FLAG_FILE): $(WXCORE_BINDING_DEPDENDENCIES) $(LUA_PREREQ)
	cd $(WXLUA_ROOT)bindings/ && $(LUA) -e"rulesFilename=\"wxwidgets/wxcore_rules.lua\"" genwxbind.lua
	touch $@

# The "basic" wxWidgets bindings all follow the same pattern and have a
# consistent set of outputs which can be encompassed by a pattern rule.

WXLUA_ENABLE_BINDINGS ?= \
	wxadv \
	wxaui \
	wxgl \
	wxhtml \
	wxmedia \
	wxnet \
	wxpropgrid \
	wxrichtext \
	wxstc \
	wxwebview \
	wxxml \
	wxxrc

$(WXLUA_ROOT)include/wxbind/%_bind.h $(WXLUA_ROOT)bindings/wxwidgets/%_datatypes.lua $(WXLUA_ROOT)modules/wxbind/src/%_bind.cpp: $(WXLUA_ROOT)bindings/wxwidgets/%_rules.lua $(LUA_PREREQ)
	cd $(WXLUA_ROOT)bindings/ && $(LUA) -e"rulesFilename=\"wxwidgets/$*_rules.lua\"" genwxbind.lua

# Merged data types from wxWidgets library bindings for use by other bindings
$(WXLUA_ROOT)bindings/wxwidgets/wx_datatypes.lua: $(WXLUA_ROOT)bindings/wxwidgets/wxbase_datatypes.lua $(foreach x,$(WXLUA_ENABLE_BINDINGS),$(WXLUA_ROOT)bindings/wxwidgets/$(x)_datatypes.lua) $(LUA_PREREQ)
	cd $(WXLUA_ROOT)bindings/ && $(LUA) -e"rulesFilename=\"wxwidgets/wxdatatypes_rules.lua\"" genwxbind.lua
	touch $@

# Individual library/application bindings.
# These are pattern rules despite being for single targets so that we can
# indicate they produce multiple outputs.

$(WXLUA_ROOT)include/wxlua/%_bind.h $(WXLUA_ROOT)bindings/wxlua/%_datatypes.lua $(WXLUA_ROOT)modules/wxlua/%_bind.cpp: $(WXLUA_ROOT)bindings/wxlua/wxlua_rules.lua $(LUA_PREREQ)
	cd $(WXLUA_ROOT)bindings/ && $(LUA) -e"rulesFilename=\"wxlua/$*_rules.lua\"" genwxbind.lua

$(WXLUA_ROOT)modules/wxlua/debugger/%_bind.h $(WXLUA_ROOT)bindings/wxlua_debugger/%_datatypes.lua $(WXLUA_ROOT)modules/wxlua/debugger/%_bind.cpp: $(WXLUA_ROOT)bindings/wxlua_debugger/%_rules.lua $(LUA_PREREQ)
	cd $(WXLUA_ROOT)bindings/ && $(LUA) -e"rulesFilename=\"wxlua_debugger/$*_rules.lua\"" genwxbind.lua

# Bindings which must be built before anything in wxLua is compiled
WXLUA_BIND_HEADERS = \
	$(WXBASE_BINDING_TARGETS) \
	$(WXCORE_BINDING_TARGETS) \
	$(foreach x,$(WXLUA_ENABLE_BINDINGS),$(WXLUA_ROOT)include/wxbind/$(x)_bind.h) \
	$(WXLUA_ROOT)include/wxlua/wxlua_bind.h

$(WXLUA_ROOT)%.o: $(WXLUA_ROOT)%.c $(LUA_PREREQ) $(WXLUA_BIND_HEADERS)
	$(CC) -I$(WXLUA_ROOT)include/ $(LUA_CFLAGS) $(CFLAGS) -fPIC -c -o $@ $<

$(WXLUA_ROOT)%.o: $(WXLUA_ROOT)%.cpp $(LUA_PREREQ) $(WXLUA_BIND_HEADERS)
	$(CXX) -I$(WXLUA_ROOT)include/ $(LUA_CFLAGS) $(WX_CXXFLAGS) $(CXXFLAGS) -fPIC -c -o $@ $<

# Additional dependencies of the various bindings.
# TODO: Update genwxbind.lua to output Makefile fragments with all the
# dependencies and include those so we only need an explicit dependency on the
# rules file instead.

$(WXLUA_ROOT)include/wxbind/wxadv_bind.h \
$(WXLUA_ROOT)bindings/wxwidgets/wxadv_datatypes.lua \
$(WXLUA_ROOT)modules/wxbind/src/wxadv_bind.cpp: \
	$(WXLUA_ROOT)bindings/wxwidgets/wxadv_adv.i \
	$(WXLUA_ROOT)bindings/wxwidgets/wxadv_dataview.i \
	$(WXLUA_ROOT)bindings/wxwidgets/wxadv_dvrenderers.i \
	$(WXLUA_ROOT)bindings/wxwidgets/wxadv_grid.i \
	$(WXLUA_ROOT)bindings/wxwidgets/wxadv_override.hpp \
	$(WXLUA_ROOT)bindings/wxwidgets/wxcore_datatypes.lua

$(WXLUA_ROOT)include/wxbind/wxaui_bind.h \
$(WXLUA_ROOT)bindings/wxwidgets/wxaui_datatypes.lua \
$(WXLUA_ROOT)modules/wxbind/src/wxaui_bind.cpp: \
	$(WXLUA_ROOT)bindings/wxwidgets/wxaui_aui.i \
	$(WXLUA_ROOT)bindings/wxwidgets/wxaui_override.hpp \
	$(WXLUA_ROOT)bindings/wxwidgets/wxcore_datatypes.lua

$(WXLUA_ROOT)include/wxbind/wxgl_bind.h \
$(WXLUA_ROOT)bindings/wxwidgets/wxgl_datatypes.lua \
$(WXLUA_ROOT)modules/wxbind/src/wxgl_bind.cpp: \
	$(WXLUA_ROOT)bindings/wxwidgets/wxcore_datatypes.lua \
	$(WXLUA_ROOT)bindings/wxwidgets/wxgl_gl.i

$(WXLUA_ROOT)include/wxbind/wxhtml_bind.h \
$(WXLUA_ROOT)bindings/wxwidgets/wxhtml_datatypes.lua \
$(WXLUA_ROOT)modules/wxbind/src/wxhtml_bind.cpp: \
	$(WXLUA_ROOT)bindings/wxwidgets/wxcore_datatypes.lua \
	$(WXLUA_ROOT)bindings/wxwidgets/wxhtml_html.i \
	$(WXLUA_ROOT)bindings/wxwidgets/wxhtml_override.hpp

$(WXLUA_ROOT)include/wxbind/wxmedia_bind.h \
$(WXLUA_ROOT)bindings/wxwidgets/wxmedia_datatypes.lua \
$(WXLUA_ROOT)modules/wxbind/src/wxmedia_bind.cpp: \
	$(WXLUA_ROOT)bindings/wxwidgets/wxcore_datatypes.lua \
	$(WXLUA_ROOT)bindings/wxwidgets/wxnet_datatypes.lua \
	$(WXLUA_ROOT)bindings/wxwidgets/wxmedia_media.i

$(WXLUA_ROOT)include/wxbind/wxnet_bind.h \
$(WXLUA_ROOT)bindings/wxwidgets/wxnet_datatypes.lua \
$(WXLUA_ROOT)modules/wxbind/src/wxnet_bind.cpp: \
	$(WXLUA_ROOT)bindings/wxwidgets/wxcore_datatypes.lua \
	$(WXLUA_ROOT)bindings/wxwidgets/wxnet_net.i \
	$(WXLUA_ROOT)bindings/wxwidgets/wxnet_override.hpp

$(WXLUA_ROOT)include/wxbind/wxpropgrid_bind.h \
$(WXLUA_ROOT)bindings/wxwidgets/wxpropgrid_datatypes.lua \
$(WXLUA_ROOT)modules/wxbind/src/wxpropgrid_bind.cpp: \
	$(WXLUA_ROOT)bindings/wxwidgets/wxcore_datatypes.lua \
	$(WXLUA_ROOT)bindings/wxwidgets/wxpropgrid_override.hpp \
	$(WXLUA_ROOT)bindings/wxwidgets/wxpropgrid_propgrid.i

$(WXLUA_ROOT)include/wxbind/wxrichtext_bind.h \
$(WXLUA_ROOT)bindings/wxwidgets/wxrichtext_datatypes.lua \
$(WXLUA_ROOT)modules/wxbind/src/wxrichtext_bind.cpp: \
	$(WXLUA_ROOT)bindings/wxwidgets/wxcore_datatypes.lua \
	$(WXLUA_ROOT)bindings/wxwidgets/wxrichtext_override.hpp \
	$(WXLUA_ROOT)bindings/wxwidgets/wxrichtext_print.i \
	$(WXLUA_ROOT)bindings/wxwidgets/wxrichtext_richtext.i \
	$(WXLUA_ROOT)bindings/wxwidgets/wxrichtext_style.i \
	$(WXLUA_ROOT)bindings/wxwidgets/wxrichtext_symboldlg.i \
	$(WXLUA_ROOT)bindings/wxwidgets/wxrichtext_xml.i \
	$(WXLUA_ROOT)bindings/wxwidgets/wxxml_datatypes.lua

$(WXLUA_ROOT)include/wxbind/wxstc_bind.h \
$(WXLUA_ROOT)bindings/wxwidgets/wxstc_datatypes.lua \
$(WXLUA_ROOT)modules/wxbind/src/wxstc_bind.cpp: \
	$(WXLUA_ROOT)bindings/wxwidgets/wxcore_datatypes.lua \
	$(WXLUA_ROOT)bindings/wxwidgets/wxstc_override.hpp \
	$(WXLUA_ROOT)bindings/wxwidgets/wxstc_stc.i

$(WXLUA_ROOT)include/wxbind/wxwebview_bind.h \
$(WXLUA_ROOT)bindings/wxwidgets/wxwebview_datatypes.lua \
$(WXLUA_ROOT)modules/wxbind/src/wxwebview_bind.cpp: \
	$(WXLUA_ROOT)bindings/wxwidgets/wxcore_datatypes.lua \
	$(WXLUA_ROOT)bindings/wxwidgets/wxwebview_webview.i

$(WXLUA_ROOT)include/wxbind/wxxml_bind.h \
$(WXLUA_ROOT)bindings/wxwidgets/wxxml_datatypes.lua \
$(WXLUA_ROOT)modules/wxbind/src/wxxml_bind.cpp: \
	$(WXLUA_ROOT)bindings/wxwidgets/wxbase_datatypes.lua \
	$(WXLUA_ROOT)bindings/wxwidgets/wxxml_override.hpp \
	$(WXLUA_ROOT)bindings/wxwidgets/wxxml_xml.i

$(WXLUA_ROOT)include/wxbind/wxxrc_bind.h \
$(WXLUA_ROOT)bindings/wxwidgets/wxxrc_datatypes.lua \
$(WXLUA_ROOT)modules/wxbind/src/wxxrc_bind.cpp: \
	$(WXLUA_ROOT)bindings/wxwidgets/wxcore_datatypes.lua \
	$(WXLUA_ROOT)bindings/wxwidgets/wxxrc_xrc.i

$(WXLUA_ROOT)include/wxlua/wxlua_bind.h \
$(WXLUA_ROOT)bindings/wxlua/wxlua_datatypes.lua \
$(WXLUA_ROOT)modules/wxlua/wxlua_bind.cpp: \
	$(WXLUA_ROOT)bindings/wxwidgets/wxbase_datatypes.lua \
	$(WXLUA_ROOT)bindings/wxlua/override.hpp \
	$(WXLUA_ROOT)bindings/wxlua/wxlua.i

$(WXLUA_ROOT)modules/wxlua/debugger/wxluadebugger_bind.h \
$(WXLUA_ROOT)bindings/wxlua_debugger/wxluadebugger_datatypes.lua \
$(WXLUA_ROOT)modules/wxlua/debugger/wxluadebugger_bind.cpp: \
	$(WXLUA_ROOT)bindings/wxwidgets/wxcore_datatypes.lua \
	$(WXLUA_ROOT)bindings/wxlua_debugger/override.hpp \
	$(WXLUA_ROOT)bindings/wxlua_debugger/wxluadebugger.i
