# Detection of Mellanox OFED kernel location
OFA_KERNEL_DIR=$(shell (test -d /usr/src/ofa_kernel/default && echo /usr/src/ofa_kernel/default) || (test -d /var/lib/dkms/mlnx-ofed-kernel/ && ls -d /var/lib/dkms/mlnx-ofed-kernel/*/build))

ifeq ("$(OFA_KERNEL_DIR)","")
$(error Could not find OFA Kernel installed.)
else
$(info INFO: OFA Kernel location is $(OFA_KERNEL_DIR))
endif



ifeq ($(src),)
	src := $$PWD
endif


OFED_SYMBOLS=$(OFA_KERNEL_DIR)/Module.symvers
KBUILD_EXTRA_SYMBOLS=$(OFED_SYMBOLS)


ifneq ($(KERNELRELEASE),)

RDMA_HEADER_DIR := /usr/src/linux-headers-$(shell uname -r)/include/drm
ifeq ("$(wildcard $(RDMA_HEADER_DIR)/amd_rdma.h)","")
$(error amd_rdma.h header is not found)
endif

$(info INFO: AMD RDMA Header location is $(RDMA_HEADER_DIR))

kver_major:=$(shell echo $(KERNELRELEASE) | awk -F '.' '// { print $$2;}' )

obj-m += amdp2p.o


ccflags-y += -I $(RDMA_HEADER_DIR)
ccflags-y += -I$(OFA_KERNEL_DIR)/include/

all: default

default:
	@ $(MAKE) -C $(KDIR) M=$$PWD  modules


else

KDIR ?= /lib/modules/$(shell uname -r)/build
REL := $(subst ., , $(subst -, , $(shell uname -r)))
REL_MAJOR  := $(word 1,$(REL))
REL_MEDIUM := $(word 2,$(REL))
REL_MINOR  := $(word 3,$(REL))

all: default

default:
	@ $(MAKE) -C $(KDIR) M=$$PWD  modules

install:
	$(MAKE) -C $(KDIR) M=$$PWD  modules_install

help:
	$(MAKE) -C $(KDIR) M=$$PWD help

clean:
	rm -rf *.o *.ko* *.mod.* .*.cmd Module.symvers modules.order .tmp_versions/ *~ core .depend TAGS

TAGS:
	find $(KERNELDIR) -follow -name \*.h -o -name \*.c  |xargs etags

.PHONY: clean all help install default linksyms

endif
