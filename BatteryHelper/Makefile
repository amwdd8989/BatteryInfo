TARGET = iphone:clang:latest:12.0
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

LIBRARY_NAME = BatteryHelper
$(LIBRARY_NAME)_FILES = BatteryHelper.m
$(LIBRARY_NAME)_CFLAGS = -fobjc-arc
$(LIBRARY_NAME)_LINKAGE_TYPE = static
$(LIBRARY_NAME)_FRAMEWORKS = IOKit

include $(THEOS_MAKE_PATH)/library.mk
