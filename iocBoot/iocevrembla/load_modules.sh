#!/bin/bash

sudo modprobe uio
sudo modprobe parport
sudo insmod mrmShared/linux/mrf.ko
