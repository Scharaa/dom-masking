LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE work.masked_aes_pkg.ALL;

ENTITY tb_aes_top IS
END tb_aes_top;

ARCHITECTURE Behavior OF tb_aes_top IS

-- constant n --



    --test vectors--
  SIGNAL TV_PT     : t_shared_gf8(2 DOWNTO 0);
  SIGNAL TV_CT     : t_shared_gf8(2 DOWNTO 0);
  SIGNAL TV_KY     : t_shared_gf8(2 DOWNTO 0);
    --inputs--

    SIGNAL ClkxCI : STD_LOGIC := '0';
    SIGNAL RstxBI : STD_LOGIC := '0';
    SIGNAL PTxDI  : t_shared_gf8(2 DOWNTO 0):= (others => "00000000");
    SIGNAL KxDI  : t_shared_gf8(2 DOWNTO 0):= (others => "00000000");
    SIGNAL Zmul1xDI : t_shared_gf4(2 downto 0);  -- for y1 * y0
    SIGNAL Zmul2xDI : t_shared_gf4(2 downto 0);  -- for O * y1
    SIGNAL Zmul3xDI : t_shared_gf4(2 downto 0):= (others => "0000");  -- for O * y0
    SIGNAL Zinv1xDI : t_shared_gf2(2 downto 0):= (others => "00");  -- for inverter
    SIGNAL Zinv2xDI : t_shared_gf2(2 downto 0):= (others => "00");  -- ...
    SIGNAL Zinv3xDI : t_shared_gf2(2 downto 0):= (others => "00");  -- ...
       -- Blinding values for Y0*Y1 and Inverter
    SIGNAL Bmul1xDI :  t_shared_gf4( 2 downto 0):= (others => "0000");              -- for y1 * y0
    SIGNAL Binv1xDI :  t_shared_gf2(2 downto 0);              -- for inverter
    SIGNAL Binv2xDI :  t_shared_gf2(2 downto 0):= (others => "00");              -- ...
    SIGNAL Binv3xDI :  t_shared_gf2(2 downto 0):= (others => "00");              -- ...
       -- Control signals
    SIGNAL StartxSI :   std_logic := '1'; -- Start the core
       --- Output:
       SIGNAL DonexSO  :  std_logic ; -- ciphertext is ready
       -- Cyphertext C
       SIGNAL CxDO     : t_shared_gf8(2 downto 0);
     
          -- CLOCK PERIOD DEFINITIONS ---------------------------------------------------
   CONSTANT CLK_PERIOD : TIME := 10 NS;

   begin

    UUT: entity work.aes_top 

    port map (
        PTxDI => PTxDI,
        KxDI => KxDI,
        ClkxCI => ClkxCI,
        RstxBI => RstxBI,
        
       Zmul1xDI =>Zmul1xDI,
       Zmul2xDI =>Zmul2xDI,
      Zmul3xDI =>Zmul3xDI,
      Zinv1xDI =>Zinv1xDI,
      Zinv2xDI  =>Zinv2xDI,
      Zinv3xDI  =>Zinv3xDI,
      Bmul1xDI => Bmul1xDI,
      Binv1xDI => Binv1xDI,
      Binv2xDI => Binv2xDI,
      Binv3xDI => Binv3xDI,
     
    StartxSI => StartxSI,
    DonexSO => DonexSO,
    
    CxDO => CxDO
        
    );

    CLK_PROCESS : PROCESS
	BEGIN
  	ClkxCI <= '0'; WAIT FOR CLK_PERIOD/2;
    ClkxCI <= '1'; WAIT FOR CLK_PERIOD/2;

   END PROCESS;

 	-------------------------------------------------------------------------------
 
   -- STIMULUS PROCESS -----------------------------------------------------------
   STIM_PROCESS : PROCESS
   BEGIN			
		
	----------------------------------------------------------------------------
--     
  TV_PT <= ("00000000", "00010000", "00100000");
  TV_CT <= ("00000000", "00010000", "00100000");
  TV_KY <= ("00000000", "00000001", "00000010");
--       ----------------------------------------------------------------------------
       
       WAIT FOR CLK_PERIOD;    
		----------------------------------------------------------------------------
		RstxBI <= '1';			
			WAIT FOR CLK_PERIOD;	
            RstxBI <= '0';    
		----------------------------------------------------------------------------
		----------------------------------------------------------------------------
                StartxSI <= '1';                
                    FOR I IN 0 TO 15 LOOP    
                        WAIT FOR CLK_PERIOD;    
                        REPORT "Salaaaaaam";
                        PTxDI <= TV_PT;
                        KxDI   <= TV_KY;
                        TV_CT <= CxDO;

                    END LOOP;
                StartxSI <= '0';
             
                
--        ----------------------------------------------------------------------------
--        WAIT UNTIL DonexSO = '1';
       
         WAIT FOR CLK_PERIOD/2;
                                
--                --------------------------------------------------------------------------
--            FOR I IN 0 TO 15 LOOP	
                
--                  --test
--                           WAIT FOR CLK_PERIOD;
--                           ---
--                   CxDO <= TV_CT;
--                   REPORT "TESTBENCH FAILED";
----                    SEVERITY FAILURE;
--                    -- WAIT FOR CLK_PERIOD;
--                        END LOOP;
		WAIT;
   END PROCESS;
	-------------------------------------------------------------------------------
	
END;  