export DEBUG = 0
export ARCHS = armv7 armv7s arm64
TARGET = iphone:latest:7.0
include theos/makefiles/common.mk

TOOL_NAME = defaults
defaults_FILES = main.mm

defaults_FRAMEWORKS = AssetsLibrary UIKit SystemConfiguration CoreFoundation AddressBookUI AddressBook CoreGraphics CoreMedia AVFoundation CoreTelephony Foundation

include $(THEOS_MAKE_PATH)/tool.mk
