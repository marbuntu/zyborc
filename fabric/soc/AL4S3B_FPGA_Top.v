
`timescale 1ns / 10ps

module top ( 
            // UART 0
            UART0_SIN_i,
            UART0_SOUT_o,

            // GPIO
            GPIO_io,
            

            // SPI Signals
            spi_clk,
            spi_co,
            spi_ci,
            spi_cs,
            spi_drdy,

            );

//------Port Signals-------------------

// UART 0
input                   UART0_SIN_i;
output                  UART0_SOUT_o;

// GPIO
inout   [7:0]           GPIO_io;
output                  spi_clk;
output                  spi_co;
inout                   spi_ci;
output                  spi_cs;
inout                   spi_drdy;


//------Define Parameters--------------
// None at this time

//------Internal Signals---------------

// FPGA Global Signals
wire            CLK_IP          ;
wire            RST_IP          ;
     
wire            WB_CLK          ; // Selected FPGA Clock

wire            Sys_Clk0        ; // Selected FPGA Clock
wire            Sys_Clk0_Rst    ; // Selected FPGA Reset

wire            Sys_Clk1        ; // Selected FPGA Clock
wire            Sys_Clk1_Rst    ; // Selected FPGA Reset

// Wishbone Bus Signals
wire    [16:0]  WBs_ADR         ; // Wishbone Address Bus
wire            WBs_CYC         ; // Wishbone Client Cycle  Strobe (i.e. Chip Select)
wire     [3:0]  WBs_BYTE_STB    ; // Wishbone Byte   Enables
wire            WBs_WE          ; // Wishbone Write  Enable Strobe
wire            WBs_RD          ; // Wishbone Read   Enable Strobe
wire            WBs_STB         ; // Wishbone Transfer      Strobe
wire    [31:0]  WBs_RD_DAT      ; // Wishbone Read   Data Bus
wire    [31:0]  WBs_WR_DAT      ; // Wishbone Write  Data Bus
wire            WBs_ACK         ; // Wishbone Client Acknowledge
wire            WB_RST          ; // Wishbone FPGA Reset
wire            WB_RST_FPGA     ; // Wishbone FPGA Reset

// Misc
wire    [31:0]  Device_ID      ;

// UART 0
wire            UART0_SIN_i;
wire            UART0_SOUT_o;

wire            UART0_Intr;

wire    [31:0]  GPIO;

//------Logic Operations---------------

// Determine the FPGA reset
//
// Note: Reset the FPGA IP on either the AHB or clock domain reset signals.
gclkbuff u_gclkbuff_reset ( .A(Sys_Clk0_Rst | WB_RST) , .Z(WB_RST_FPGA) );
gclkbuff u_gclkbuff_clock ( .A(Sys_Clk0             ) , .Z(WB_CLK       ) );

assign RST_IP = Sys_Clk0_Rst;
assign CLK_IP = Sys_Clk0;

assign GPIO_io = GPIO[7:0];

//------Instantiate Modules------------

AL4S3B_FPGA_IP u_AL4S3B_FPGA_IP (

    // AHB-To_FPGA Bridge I/F
    //
    .CLK_IP_i                   ( CLK_IP                    ),
    .RST_IP_i                   ( RST_IP                    ),

    .WBs_ADR                    ( WBs_ADR                   ), // input  [16:0] | Address Bus                to   FPGA
    .WBs_CYC                    ( WBs_CYC                   ), // input         | Cycle Chip Select          to   FPGA
    .WBs_BYTE_STB               ( WBs_BYTE_STB              ), // input   [3:0] | Byte Select                to   FPGA
    .WBs_WE                     ( WBs_WE                    ), // input         | Write Enable               to   FPGA
    .WBs_RD                     ( WBs_RD                    ), // input         | Read  Enable               to   FPGA
    .WBs_STB                    ( WBs_STB                   ), // input         | Strobe Signal              to   FPGA
    .WBs_WR_DAT                 ( WBs_WR_DAT                ), // input  [31:0] | Write Data Bus             to   FPGA
    .WB_CLK                     ( WB_CLK                    ), // output        | FPGA Clock               from FPGA
    .WB_RST                     ( WB_RST_FPGA               ), // input         | FPGA Reset               to   FPGA
    .WBs_RD_DAT                 ( WBs_RD_DAT                ), // output [31:0] | Read Data Bus              from FPGA
    .WBs_ACK                    ( WBs_ACK                   ), // output        | Transfer Cycle Acknowledge from FPGA

    // UART 0
    .UART0_SIN_i                ( UART0_SIN_i               ),
    .UART0_SOUT_o               ( UART0_SOUT_o              ),   

    .UART0_Intr_o               ( UART0_Intr                ),   

    // GPIO
    .GPIO_io                    ( GPIO                      ),

    .Device_ID_o                ( Device_ID                 ),

    .SPI_clk_o                  ( spi_clk                   ),
    .SPI_co                     ( spi_co                    ),
    .SPI_ci                     ( spi_ci                    ),
    .SPI_cs                     ( spi_cs                    ),
    .SPI_drdy                   ( spi_drdy                  ),
);

// Verilog model of QLAL4S3B
qlal4s3b_cell_macro u_qlal4s3b_cell_macro (
    // AHB-To-FPGA Bridge
    .WBs_ADR                   ( WBs_ADR                     ), // output [16:0] | Address Bus                to   FPGA
    .WBs_CYC                   ( WBs_CYC                     ), // output        | Cycle Chip Select          to   FPGA
    .WBs_BYTE_STB              ( WBs_BYTE_STB                ), // output  [3:0] | Byte Select                to   FPGA
    .WBs_WE                    ( WBs_WE                      ), // output        | Write Enable               to   FPGA
    .WBs_RD                    ( WBs_RD                      ), // output        | Read  Enable               to   FPGA
    .WBs_STB                   ( WBs_STB                     ), // output        | Strobe Signal              to   FPGA
    .WBs_WR_DAT                ( WBs_WR_DAT                  ), // output [31:0] | Write Data Bus             to   FPGA
    .WB_CLK                    ( WB_CLK                      ), // input         | FPGA Clock               from FPGA
    .WB_RST                    ( WB_RST                      ), // output        | FPGA Reset               to   FPGA
    .WBs_RD_DAT                ( WBs_RD_DAT                  ), // input  [31:0] | Read Data Bus              from FPGA
    .WBs_ACK                   ( WBs_ACK                     ), // input         | Transfer Cycle Acknowledge from FPGA

    // SDMA Signals
    .SDMA_Req                  ({ 3'b000, 1'b0        }), // input   [3:0]
    .SDMA_Sreq                 (  4'b0000                   ), // input   [3:0]
    .SDMA_Done                 (), // output  [3:0]
    .SDMA_Active               (), // output  [3:0]

    // FB Interrupts
    .FB_msg_out                ({1'b0, UART0_Intr, 1'b0, 1'b0}), // input   [3:0]
    .FB_Int_Clr                (  8'h0                       ), // input   [7:0]
    .FB_Start                  (                             ), // output
    .FB_Busy                   (  1'b0                       ), // input

    // FB Clocks
    .Clk_C16                  ( Sys_Clk0                    ), // output
    .Clk_C16_Rst              ( Sys_Clk0_Rst                ), // output
    .Clk_C21                  ( Sys_Clk1                    ), // output
    .Clk_C21_Rst              ( Sys_Clk1_Rst                ), // output

    // Packet FIFO
    .Sys_PKfb_Clk              (  1'b0                       ), // input
    .Sys_PKfb_Rst              (                             ), // output
    .FB_PKfbData               ( 32'h0                       ), // input  [31:0]
    .FB_PKfbPush               (  4'h0                       ), // input   [3:0]
    .FB_PKfbSOF                (  1'b0                       ), // input
    .FB_PKfbEOF                (  1'b0                       ), // input
    .FB_PKfbOverflow           (                             ), // output

    // Sensor Interface
    .Sensor_Int                (                             ), // output  [7:0]
    .TimeStamp                 (                             ), // output [23:0]

    // SPI Master APB Bus
    .Sys_Pclk                  (                             ), // output
    .Sys_Pclk_Rst              (                             ), // output      <-- Fixed to add "_Rst"
    .Sys_PSel                  (  1'b0                       ), // input
    .SPIm_Paddr                ( 16'h0                       ), // input  [15:0]
    .SPIm_PEnable              (  1'b0                       ), // input
    .SPIm_PWrite               (  1'b0                       ), // input
    .SPIm_PWdata               ( 32'h0                       ), // input  [31:0]
    .SPIm_Prdata               (                             ), // output [31:0]
    .SPIm_PReady               (                             ), // output
    .SPIm_PSlvErr              (                             ), // output

    // Misc
    .Device_ID                 ( Device_ID[15:0]             ), // input  [15:0]

    // FBIO Signals
    .FBIO_In                   (                             ), // output [13:0] <-- Do Not make any connections; Use Constraint manager in SpDE to sFBIO
    .FBIO_In_En                (                             ), // input  [13:0] <-- Do Not make any connections; Use Constraint manager in SpDE to sFBIO
    .FBIO_Out                  (                             ), // input  [13:0] <-- Do Not make any connections; Use Constraint manager in SpDE to sFBIO
    .FBIO_Out_En               (                             ), // input  [13:0] <-- Do Not make any connections; Use Constraint manager in SpDE to sFBIO

    // ???
    .SFBIO                     (                             ), // inout  [13:0]
    .Device_ID_6S              ( 1'b0                        ), // input
    .Device_ID_4S              ( 1'b0                        ), // input
    .SPIm_PWdata_26S           ( 1'b0                        ), // input
    .SPIm_PWdata_24S           ( 1'b0                        ), // input
    .SPIm_PWdata_14S           ( 1'b0                        ), // input
    .SPIm_PWdata_11S           ( 1'b0                        ), // input
    .SPIm_PWdata_0S            ( 1'b0                        ), // input
    .SPIm_Paddr_8S             ( 1'b0                        ), // input
    .SPIm_Paddr_6S             ( 1'b0                        ), // input
    .FB_PKfbPush_1S            ( 1'b0                        ), // input
    .FB_PKfbData_31S           ( 1'b0                        ), // input
    .FB_PKfbData_21S           ( 1'b0                        ), // input
    .FB_PKfbData_19S           ( 1'b0                        ), // input
    .FB_PKfbData_9S            ( 1'b0                        ), // input
    .FB_PKfbData_6S            ( 1'b0                        ), // input
    .Sys_PKfb_ClkS             ( 1'b0                        ), // input
    .FB_BusyS                  ( 1'b0                        ), // input
    .WB_CLKS                   ( 1'b0                        )  // input
                                                             );

//pragma attribute u_qlal4s3b_cell_macro         preserve_cell true
//pragma attribute u_AL4S3B_FPGA_IP            preserve_cell true

reg dspi_clk;
reg dspi_co;
reg dspi_ci;
reg dspi_cs;

// always @(posedge Sys_Clk1) 
// begin
//     dspi_clk <= ~dspi_clk;
// end

// always @(posedge dspi_clk)
// begin
//     dspi_co <= ~dspi_co;
// end

// always @(posedge dspi_clk)
// begin
//     dspi_ci <= ~dspi_ci;
// end

// always @(posedge spi_drdy)
// begin
//     dspi_cs <= ~dspi_cs;
// end

// assign spi_cs = dspi_cs;

// always @(posedge spi_ci)
// begin
//     dspi_co <= ~dspi_co;
// end

// assign spi_drdy = dspi_cs;

// assign spi_clk = dspi_clk;
// assign spi_co = dspi_co;
// assign spi_ci = dspi_ci;


endmodule