TARGET := iphone:clang:latest:14.0
ARCHS := arm64e

include $(THEOS)/makefiles/common.mk

TOOL_NAME = SettingsBatteryHelper

SettingsBatteryHelper_FILES = main.m
SettingsBatteryHelper_CFLAGS = -fobjc-arc
SettingsBatteryHelper_CODESIGN_FLAGS = -Sentitlements.plist
SettingsBatteryHelper_INSTALL_PATH = /usr/local/bin

include $(THEOS_MAKE_PATH)/tool.mk

after-stage::
	@echo "Copying file to parent directory..."
	cp $(THEOS_STAGING_DIR)/usr/local/bin/$(TOOL_NAME) ../$(TOOL_NAME)/
	@echo "Copy completed."
