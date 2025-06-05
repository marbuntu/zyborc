
all:
	ql_symbiflow -compile \
	  -d ql-eos-s3 \
	  -P PD64 \
	  -t top \
	  -v soc/AL4S3B_FPGA_Top.v \
	  	 soc/AL4S3B_FPGA_QL_Reserved.v \
		 soc/AL4S3B_FPGA_Registers.v \
		 soc/AL4S3B_FPGA_IP.v \
		 gpio/GPIO_Controller.v \
	  -p pinout.pcf \
	  -dump header \
	  -dump binary

quickfeather:
	ql_symbiflow -compile \
	  -d ql-eos-s3 \
	  -P PD64 \
	  -t top \
	  -v soc/AL4S3B_FPGA_Top.v \
	  	 soc/AL4S3B_FPGA_QL_Reserved.v \
		 soc/AL4S3B_FPGA_Registers.v \
		 soc/AL4S3B_FPGA_IP.v \
		 gpio/GPIO_Controller.v \
	  -p soc/quickfeather.pcf \
	  -dump header \
	  -dump binary

clean: 
	rm -r ./build