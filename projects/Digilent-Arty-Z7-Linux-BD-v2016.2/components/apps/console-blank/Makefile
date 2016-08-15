ifndef PETALINUX
$(error "Error: PETALINUX environment variable not set.  Change to the root of your PetaLinux install, and source the settings.sh file")
endif

include apps.common.mk

APP = console-blank

all: install

.PHONY: install

install:
	$(TARGETINST) -p 0755 $(APP).sh /etc/init.d/$(APP)
	$(TARGETINST) -s /etc/init.d/$(APP) /etc/rcS.d/S39$(APP)

help:
	@echo ""
	@echo "Quick reference for various supported build targets for $(INSTANCE)."
	@echo "----------------------------------------------------"
	@echo "  install                install built objects to rootfs host copy"
