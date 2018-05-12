----------------------------------------------------------------------------
-- $Id: blkmemdp_v3_2_comp.vhd,v 1.1 2010-07-10 21:42:32 mmartinez Exp $
---------------------------------------------------------------------------
-- Dual Port Block Memory  - Component declaration file
---------------------------------------------------------------------------
--                                                                       --
-- This File is owned and controlled by Xilinx and must be used solely   --
-- for design, simulation, implementation and creation of design files   --
-- limited to Xilinx devices or technologies. Use with non-Xilinx        --
-- devices or technologies is expressly prohibited and immediately       --
-- terminates your license.                                              --
--                                                                       --
-- Xilinx products are not intended for use in life support              --
-- appliances, devices, or systems. Use in such applications is          --
-- expressly prohibited.                                                 --
--                                                                       --
--
--        ****************************
--        ** Copyright Xilinx, Inc. **
--        ** All rights reserved.   **
--        ****************************
--
---------------------------------------------------------------------------
-- Filename:    blkmemdp_v3_2_comp.vhd
--
-- Description: The component declaration file for the Dual Port Block
--              Memory behavior model
--
---------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

LIBRARY XilinxCoreLib;
USE XilinxCoreLib.blkmemdp_pkg_v3_2.ALL;


PACKAGE blkmemdp_v3_2_comp IS

----------------------------------------------------------------------------
-- COMPONENT DECLARATION
----------------------------------------------------------------------------
COMPONENT blkmemdp_v3_2
	GENERIC( 
                 c_addra_width	      : INTEGER := DEFAULT_ADDA_WIDTH;
                 c_addrb_width	      : INTEGER := DEFAULT_ADDB_WIDTH;
                 c_limit_data_pitch   : INTEGER := DEFAULT_LIMIT_PITCH;
                 c_default_data       : STRING  := DEFAULT_DEFAULT_DATA;
                 c_depth_a	      : INTEGER := DEFAULT_DEPTHA;
                 c_depth_b	      : INTEGER := DEFAULT_DEPTHB;
                 c_enable_rlocs	      : INTEGER := DEFAULT_EN_RLOCS;
                 c_has_limit_data_pitch: INTEGER := DEFAULT_HAS_LIMIT_PITCH;
                 c_has_default_data   : INTEGER := DEFAULT_HAS_DEFAULT;
                 c_has_dina	      : INTEGER := DEFAULT_HAS_DINA;
                 c_has_dinb	      : INTEGER := DEFAULT_HAS_DINB;
                 c_has_douta          : INTEGER := DEFAULT_HAS_DOUTA;
                 c_has_doutb          : INTEGER := DEFAULT_HAS_DOUTB;
                 c_has_ena	      : INTEGER := DEFAULT_HAS_ENA;
                 c_has_enb	      : INTEGER := DEFAULT_HAS_ENB;
                 c_has_nda	      : INTEGER := DEFAULT_HAS_NDA;
                 c_has_ndb	      : INTEGER := DEFAULT_HAS_NDB;
                 c_has_rdya	      : INTEGER := DEFAULT_HAS_RDYA;
                 c_has_rdyb	      : INTEGER := DEFAULT_HAS_RDYB;
                 c_has_rfda	      : INTEGER := DEFAULT_HAS_RFDA;
                 c_has_rfdb	      : INTEGER := DEFAULT_HAS_RFDB;
                 c_has_sinita	      : INTEGER := DEFAULT_HAS_SINITA;
                 c_has_sinitb	      : INTEGER := DEFAULT_HAS_SINITB;
                 c_has_wea	      : INTEGER := DEFAULT_HAS_WEA;
                 c_has_web	      : INTEGER := DEFAULT_HAS_WEB;
                 c_mem_init_file      : STRING  := DEFAULT_MEM_INIT;
                 c_pipe_stages_a      : INTEGER := DEFAULT_PIPE_STAGESA;
                 c_pipe_stages_b      : INTEGER := DEFAULT_PIPE_STAGESB;
                 c_reg_inputsa        : INTEGER := DEFAULT_REG_INPUTSA;
                 c_reg_inputsb        : INTEGER := DEFAULT_REG_INPUTSB;
                 c_sinita_value	      : STRING  := DEFAULT_SINIT_VALUEA;
                 c_sinitb_value	      : STRING  := DEFAULT_SINIT_VALUEB;
                 c_width_a	      : INTEGER := DEFAULT_WIDTHA;
                 c_width_b	      : INTEGER := DEFAULT_WIDTHB;
                 c_write_modea	      : INTEGER := DEFAULT_WRITE_MODEA;
                 c_write_modeb	      : INTEGER := DEFAULT_WRITE_MODEB
                 

               );

  PORT  (DINA  : in STD_LOGIC_VECTOR (c_width_a-1 downto 0):= (OTHERS => '0');
        DINB   : in STD_LOGIC_VECTOR (c_width_b-1 downto 0):= (OTHERS => '0');
        ENA    : in STD_LOGIC:= '1';
        ENB    : in STD_LOGIC:= '1';
        WEA    : in STD_LOGIC:= '0';
        WEB    : in STD_LOGIC:= '0';
        SINITA : in STD_LOGIC:= '0';
        SINITB : in STD_LOGIC:= '0';
        NDA    : in STD_LOGIC:= '0';
        NDB    : in STD_LOGIC:= '0';
        CLKA   : in STD_LOGIC;
        CLKB   : in STD_LOGIC;
        ADDRA  : in STD_LOGIC_VECTOR (c_addra_width-1 downto 0);
        ADDRB  : in STD_LOGIC_VECTOR (c_addrb_width-1 downto 0);
        RDYA   : out STD_LOGIC;
        RDYB   : out STD_LOGIC;
        RFDA   : out STD_LOGIC;
        RFDB   : out STD_LOGIC;
        DOUTA  : out STD_LOGIC_VECTOR (c_width_a-1 downto 0);
        DOUTB  : out STD_LOGIC_VECTOR (c_width_b-1 downto 0)
       ); 

END COMPONENT;

------------------------------------------------------------------------------
--  Definition of Generics: 
--      c_addra_width         -- controls the width of port A add pins
--      c_addrb_width         -- controls the width of port B add pins
--      c_bit_pitch           -- indicates the max bit pitch for the core 
--      c_default_data        -- indicates string of hex characters
--                               used to initialize the memory
--      c_depth_a             -- controls the depth of port A memory
--      c_depth_b             -- controls the depth of port B memory
--      c_enable_rlocs        -- core includes placement constraints
--      c_family              -- designates the target family device
--      c_has_bit_pitch       -- indicates if the core is built using a
--                               specified bit pitch
--      c_has_default_data    -- indicates the contents of the memory
--                               is initialized to C_DEFAULT_DATA
--      c_has_dina            -- indicates that the port A of the
--                               memory module has data input pins
--      c_has_dinb            -- indicates that the port B of the
--                               memory module has data input pins
--      c_has_douta           -- indicates that the port A has a
--                               registered output port
--      c_has_doutb           -- indicates that the port B has a
--                               registered output port
--      c_has_ena             -- indicates the port A has a ENA pin
--      c_has_enb             -- indicates the port B has a ENB pin
--      c_has_nda             -- port A has a new data pin (NDA)
--      c_has_ndb             -- port B has a new data pin (NDB)
--      c_has_rdya            -- port A has a result ready pin (RDYA)
--      c_has_rdyb            -- port B has a result ready pin (RDYB)
--      c_has_rfda            -- port A has a ready for data pin 
--      c_has_rfdb            -- port B has a ready for data pin
--      c_has_sinita          -- indicates the port A has a SINITA pin
--      c_has_sinitb          -- indicates the port B has a SINITB pin
--      c_has_wea             -- indicates the port A has a WEA pin
--      c_has_web             -- indicates the port B has a WEB pin
--      c_mem_configuration   -- controls the configuration of the
--                               memory being implemented
--      c_mem_init_file       -- controls which .COE file used to
--                               initialize the memory
--      c_xmem_init_array     -- array for memory initialization 
--      c_pipe_stages_a       -- indicates the number of pipe stages
--                               needed in port A
--      c_pipe_stages_b       -- indicates the number of pipe stages
--                               needed in port B
--      c_reg_ena             -- register ena
--      c_reg_enb             -- register enb
--      c_reg_inputa          -- regiester all A port inputs except ena
--      c_reg_inputb          -- regiester all B port inputs except enb
--      c_sinita_value        -- indicates string of hex characters
--                               used to initialize the output
--                               register that feeds DOUTA
--      c_sinitb_value        -- indicates string of hex characters
--                               used to initialize the output
--                               register that feeds DOUTB
--      c_width_a             -- controls the width of port A I/O data
--      c_width_b             -- controls the width of port B I/O data
--      c_write_mode          -- controls which write modes shall
--                               be implemented (c_write_first, 
--                               c_read_first, c_no_change)
--  Definition of Ports: 
--      addra                 -- port A address 
--      addrb                 -- port B address 
--      clka                  -- port A clock pin
--      clkb                  -- port B clock pin
--      dina                  -- port A data input 
--      dinb                  -- port B data input 
--      douta                 -- port A registered output
--      doutb                 -- port B registered output
--      ena                   -- port A enable pin
--      enb                   -- port B enable pin
--      nda                   -- port A new data pin
--      ndb                   -- port B new data pin
--      rdya                  -- port A result ready pin
--      rdyb                  -- port B result ready pin
--      rfda                  -- port A ready for data pin
--      rfdb                  -- port B ready for data pin
--      sinita                -- port A syncrhonous initialization pin
--      sinitb                -- port B syncrhonous initialization pin
--      wea                   -- port A write enable pin
--      web                   -- port B write enable pin
------------------------------------------------------------------------------
        
END blkmemdp_v3_2_comp;
