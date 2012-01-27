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
	checkfactoryreset.c \
	verify_system.c \
	getdevkey_init.c \
	setbootsel_init.c \
	../../../bootable/recovery/mtdutils/mtdutils.c \
	../../../external/fw_env/fw_env.c # keith 2010.12.01 yuck, but whatever

LOCAL_C_INCLUDES := external/fw_env bootable/recovery/mtdutils vendor/WIMM/tools

ifeq ($(strip $(INIT_BOOTCHART)),true)
LOCAL_SRC_FILES += bootchart.c
LOCAL_CFLAGS    += -DBOOTCHART=1
endif

ifeq ($(TARGET_BOARD_PLATFORM),s5p6442)
LOCAL_CFLAGS  += -DSLSI_S5P6442
endif

LOCAL_MODULE:= init

LOCAL_FORCE_STATIC_EXECUTABLE := true
LOCAL_MODULE_PATH := $(TARGET_ROOT_OUT)
LOCAL_UNSTRIPPED_PATH := $(TARGET_ROOT_OUT_UNSTRIPPED)

LOCAL_STATIC_LIBRARIES := libcutils libc libz wimmtools

#LOCAL_STATIC_LIBRARIES := libcutils libc libminui libpixelflinger_static
#LOCAL_STATIC_LIBRARIES += libminzip libunz libamend libmtdutils libmincrypt
#LOCAL_STATIC_LIBRARIES += libstdc++_static

include $(BUILD_EXECUTABLE)

