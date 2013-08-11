PRODUCT_BRAND ?= orca

-include vendor/cm-priv/keys.mk
SUPERUSER_EMBEDDED := true
SUPERUSER_PACKAGE_PREFIX := com.android.settings.cyanogenmod.superuser

# To deal with CM9 specifications
# TODO: remove once all devices have been switched
ifneq ($(TARGET_BOOTANIMATION_NAME),)
TARGET_SCREEN_DIMENSIONS := $(subst -, $(space), $(subst x, $(space), $(TARGET_BOOTANIMATION_NAME)))
ifeq ($(TARGET_SCREEN_WIDTH),)
TARGET_SCREEN_WIDTH := $(word 2, $(TARGET_SCREEN_DIMENSIONS))
endif
ifeq ($(TARGET_SCREEN_HEIGHT),)
TARGET_SCREEN_HEIGHT := $(word 3, $(TARGET_SCREEN_DIMENSIONS))
endif
endif

ifneq ($(TARGET_SCREEN_WIDTH) $(TARGET_SCREEN_HEIGHT),$(space))

# clear TARGET_BOOTANIMATION_NAME in case it was set for CM9 purposes
TARGET_BOOTANIMATION_NAME :=

# determine the smaller dimension
TARGET_BOOTANIMATION_SIZE := $(shell \
  if [ $(TARGET_SCREEN_WIDTH) -lt $(TARGET_SCREEN_HEIGHT) ]; then \
    echo $(TARGET_SCREEN_WIDTH); \
  else \
    echo $(TARGET_SCREEN_HEIGHT); \
  fi )

# get a sorted list of the sizes
bootanimation_sizes := $(subst .zip,, $(shell ls vendor/orca/prebuilt/common/bootanimation))
bootanimation_sizes := $(shell echo -e $(subst $(space),'\n',$(bootanimation_sizes)) | sort -rn)

# find the appropriate size and set
define check_and_set_bootanimation
$(eval TARGET_BOOTANIMATION_NAME := $(shell \
  if [ -z "$(TARGET_BOOTANIMATION_NAME)" ]; then
    if [ $(1) -le $(TARGET_BOOTANIMATION_SIZE) ]; then \
      echo $(1); \
      exit 0; \
    fi;
  fi;
  echo $(TARGET_BOOTANIMATION_NAME); ))
endef
$(foreach size,$(bootanimation_sizes), $(call check_and_set_bootanimation,$(size)))

PRODUCT_COPY_FILES += \
    vendor/orca/prebuilt/common/bootanimation/$(TARGET_BOOTANIMATION_NAME).zip:system/media/bootanimation.zip
endif

ifdef ORCA_NIGHTLY
PRODUCT_PROPERTY_OVERRIDES += \
    ro.rommanager.developerid=orcaproject
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.rommanager.developerid=orcaproject
endif

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

PRODUCT_PROPERTY_OVERRIDES += \
    keyguard.no_require_sim=true \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html \
    ro.com.google.clientidbase=android-google \
    ro.com.android.wifi-watchlist=GoogleGuest \
    ro.setupwizard.enterprise_mode=1 \
    ro.com.android.dateformat=MM-dd-yyyy \
    ro.com.android.dataroaming=false

PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.selinux=1

ifneq ($(TARGET_BUILD_VARIANT),eng)
# Enable ADB authentication
ADDITIONAL_DEFAULT_PROPERTIES += ro.adb.secure=1
endif

# Copy over the changelog to the device
PRODUCT_COPY_FILES += \
    vendor/orca/CHANGELOG.mkdn:system/etc/CHANGELOG-CM.txt

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/orca/prebuilt/common/bin/backuptool.sh:system/bin/backuptool.sh \
    vendor/orca/prebuilt/common/bin/backuptool.functions:system/bin/backuptool.functions \
    vendor/orca/prebuilt/common/bin/50-cm.sh:system/addon.d/50-cm.sh \
    vendor/orca/prebuilt/common/bin/blacklist:system/addon.d/blacklist

# init.d support
PRODUCT_COPY_FILES += \
    vendor/orca/prebuilt/common/etc/init.d/00banner:system/etc/init.d/00banner \
    vendor/orca/prebuilt/common/bin/sysinit:system/bin/sysinit

# APPS TO COPY
PRODUCT_COPY_FILES += \
    vendor/orca/prebuilt/common/app/GooManager.apk:system/app/GooManager.apk  
    
# userinit support
PRODUCT_COPY_FILES += \
    vendor/orca/prebuilt/common/etc/init.d/90userinit:system/etc/init.d/90userinit

# SELinux filesystem labels
PRODUCT_COPY_FILES += \
    vendor/orca/prebuilt/common/etc/init.d/50selinuxrelabel:system/etc/init.d/50selinuxrelabel

# CM-specific init file needed for Root Priviledges
PRODUCT_COPY_FILES += \
    vendor/orca/prebuilt/common/etc/init.local.rc:root/init.cm.rc

# Compcache/Zram support
PRODUCT_COPY_FILES += \
    vendor/orca/prebuilt/common/bin/compcache:system/bin/compcache \
    vendor/orca/prebuilt/common/bin/handle_compcache:system/bin/handle_compcache

# Bring in camera effects
PRODUCT_COPY_FILES +=  \
    vendor/orca/prebuilt/common/media/LMprec_508.emd:system/media/LMprec_508.emd \
    vendor/orca/prebuilt/common/media/PFFprec_600.emd:system/media/PFFprec_600.emd

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# Enable wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:system/usr/keylayout/Vendor_045e_Product_0719.kl

# This is Orca Cyan!
PRODUCT_COPY_FILES += \
    vendor/orca/config/permissions/com.cyanogenmod.android.xml:system/etc/permissions/com.cyanogenmod.android.xml

# Don't export PS1 in /system/etc/mkshrc.
PRODUCT_COPY_FILES += \
    vendor/orca/prebuilt/common/etc/mkshrc:system/etc/mkshrc

# T-Mobile theme engine
include vendor/cm/config/themes_common.mk

# Required Orca packages
PRODUCT_PACKAGES += \
    Focal \
    DaskClock \
    Development \
    LatinIME \
    Superuser \
    su

# Optional Orca packages
PRODUCT_PACKAGES += \
    VoicePlus \
    VideoEditor \
    VoiceDialer \
    SoundRecorder \
    Basic

# Custom Orca packages
PRODUCT_PACKAGES += \
    DSPManager \
    libcyanogen-dsp \
    audio_effects.conf \
    OrcaWallpapers \
    Apollo \
    CMFileManager \
    LockClock

# Orca Cyan Hardware Abstraction Framework
PRODUCT_PACKAGES += \
    org.cyanogenmod.hardware \
    org.cyanogenmod.hardware.xml

PRODUCT_PACKAGES += \
    CellBroadcastReceiver

# Extra tools in Orca
PRODUCT_PACKAGES += \
    openvpn \
    e2fsck \
    mke2fs \
    tune2fs \
    bash \
    vim \
    nano \
    htop \
    powertop \
    lsof \
    mount.exfat \
    fsck.exfat \
    mkfs.exfat \
    ntfsfix \
    ntfs-3g

# Openssh
PRODUCT_PACKAGES += \
    scp \
    sftp \
    ssh \
    sshd \
    sshd_config \
    ssh-keygen \
    start-ssh

# rsync
PRODUCT_PACKAGES += \
    rsync

PRODUCT_PACKAGE_OVERLAYS += vendor/orca/overlay/dictionaries
PRODUCT_PACKAGE_OVERLAYS += vendor/orca/overlay/common

PRODUCT_VERSION_MAJOR = 3
PRODUCT_VERSION_MINOR = 0
PRODUCT_VERSION_MAINTENANCE = 3

# Set ORCA_BUILDTYPE
ifdef ORCA_NIGHTLY
    ORCA_BUILDTYPE := NIGHTLY
endif
ifdef ORCA_EXPERIMENTAL
    ORCA_BUILDTYPE := EXPERIMENTAL
endif
ifdef ORCA_RELEASE
    ORCA_BUILDTYPE := RELEASE
endif

ifdef ORCA_BUILDTYPE
    ifdef ORCA_EXTRAVERSION
        # Force build type to EXPERIMENTAL
        ORCA_BUILDTYPE := EXPERIMENTAL
        # Remove leading dash from ORCA_EXTRAVERSION
        ORCA_EXTRAVERSION := $(shell echo $(ORCA_EXTRAVERSION) | sed 's/-//')
        # Add leading dash to ORCA_EXTRAVERSION
        ORCA_EXTRAVERSION := -$(ORCA_EXTRAVERSION)
    endif
else
    # If ORCA_BUILDTYPE is not defined, set to UNOFFICIAL
    ORCA_BUILDTYPE := UNOFFICIAL
    ORCA_EXTRAVERSION :=
endif

ifdef ORCA_RELEASE
    ORCA_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE)$(PRODUCT_VERSION_DEVICE_SPECIFIC)-$(ORCA_BUILD)
else
    ifeq ($(PRODUCT_VERSION_MINOR),0)
        ORCA_VERSION := $(PRODUCT_VERSION_MAJOR)-$(shell date -u +%Y%m%d)-$(ORCA_BUILDTYPE)-$(ORCA_BUILD)$(ORCA_EXTRAVERSION)
    else
        ORCA_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(shell date -u +%Y%m%d)-$(ORCA_BUILDTYPE)-$(ORCA_BUILD)$(ORCA_EXTRAVERSION)
    endif
endif

PRODUCT_PROPERTY_OVERRIDES += \
  ro.orca.version=$(ORCA_VERSION) \
  ro.modversion=$(ORCA_VERSION)


-include $(WORKSPACE)/hudson/image-auto-bits.mk
