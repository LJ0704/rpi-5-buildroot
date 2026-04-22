##############################################################
#
# AESD-FINAL-PROJECT
#
# Builds and installs:
#   - aesdsocket (NVMe socket server)
#   - aesdchar kernel module
#   - libnvme (static, cross-compiled via meson)
#   - libparted (static, cross-compiled via autoconf)
#
##############################################################

AESD_FINAL_PROJECT_VERSION = main
AESD_FINAL_PROJECT_SITE = https://github.com/zanemcmorris/AESD_Final_Project.git
AESD_FINAL_PROJECT_SITE_METHOD = git
AESD_FINAL_PROJECT_GIT_SUBMODULES = YES

AESD_FINAL_PROJECT_LICENSE = MIT
AESD_FINAL_PROJECT_LICENSE_FILES = readme.md

AESD_FINAL_PROJECT_DEPENDENCIES = \
	parted \
	libnvme \
	util-linux \
	linux

# ----------------------------------------------------------------
# aesdchar kernel module
# ----------------------------------------------------------------
define AESD_FINAL_PROJECT_BUILD_KMOD
	$(MAKE) $(LINUX_MAKE_FLAGS) \
		-C $(LINUX_DIR) \
		M=$(@D)/aesd-char-driver \
		modules
endef

define AESD_FINAL_PROJECT_BUILD_CMDS
	$(AESD_FINAL_PROJECT_BUILD_KMOD)
	$(MAKE) $(TARGET_CONFIGURE_OPTS) \
		LIBNVME_PREFIX=$(STAGING_DIR)/usr \
		PARTED_LOCAL_INC=$(STAGING_DIR)/usr/include \
		PARTED_LIBDIR=$(STAGING_DIR)/usr/lib \
		PARTED_PC_DIR=$(STAGING_DIR)/usr/lib/pkgconfig \
		PERF_DIR=$(@D)/final-project-LJ0704/perf_cmd \
		PERF_INC=$(@D)/final-project-LJ0704/perf_cmd \
		PKG_CONFIG=$(PKG_CONFIG_HOST_BINARY) \
		PKG_CONFIG_SYSROOT_DIR=$(STAGING_DIR) \
		PKG_CONFIG_LIBDIR=$(STAGING_DIR)/usr/lib/pkgconfig \
		CFLAGS="$(TARGET_CFLAGS) -I$(STAGING_DIR)/usr/include -I$(@D)/final-project-LJ0704/perf_cmd" \
		-C $(@D)/server
endef

# ----------------------------------------------------------------
# Install everything
# ----------------------------------------------------------------
define AESD_FINAL_PROJECT_INSTALL_TARGET_CMDS
	# Socket server binary + init script
	$(INSTALL) -D -m 0755 $(@D)/server/aesdsocket \
		$(TARGET_DIR)/usr/bin/aesdsocket
	$(INSTALL) -D -m 0755 $(@D)/server/aesdsocket-start-stop \
		$(TARGET_DIR)/etc/init.d/S99aesdsocket

	# Char driver load/unload helpers + init script
	$(INSTALL) -D -m 0755 $(@D)/aesd-char-driver/aesdchar_load \
		$(TARGET_DIR)/usr/bin/aesdchar_load
	$(INSTALL) -D -m 0755 $(@D)/aesd-char-driver/aesdchar_unload \
		$(TARGET_DIR)/usr/bin/aesdchar_unload
	$(INSTALL) -D -m 0755 $(@D)/aesd-char-driver/aesd-start-stop \
		$(TARGET_DIR)/etc/init.d/S98aesdchar

	# Kernel module
	$(MAKE) $(LINUX_MAKE_FLAGS) \
		-C $(LINUX_DIR) \
		M=$(@D)/aesd-char-driver \
		INSTALL_MOD_PATH=$(TARGET_DIR) \
		modules_install
endef

$(eval $(generic-package))

