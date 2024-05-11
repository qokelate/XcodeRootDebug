THEOS_PACKAGE_SCHEME=rootless
# PACKAGE_BUILDNAME := rootless

THEOS_DEVICE_IP = localhost -o StrictHostKeyChecking=no
THEOS_DEVICE_PORT = 2222

TARGET = ::9.0
ARCHS = arm64 arm64e
TARGET_CC = xcrun -sdk iphoneos clang -stdlib=libc++
TARGET_CXX = xcrun -sdk iphoneos clang++ -stdlib=libc++
TARGET_LD = xcrun -sdk iphoneos clang++
ADDITIONAL_OBJCFLAGS = -fobjc-arc -Wno-error
# LDFLAGS=-lz

INSTALL_TARGET_PROCESSES = lockdownd


include $(THEOS)/makefiles/common.mk

TWEAK_NAME = XcodeRootDebug

$(TWEAK_NAME)_FILES = Tweak.x
$(TWEAK_NAME)_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

BUNDLE_NAME = $(TWEAK_NAME)Prefs

# $(TWEAK_NAME)_OBJ_FILES = layout/var/jb/var/root/usr/lib/libsubstrate.dylib
$(TWEAK_NAME)Prefs_FILES = XRDRootListController.m
$(TWEAK_NAME)Prefs_FRAMEWORKS = UIKit
$(TWEAK_NAME)Prefs_PRIVATE_FRAMEWORKS = Preferences
$(TWEAK_NAME)Prefs_INSTALL_PATH = /Library/PreferenceBundles
$(TWEAK_NAME)Prefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk