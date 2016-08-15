ifndef PETALINUX
$(error "Error: PETALINUX environment variable not set.  Change to the root of your PetaLinux install, and source the settings.sh file")
endif

include apps.common.mk

all: install

.PHONY: install

install:
	$(TARGETINST) -a "0:12345:respawn:/sbin/getty 38400 tty0" /etc/inittab

help:
	@echo ""
	@echo "Quick reference for various supported build targets for $(INSTANCE)."
	@echo "----------------------------------------------------"
	@echo "  install                install built objects to rootfs host copy"
