export ARCHS = armv7 armv7s arm64

export THEOS_DEVICE_IP = p92
export TARGET = iphone:latest:7.0
export DEBUG = 0

include $(THEOS)/makefiles/common.mk

TOOL_NAME = keychain
keychain_FILES = main.mm add.mm delet.mm query.mm common.mm saveKeychain.mm

keychain_CFLAGS = -fobjc-arc
include $(THEOS_MAKE_PATH)/tool.mk



before-package::
	ldid -Sentitlements.xml $(THEOS_STAGING_DIR)/usr/bin/keychain
	#cp postinst $(THEOS_STAGING_DIR)/DEBIAN/


after-package::
	

after-install::
