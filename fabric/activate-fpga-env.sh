#! /bin/bash
echo "Activating Symbiflow Build Env for EOS-S3"

export F4PGA_INSTALL_DIR=/opt/f4pga
export FPGA_FAM="eos-s3"

source $F4PGA_INSTALL_DIR/$FPGA_FAM/conda/etc/profile.d/conda.sh
conda activate $FPGA_FAM

