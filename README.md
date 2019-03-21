### Peer-to-Peer bridge driver for PeerDirect - Deprecated Repo

#### This is now included as part of the [ROCK Kernel Driver](https://github.com/RadeonOpenCompute/ROCK-Kernel-Driver)

This is the kernel mode driver which provides a direct P2P path between the GPU memory
and HCA device supporting PeerDirect interface from Mellanox.

This driver is not a standalone product and requires the correct KFD
installed together with kernel headers as well as OFED distribution with
PeerDirect enabled.

#### Tested environment

Only the following configuration was tested:

- Hardware:
    - Fiji flashed with large aperture VBIOS
    - Mellanox IB mlnx5.0

- Software:
    - Ubuntu 14.04 64-bit
    - MLNX_OFED_LINUX-3.2-1.0.1.1-ubuntu14.04-x86_64.iso


#### Installation

To install the driver the following steps should be done:

- Install Boltzmann kernel driver include kernel header files
- Install Mellanox OFED

    Note: OFED must be installed after KFD kernel being installed. Any kernel update using dpkg will require
    to install Mellanox OFED again.


- Build and load amdp2p driver
```bash
    make
    sudo insmod amdp2p.ko
```

##### Troubleshooting

- amdp2p depends on the following header files from the linux kernel header
directory ('/usr/src/linux-headers-$(shell uname -r)'):

    - peer_mem.h

    OFED provided header files to specify PeerDirect API. This header file
    should be located in ".../include/rdma"  directory.

    - amd_rdma.h

    Header file specifying kernel interface to kfd driver for rdma / p2p communication.
    This header file should be located in  ".../include/drm" directory.

- If amdp2p driver fails to load please check that Module.symvers from OFED was generated successfully / correctly.


- In case of issues please enable dynamic debug functionality via /sys/kernel/debug/dynamic_debug/control for amdp2p.ko module.


#### Known issues and restrictions

- Only 64-bit applications are supported
- Memory PCI BAR for AMD GPU must be configured below [64:40] in MMIO Range for GFX8 based GPU's.  GFX9/Vega can be configured [64:44] in the MMIO Range. 
- IB Verbs interface must be used for communication with network stack.

##### Recommendation

- It is recommended to disable IOMMU support completely
- It is recommended to have GPU and HCA on the same PCIe root complex

#### Disclaimer

The information contained herein is for informational purposes only, and is subject to change without notice. While every precaution has been taken in the preparation of this document, it may contain technical inaccuracies, omissions and typographical errors, and AMD is under no obligation to update or otherwise correct this information. Advanced Micro Devices, Inc. makes no representations or warranties with respect to the accuracy or completeness of the contents of this document, and assumes no liability of any kind, including the implied warranties of noninfringement, merchantability or fitness for particular purposes, with respect to the operation or use of AMD hardware, software or other products described herein. No license, including implied or arising by estoppel, to any intellectual property rights is granted by this document. Terms and limitations applicable to the purchase or use of AMD's products are as set forth in a signed agreement between the parties or in AMD's Standard Terms and Conditions of Sale.

AMD, the AMD Arrow logo, and combinations thereof are trademarks of Advanced Micro Devices, Inc. Other product names used in this publication are for identification purposes only and may be trademarks of their respective companies.

Copyright (c) 2014-2016 Advanced Micro Devices, Inc. All rights reserved.
