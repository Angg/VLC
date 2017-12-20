-- (c) Copyright 1995-2017 Xilinx, Inc. All rights reserved.
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

-- IP VLNV: xilinx.com:ip:sid:8.0
-- IP Revision: 9

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

LIBRARY sid_v8_0_9;
USE sid_v8_0_9.sid_v8_0_9;

ENTITY Rx_Design_sid_0_0 IS
  PORT (
    aclk : IN STD_LOGIC;
    aresetn : IN STD_LOGIC;
    s_axis_data_tdata : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    s_axis_data_tvalid : IN STD_LOGIC;
    s_axis_data_tlast : IN STD_LOGIC;
    s_axis_data_tready : OUT STD_LOGIC;
    m_axis_data_tdata : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    m_axis_data_tvalid : OUT STD_LOGIC;
    m_axis_data_tlast : OUT STD_LOGIC;
    m_axis_data_tready : IN STD_LOGIC;
    event_tlast_unexpected : OUT STD_LOGIC;
    event_tlast_missing : OUT STD_LOGIC;
    event_halted : OUT STD_LOGIC
  );
END Rx_Design_sid_0_0;

ARCHITECTURE Rx_Design_sid_0_0_arch OF Rx_Design_sid_0_0 IS
  ATTRIBUTE DowngradeIPIdentifiedWarnings : STRING;
  ATTRIBUTE DowngradeIPIdentifiedWarnings OF Rx_Design_sid_0_0_arch: ARCHITECTURE IS "yes";
  COMPONENT sid_v8_0_9 IS
    GENERIC (
      c_xdevicefamily : STRING;
      c_family : STRING;
      c_architecture : INTEGER;
      c_mem_init_prefix : STRING;
      c_elaboration_dir : STRING;
      c_type : INTEGER;
      c_mode : INTEGER;
      c_symbol_width : INTEGER;
      c_row_type : INTEGER;
      c_row_constant : INTEGER;
      c_has_row : INTEGER;
      c_has_row_valid : INTEGER;
      c_min_num_rows : INTEGER;
      c_row_width : INTEGER;
      c_num_selectable_rows : INTEGER;
      c_row_select_file : STRING;
      c_has_row_sel : INTEGER;
      c_has_row_sel_valid : INTEGER;
      c_use_row_permute_file : INTEGER;
      c_row_permute_file : STRING;
      c_col_type : INTEGER;
      c_col_constant : INTEGER;
      c_has_col : INTEGER;
      c_has_col_valid : INTEGER;
      c_min_num_cols : INTEGER;
      c_col_width : INTEGER;
      c_num_selectable_cols : INTEGER;
      c_col_select_file : STRING;
      c_has_col_sel : INTEGER;
      c_has_col_sel_valid : INTEGER;
      c_use_col_permute_file : INTEGER;
      c_col_permute_file : STRING;
      c_block_size_type : INTEGER;
      c_block_size_constant : INTEGER;
      c_has_block_size : INTEGER;
      c_block_size_width : INTEGER;
      c_has_block_size_valid : INTEGER;
      c_num_branches : INTEGER;
      c_branch_length_type : INTEGER;
      c_branch_length_constant : INTEGER;
      c_branch_length_file : STRING;
      c_num_configurations : INTEGER;
      c_external_ram : INTEGER;
      c_ext_mem_latency : INTEGER;
      c_ext_addr_width : INTEGER;
      c_memstyle : INTEGER;
      c_pipe_level : INTEGER;
      c_throughput_mode : INTEGER;
      c_has_aclken : INTEGER;
      c_has_aresetn : INTEGER;
      c_has_rdy : INTEGER;
      c_has_block_start : INTEGER;
      c_has_block_end : INTEGER;
      c_has_fdo : INTEGER;
      c_s_axis_ctrl_tdata_width : INTEGER;
      c_s_axis_data_tdata_width : INTEGER;
      c_m_axis_data_tdata_width : INTEGER;
      c_m_axis_data_tuser_width : INTEGER;
      c_has_dout_tready : INTEGER
    );
    PORT (
      aclk : IN STD_LOGIC;
      aclken : IN STD_LOGIC;
      aresetn : IN STD_LOGIC;
      s_axis_ctrl_tdata : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
      s_axis_ctrl_tvalid : IN STD_LOGIC;
      s_axis_ctrl_tready : OUT STD_LOGIC;
      s_axis_data_tdata : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      s_axis_data_tvalid : IN STD_LOGIC;
      s_axis_data_tlast : IN STD_LOGIC;
      s_axis_data_tready : OUT STD_LOGIC;
      m_axis_data_tdata : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      m_axis_data_tuser : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      m_axis_data_tvalid : OUT STD_LOGIC;
      m_axis_data_tlast : OUT STD_LOGIC;
      m_axis_data_tready : IN STD_LOGIC;
      rd_data : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
      rd_en : OUT STD_LOGIC;
      wr_en : OUT STD_LOGIC;
      rd_addr : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      wr_addr : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      wr_data : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      event_tlast_unexpected : OUT STD_LOGIC;
      event_tlast_missing : OUT STD_LOGIC;
      event_halted : OUT STD_LOGIC;
      event_row_valid : OUT STD_LOGIC;
      event_col_valid : OUT STD_LOGIC;
      event_row_sel_valid : OUT STD_LOGIC;
      event_col_sel_valid : OUT STD_LOGIC;
      event_block_size_valid : OUT STD_LOGIC
    );
  END COMPONENT sid_v8_0_9;
  ATTRIBUTE X_INTERFACE_INFO : STRING;
  ATTRIBUTE X_INTERFACE_INFO OF aclk: SIGNAL IS "xilinx.com:signal:clock:1.0 aclk_intf CLK";
  ATTRIBUTE X_INTERFACE_INFO OF aresetn: SIGNAL IS "xilinx.com:signal:reset:1.0 aresetn_intf RST";
  ATTRIBUTE X_INTERFACE_INFO OF s_axis_data_tdata: SIGNAL IS "xilinx.com:interface:axis:1.0 S_AXIS_DATA TDATA";
  ATTRIBUTE X_INTERFACE_INFO OF s_axis_data_tvalid: SIGNAL IS "xilinx.com:interface:axis:1.0 S_AXIS_DATA TVALID";
  ATTRIBUTE X_INTERFACE_INFO OF s_axis_data_tlast: SIGNAL IS "xilinx.com:interface:axis:1.0 S_AXIS_DATA TLAST";
  ATTRIBUTE X_INTERFACE_INFO OF s_axis_data_tready: SIGNAL IS "xilinx.com:interface:axis:1.0 S_AXIS_DATA TREADY";
  ATTRIBUTE X_INTERFACE_INFO OF m_axis_data_tdata: SIGNAL IS "xilinx.com:interface:axis:1.0 M_AXIS_DATA TDATA";
  ATTRIBUTE X_INTERFACE_INFO OF m_axis_data_tvalid: SIGNAL IS "xilinx.com:interface:axis:1.0 M_AXIS_DATA TVALID";
  ATTRIBUTE X_INTERFACE_INFO OF m_axis_data_tlast: SIGNAL IS "xilinx.com:interface:axis:1.0 M_AXIS_DATA TLAST";
  ATTRIBUTE X_INTERFACE_INFO OF m_axis_data_tready: SIGNAL IS "xilinx.com:interface:axis:1.0 M_AXIS_DATA TREADY";
  ATTRIBUTE X_INTERFACE_INFO OF event_tlast_unexpected: SIGNAL IS "xilinx.com:signal:interrupt:1.0 event_tlast_unexpected_intf INTERRUPT";
  ATTRIBUTE X_INTERFACE_INFO OF event_tlast_missing: SIGNAL IS "xilinx.com:signal:interrupt:1.0 event_tlast_missing_intf INTERRUPT";
  ATTRIBUTE X_INTERFACE_INFO OF event_halted: SIGNAL IS "xilinx.com:signal:interrupt:1.0 event_halted_intf INTERRUPT";
BEGIN
  U0 : sid_v8_0_9
    GENERIC MAP (
      c_xdevicefamily => "zynq",
      c_family => "zynq",
      c_architecture => 0,
      c_mem_init_prefix => "Rx_Design_sid_0_0",
      c_elaboration_dir => "./",
      c_type => 0,
      c_mode => 1,
      c_symbol_width => 2,
      c_row_type => 0,
      c_row_constant => 28,
      c_has_row => 0,
      c_has_row_valid => 0,
      c_min_num_rows => 15,
      c_row_width => 4,
      c_num_selectable_rows => 4,
      c_row_select_file => "Rx_Design_sid_0_0_RS.mif",
      c_has_row_sel => 0,
      c_has_row_sel_valid => 0,
      c_use_row_permute_file => 0,
      c_row_permute_file => "Rx_Design_sid_0_0_RP.mif",
      c_col_type => 0,
      c_col_constant => 8,
      c_has_col => 0,
      c_has_col_valid => 0,
      c_min_num_cols => 15,
      c_col_width => 4,
      c_num_selectable_cols => 4,
      c_col_select_file => "Rx_Design_sid_0_0_CS.mif",
      c_has_col_sel => 0,
      c_has_col_sel_valid => 0,
      c_use_col_permute_file => 0,
      c_col_permute_file => "Rx_Design_sid_0_0_CP.mif",
      c_block_size_type => 0,
      c_block_size_constant => 224,
      c_has_block_size => 0,
      c_block_size_width => 8,
      c_has_block_size_valid => 0,
      c_num_branches => 16,
      c_branch_length_type => 0,
      c_branch_length_constant => 16,
      c_branch_length_file => "Rx_Design_sid_0_0.mif",
      c_num_configurations => 1,
      c_external_ram => 0,
      c_ext_mem_latency => 0,
      c_ext_addr_width => 8,
      c_memstyle => 2,
      c_pipe_level => 2,
      c_throughput_mode => 0,
      c_has_aclken => 0,
      c_has_aresetn => 1,
      c_has_rdy => 0,
      c_has_block_start => 0,
      c_has_block_end => 0,
      c_has_fdo => 0,
      c_s_axis_ctrl_tdata_width => 1,
      c_s_axis_data_tdata_width => 8,
      c_m_axis_data_tdata_width => 8,
      c_m_axis_data_tuser_width => 1,
      c_has_dout_tready => 1
    )
    PORT MAP (
      aclk => aclk,
      aclken => '1',
      aresetn => aresetn,
      s_axis_ctrl_tdata => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 1)),
      s_axis_ctrl_tvalid => '1',
      s_axis_data_tdata => s_axis_data_tdata,
      s_axis_data_tvalid => s_axis_data_tvalid,
      s_axis_data_tlast => s_axis_data_tlast,
      s_axis_data_tready => s_axis_data_tready,
      m_axis_data_tdata => m_axis_data_tdata,
      m_axis_data_tvalid => m_axis_data_tvalid,
      m_axis_data_tlast => m_axis_data_tlast,
      m_axis_data_tready => m_axis_data_tready,
      rd_data => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 2)),
      event_tlast_unexpected => event_tlast_unexpected,
      event_tlast_missing => event_tlast_missing,
      event_halted => event_halted
    );
END Rx_Design_sid_0_0_arch;
