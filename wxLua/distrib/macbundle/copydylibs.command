#!/bin/sh -x

DIR=`dirname "$0"`; cd "$DIR"

# This little shell script can be used to copy 
# the DLL to this folder, so that EXEs compiled
# against shared builds of wxLua can find them.

PREFIX=/usr/local

#cp $PREFIX/lib/libwx_macu-2.8.0.dylib .
#cp $PREFIX/lib/libwx_macu_stc-2.8.0.dylib .

cp -p ../lib/*.dylib .

for dylib in lib*lua*.0.0.0.dylib; do
  lib=`echo $dylib | sed -e s/.0.0.0.dylib/.0.dylib/`
  test -L $lib && rm $lib # remove existing symlink
  mv $dylib $lib
done

for dylib in libwx_*.0.dylib liblua*.0.dylib libwxlua_*.0.dylib; do
  install_name_tool -id @executable_path/../../../$dylib $dylib

  for lib in libwx_*.0.dylib liblua*.0.dylib libwxlua_*.0.dylib; do
  install_name_tool -change $PREFIX/lib/$dylib @executable_path/../../../$dylib\
                    $lib
  done

  for app in wxLua wxLuaEdit wxLuaCan wxLuaFreeze; do
  install_name_tool -change $PREFIX/lib/$dylib @executable_path/../../../$dylib\
                    $app.app/Contents/MacOS/*
  done

done

