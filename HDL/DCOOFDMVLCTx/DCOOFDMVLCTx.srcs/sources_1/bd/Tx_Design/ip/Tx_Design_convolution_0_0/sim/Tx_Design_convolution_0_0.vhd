-- (c) Copyright 1995-2018 Xilinx, Inc. All rights reserved.
-- 
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
-- 
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
-- 
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
-- 
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
-- 
-- DO NOT MODIFY THIS FILE.

-- IP VLNV: xilinx.com:ip:convolution:9.0
-- IP Revision: 10

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

LIBRARY convolution_v9_0_10;
USE convolution_v9_0_10.convolution_v9_0_10;

ENTITY Tx_Design_convolution_0_0 IS
  PORT (
    aclk : IN STD_LOGIC;
    aresetn : IN STD_LOGIC;
    s_axis_data_tdata : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    s_axis_data_tvalid : IN STD_LOGIC;
    s_axis_data_tready : OUT STD_LOGIC;
    m_axis_data_tdata : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    m_axis_data_tvalid : OUT STD_LOGIC;
    m_axis_data_tready : IN STD_LOGIC
  );
END Tx_Design_convolution_0_0;

ARCHITECTURE Tx_Design_convolution_0_0_arch OF Tx_Design_convolution_0_0 IS
  ATTRIBUTE DowngradeIPIdentifiedWarnings : STRING;
  ATTRIBUTE DowngradeIPIdentifiedWarnings OF Tx_Design_convolution_0_0_arch: ARCHITECTURE IS "yes";
  COMPONENT convolution_v9_0_10 IS
    GENERIC (
      C_HAS_M_AXIS_DATA_TREADY : INTEGER;
      C_HAS_ACLKEN : INTEGER;
      C_OUTPUT_RATE : INTEGER;
      C_CONSTRAINT_LENGTH : INTEGER;
      C_PUNCTURED : INTEGER;
      C_DUAL_CHANNEL : INTEGER;
      C_PUNC_INPUT_RATE : INTEGER;
      C_PUNC_OUTPUT_RATE : INTEGER;
      C_CONVOLUTION_CODE0 : INTEGER;
      C_CONVOLUTION_CODE1 : INTEGER;
      C_CONVOLUTION_CODE2 : INTEGER;
      C_CONVOLUTION_CODE3 : INTEGER;
      C_CONVOLUTION_CODE4 : INTEGER;
      C_CONVOLUTION_CODE5 : INTEGER;
      C_CONVOLUTION_CODE6 : INTEGER;
      C_PUNC_CODE0 : INTEGER;
      C_PUNC_CODE1 : INTEGER;
      C_XDEVICEFAMILY : STRING
    );
    PORT (
      aclk : IN STD_LOGIC;
      aresetn : IN STD_LOGIC;
      aclken : IN STD_LOGIC;
      s_axis_data_tdata : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      s_axis_data_tvalid : IN STD_LOGIC;
      s_axis_data_tlast : IN STD_LOGIC;
      s_axis_data_tready : OUT STD_LOGIC;
      m_axis_data_tdata : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      m_axis_data_tvalid : OUT STD_LOGIC;
      m_axis_data_tlast : OUT STD_LOGIC;
      m_axis_data_tready : IN STD_LOGIC;
      event_s_data_tlast_missing : OUT STD_LOGIC;
      event_s_data_tlast_unexpected : OUT STD_LOGIC
    );
  END COMPONENT convolution_v9_0_10;
  ATTRIBUTE X_INTERFACE_INFO : STRING;
  ATTRIBUTE X_INTERFACE_INFO OF aclk: SIGNAL IS "xilinx.com:signal:clock:1.0 aclk_intf CLK";
  ATTRIBUTE X_INTERFACE_INFO OF aresetn: SIGNAL IS "xilinx.com:signal:reset:1.0 aresetn_intf RST";
  ATTRIBUTE X_INTERFACE_INFO OF s_axis_data_tdata: SIGNAL IS "xilinx.com:interface:axis:1.0 S_AXIS_DATA TDATA";
  ATTRIBUTE X_INTERFACE_INFO OF s_axis_data_tvalid: SIGNAL IS "xilinx.com:interface:axis:1.0 S_AXIS_DATA TVALID";
  ATTRIBUTE X_INTERFACE_INFO OF s_axis_data_tready: SIGNAL IS "xilinx.com:interface:axis:1.0 S_AXIS_DATA TREADY";
  ATTRIBUTE X_INTERFACE_INFO OF m_axis_data_tdata: SIGNAL IS "xilinx.com:interface:axis:1.0 M_AXIS_DATA TDATA";
  ATTRIBUTE X_INTERFACE_INFO OF m_axis_data_tvalid: SIGNAL IS "xilinx.com:interface:axis:1.0 M_AXIS_DATA TVALID";
  ATTRIBUTE X_INTERFACE_INFO OF m_axis_data_tready: SIGNAL IS "xilinx.com:interface:axis:1.0 M_AXIS_DATA TREADY";
BEGIN
  U0 : convolution_v9_0_10
    GENERIC MAP (
      C_HAS_M_AXIS_DATA_TREADY => 1,
      C_HAS_ACLKEN => 0,
      C_OUTPUT_RATE => 2,
      C_CONSTRAINT_LENGTH => 7,
      C_PUNCTURED => 0,
      C_DUAL_CHANNEL => 0,
      C_PUNC_INPUT_RATE => 1,
      C_PUNC_OUTPUT_RATE => 2,
      C_CONVOLUTION_CODE0 => 91,
      C_CONVOLUTION_CODE1 => 121,
      C_CONVOLUTION_CODE2 => 3,
      C_CONVOLUTION_CODE3 => 3,
      C_CONVOLUTION_CODE4 => 3,
      C_CONVOLUTION_CODE5 => 3,
      C_CONVOLUTION_CODE6 => 3,
      C_PUNC_CODE0 => 0,
      C_PUNC_CODE1 => 0,
      C_XDEVICEFAMILY => "zynq"
    )
    PORT MAP (
      aclk => aclk,
      aresetn => aresetn,
      aclken => '1',
      s_axis_data_tdata => s_axis_data_tdata,
      s_axis_data_tvalid => s_axis_data_tvalid,
      s_axis_data_tlast => '0',
      s_axis_data_tready => s_axis_data_tready,
      m_axis_data_tdata => m_axis_data_tdata,
      m_axis_data_tvalid => m_axis_data_tvalid,
      m_axis_data_tready => m_axis_data_tready
    );
END Tx_Design_convolution_0_0_arch;
