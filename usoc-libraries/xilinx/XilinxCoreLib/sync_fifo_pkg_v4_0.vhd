------------------------------------------------------------------------------
-- $RCSfile: sync_fifo_pkg_v4_0.vhd,v $ $Revision: 1.1 $ $Date: 2010-07-10 21:43:23 $
-------------------------------------------------------------------------------
--
-- SYNC_FIFO_V4_0 - VHDL Behavioral Model
--
-------------------------------------------------------------------------------
--


--  Copyright(C) 2003 by Xilinx, Inc. All rights reserved.
--  This text/file contains proprietary, confidential
--  information of Xilinx, Inc., is distributed under license
--  from Xilinx, Inc., and may be used, copied and/or
--  disclosed only pursuant to the terms of a valid license
--  agreement with Xilinx, Inc.  Xilinx hereby grants you
--  a license to use this text/file solely for design, simulation,
--  implementation and creation of design files limited
--  to Xilinx devices or technologies. Use with non-Xilinx
--  devices or technologies is expressly prohibited and
--  immediately terminates your license unless covered by
--  a separate agreement.
--
--  Xilinx is providing this design, code, or information
--  "as is" solely for use in developing programs and
--  solutions for Xilinx devices.  By providing this design,
--  code, or information as one possible implementation of
--  this feature, application or standard, Xilinx is making no
--  representation that this implementation is free from any
--  claims of infringement.  You are responsible for
--  obtaining any rights you may require for your implementation.
--  Xilinx expressly disclaims any warranty whatsoever with
--  respect to the adequacy of the implementation, including
--  but not limited to any warranties or representations that this
--  implementation is free from claims of infringement, implied
--  warranties of merchantability or fitness for a particular
--  purpose.
--
--  Xilinx products are not intended for use in life support
--  appliances, devices, or systems. Use in such applications are
--  expressly prohibited.
--
--  This copyright and support notice must be retained as part
--  of this text at all times. (c) Copyright 1995-2003 Xilinx, Inc.
--  All rights reserved.

-------------------------------------------------------------------------------
-- 
-- Filename: sync_fifo_pkg_v4_0.vhd
--
-- Description: 
--  Contains functions used in other files. 
--
-------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

PACKAGE sync_fifo_pkg_v4_0 IS


FUNCTION  calc_read_depth (wr_depth: INTEGER; wr_width: INTEGER; rd_width: INTEGER) 
RETURN INTEGER;


END  sync_fifo_pkg_v4_0;

PACKAGE BODY sync_fifo_pkg_v4_0 IS


-- ---------------------------------------------------
-- FUNCTION : calc_read_depth                     --
-- ---------------------------------------------------
FUNCTION  calc_read_depth (wr_depth: INTEGER; wr_width: INTEGER; rd_width: INTEGER) 
 RETURN INTEGER IS
 VARIABLE read_depth : INTEGER := 256;		

 BEGIN
	read_depth := ((wr_depth+1)*(wr_width))/rd_width;
 RETURN read_depth;
 END calc_read_depth;



END sync_fifo_pkg_v4_0;

