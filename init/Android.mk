# Copyright 2005 The Android Open Source Project

LOCAL_PATH:= $(call my-dir)
include $(CLEAR_VARS)

LOCAL_SRC_FILES:= \
	builtins.c \
	init.c \
	devices.c \
	property_service.c \
	util.c \
	parser.c \
	logo.c \
	keychords.c \
	signal_handler.c \
	init_parser.c \
	ueventd.c \
	ueventd_parser.c

ifeq ($(TARGET_PRODUCT),wimmemu)
LOCAL_SRC_FILES+= \
	checkfactoryreset.c \
	verify_system_emu.c \
	getdevkey_init.c \
	setbootsel_init.c \
	../../../bootable/recovery/mtdutils/mtdutils.c \
	../../../external/fw_env/fw_env.c # keith 2010.12.01 yuck, but whatever
else
LOCAL_SRC_FILES+= \
	checkfactoryreset.c \
	verify_system.c \
	getdevkey_init.c \
	setbootsel_init.c \
	../../../bootable/recovery/mtdutils/mtdutils.c \
	../../../external/fw_env/fw_env.c # keith 2010.12.01 yuck, but whatever
endif

LOCAL_C_INCLUDES := external/fw_env bootable/recovery/mtdutils device/wimm/common/tools

ifeq ($(strip $(INIT_BOOTCHART)),true)
LOCAL_SRC_FILES += bootchart.c
LOCAL_CFLAGS    += -DBOOTCHART=1
endif

LOCAL_MODULE:= init

LOCAL_FORCE_STATIC_EXECUTABLE := true
LOCAL_MODULE_PATH := $(TARGET_ROOT_OUT)
LOCAL_UNSTRIPPED_PATH := $(TARGET_ROOT_OUT_UNSTRIPPED)

LOCAL_STATIC_LIBRARIES := libcutils libc libz wimmtools

include $(BUILD_EXECUTABLE)

# Make a symlink from /sbin/ueventd to /init
SYMLINKS := $(TARGET_ROOT_OUT)/sbin/ueventd
$(SYMLINKS): INIT_BINARY := $(LOCAL_MODULE)
$(SYMLINKS): $(LOCAL_INSTALLED_MODULE) $(LOCAL_PATH)/Android.mk
	@echo "Symlink: $@ -> ../$(INIT_BINARY)"
	@mkdir -p $(dir $@)
	@rm -rf $@
	$(hide) ln -sf ../$(INIT_BINARY) $@

ALL_DEFAULT_INSTALLED_MODULES += $(SYMLINKS)

# We need this so that the installed files could be picked up based on the
# local module name
ALL_MODULES.$(LOCAL_MODULE).INSTALLED := \
    $(ALL_MODULES.$(LOCAL_MODULE).INSTALLED) $(SYMLINKS)
