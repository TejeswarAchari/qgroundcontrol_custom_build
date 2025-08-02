message("Adding Custom Plugin")

#-- Version control
#   Major and minor versions are defined here (manually)

CUSTOM_QGC_VER_MAJOR = 0
CUSTOM_QGC_VER_MINOR = 0
CUSTOM_QGC_VER_FIRST_BUILD = 0

# Build number is automatic
# Uses the current branch. This way it works on any branch including build-server's PR branches
CUSTOM_QGC_VER_BUILD = $$system(git --git-dir ../.git rev-list $$GIT_BRANCH --first-parent --count)
win32 {
    CUSTOM_QGC_VER_BUILD = $$system("set /a $$CUSTOM_QGC_VER_BUILD - $$CUSTOM_QGC_VER_FIRST_BUILD")
} else {
    CUSTOM_QGC_VER_BUILD = $$system("echo $(($$CUSTOM_QGC_VER_BUILD - $$CUSTOM_QGC_VER_FIRST_BUILD))")
}
CUSTOM_QGC_VERSION = $${CUSTOM_QGC_VER_MAJOR}.$${CUSTOM_QGC_VER_MINOR}.$${CUSTOM_QGC_VER_BUILD}

DEFINES -= APP_VERSION_STR=\"\\\"$$APP_VERSION_STR\\\"\"
DEFINES += APP_VERSION_STR=\"\\\"$$CUSTOM_QGC_VERSION\\\"\"

message(Custom QGC Version: $${CUSTOM_QGC_VERSION})

# Build a single flight stack by disabling APM support
# CONFIG  += QGC_DISABLE_APM_MAVLINK                         <-- COMMENTED OUT
# CONFIG  += QGC_DISABLE_APM_PLUGIN QGC_DISABLE_APM_PLUGIN_FACTORY <-- COMMENTED OUT


# We implement our own PX4 plugin factory
# CONFIG  += QGC_DISABLE_PX4_PLUGIN_FACTORY


# Branding

DEFINES += CUSTOMHEADER=\"\\\"CustomPlugin.h\\\"\"
DEFINES += CUSTOMCLASS=CustomPlugin

QGC_APP_NAME        = "Indrones QGroundControl"
QGC_BINARY_NAME     = "IndronesQGroundControl"
QGC_ORG_NAME        = "Indrones"
QGC_ORG_DOMAIN      = "com.indrones"
QGC_ANDROID_PACKAGE = "Indrones.custom.qgroundcontrol"
QGC_APP_DESCRIPTION = "Indrones QGroundControl"
QGC_APP_COPYRIGHT   = "Copyright (C) 2020 Indrones QGroundControl Development Team. All rights reserved."

TARGET   = IndronesQGroundControl
DEFINES += QGC_APPLICATION_NAME='"\\\"$$QGC_APP_NAME\\\""'
DEFINES += QGC_ORG_NAME=\"\\\"$$QGC_ORG_NAME\\\"\"
DEFINES += QGC_ORG_DOMAIN=\"\\\"$$QGC_ORG_DOMAIN\\\"\"
DEFINES += QGC_APP_COPYRIGHT=\"\\\"$$QGC_APP_COPYRIGHT\\\"\"
DEFINES += QGC_APP_DESCRIPTION=\"\\\"$$QGC_APP_DESCRIPTION\\\"\"
DEFINES += QGC_ANDROID_PACKAGE=\"\\\"$$QGC_ANDROID_PACKAGE\\\"\"
DEFINES += QGC_BINARY_NAME=\"\\\"$$QGC_BINARY_NAME\\\"\"


# Our own, custom resources
RESOURCES += \
    $$PWD/custom.qrc

QML_IMPORT_PATH += \
   $$PWD/res

# Our own, custom sources
SOURCES += \
    $$PWD/src/CustomPlugin.cc \

HEADERS += \
    $$PWD/src/CustomPlugin.h \

INCLUDEPATH += \
    $$PWD/src \

#-------------------------------------------------------------------------------------
# Custom Firmware/AutoPilot Plugin

INCLUDEPATH += \
    $$PWD/src/FirmwarePlugin \
    $$PWD/src/AutoPilotPlugin

HEADERS+= \
    $$PWD/src/AutoPilotPlugin/CustomAutoPilotPlugin.h \
    $$PWD/src/FirmwarePlugin/CustomFirmwarePlugin.h \
    $$PWD/src/FirmwarePlugin/CustomFirmwarePluginFactory.h \

SOURCES += \
    $$PWD/src/AutoPilotPlugin/CustomAutoPilotPlugin.cc \
    $$PWD/src/FirmwarePlugin/CustomFirmwarePlugin.cc \
    $$PWD/src/FirmwarePlugin/CustomFirmwarePluginFactory.cc \
