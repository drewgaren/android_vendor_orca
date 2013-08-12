# Inherit common Orca stuff
$(call inherit-product, vendor/orca/config/common.mk)

# Bring in all audio files
include frameworks/base/data/sounds/NewAudio.mk

# Default ringtone
PRODUCT_PROPERTY_OVERRIDES += \
    ro.config.ringtone=Orion.ogg \
    ro.config.notification_sound=Argon.ogg \
    ro.config.alarm_alert=Hassium.ogg

PRODUCT_PACKAGES += \
  Mms

