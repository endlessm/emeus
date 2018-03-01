#!/bin/sh

if [ -z "$DESTDIR" ]; then
  echo Updating desktop file database...
  update-desktop-database -q ${MESON_INSTALL_PREFIX}/share/applications
fi
