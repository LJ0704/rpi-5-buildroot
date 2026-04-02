# buildroot-rpi

This repository contains assignment starter code for buildroot based assignments for the course Advanced Embedded Software Design, ECEN 5713

We will be using rpi3

Configuration of rpi  for Buildroot:
----------------------------
Other configuration of rpi:
----------------------------
For models A, B, A+ or B+:

  $ make raspberrypi_defconfig

For model Zero (model A+ in smaller form factor):

  $ make raspberrypi0_defconfig

For model 2 B:

  $ make raspberrypi2_defconfig

For model 3 B and B+:

  $ make raspberrypi3_defconfig

For model 4 B:

  $ make raspberrypi4_defconfig
  
  
  Note: 
  Initially I faced issue relate Device tree blob (dtb) due to conflict on BCM2712 based on Rpi 5 RAM 
  Fix: the below blog helped me how to work around with this issue 
  https://hub.mender.io/t/asynchronous-serror-interrupt-rpi5-boot-issue/7275
