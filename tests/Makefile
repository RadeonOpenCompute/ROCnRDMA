ifeq ($(AMDP2P_ROOT),)
SRC_DIR := $(PWD)
else
SRC_DIR := $(AMDP2P_ROOT)/tests
endif

# Developers could use 'make O=<path>' to redirect the build folder.
ifneq ($(O),)
# When the build folder doesn't contain a Makefile, kbuild will fail. Create
# an empty Makefile
BUILD_DIR := $(shell mkdir -p $(O) && cd $(O) && /usr/bin/touch Makefile \
                     && /bin/pwd)
else
BUILD_DIR := $(SRC_DIR)
endif

ifneq ($(KERNELRELEASE),)
# Specify default location of RDM header
RDMA_HEADER_DIR := $(KERNEL_ROOT)/include/drm
ifeq ("$(wildcard $(RDMA_HEADER_DIR)/amd_rdma.h)","")
RDMA_HEADER_DIR := /usr/src/linux-headers-$(shell uname -r)/include/drm
ifeq ("$(wildcard $(RDMA_HEADER_DIR)/amd_rdma.h)","")
$(error amd_rdma.h header is not found. Use KERNEL_ROOT= to point to the kernel source)
endif
endif


kver_major:=$(shell echo $(KERNELRELEASE) | awk -F '.' '// { print $$2;}' )

obj-m += amdp2ptest.o

ccflags-y += -I$(RDMA_HEADER_DIR) -I$(SRC_DIR)/../include

else

KDIR ?= /lib/modules/$(shell uname -r)/build
REL := $(subst ., , $(subst -, , $(shell uname -r)))
REL_MAJOR  := $(word 1,$(REL))
REL_MEDIUM := $(word 2,$(REL))
REL_MINOR  := $(word 3,$(REL))

all: default

default:
	@ $(MAKE) -C $(KDIR) M=$(BUILD_DIR) src=$(SRC_DIR)

install:
	$(MAKE) -C $(KDIR) M=$(BUILD_DIR) modules_install

help:
	$(MAKE) -C $(KDIR) M=$(SRC_DIR) help

clean: clean_extra
	cd $(BUILD_DIR) && \
	rm -rf *.o *.ko* *.mod.* .*.cmd Module.symvers modules.order .tmp_versions/ *~ core .depend TAGS

ifeq ($(BUILD_DIR),$(SRC_DIR))
clean_extra:
else
clean_extra:
	rm -f $(BUILD_DIR)/Makefile
endif

TAGS:
	find $(KERNELDIR) -follow -name \*.h -o -name \*.c  |xargs etags

.PHONY: clean all help install default linksyms

endif
