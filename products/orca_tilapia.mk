# Copyright (C) 2012 The Orca Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Inherit AOSP device configuration
$(call inherit-product, device/asus/tilapia/full_tilapia.mk)

# Define ORCA bootanimation size
ORCA_BOOTANIMATION_NAME := XHDPI

# OVERLAY_TARGET adds overlay asset source
OVERLAY_TARGET := pa_tvdpi

# Build paprefs from sources
PREFS_FROM_SOURCE ?= true

# Include ORCA common configuration
include vendor/orca/config/orca_common.mk

# Inherit GSM common stuff
include vendor/orca/config/gsm.mk

# Override AOSP build properties
PRODUCT_NAME := orca_tilapia
PRODUCT_BRAND := Google
PRODUCT_MODEL := Nexus 7
PRODUCT_MANUFACTURER := Asus
PRODUCT_BUILD_PROP_OVERRIDES += PRODUCT_NAME=nakasi BUILD_FINGERPRINT="google/nakasig/tilapia:4.3/JSS15J/737497:user/release-keys"
PRIVATE_BUILD_DESC="nakasi-user 4.3 JSS15J 737497 release-keys"



