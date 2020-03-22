library ieee;
use ieee.std_logic_1164.all;

entity CONTROLADOR is
	port (CLR, CLKOSC, INV0, INV1, MODOLOAD, CLKUC, SLEEP: in std_logic;
		  FILA: out std_logic_vector (7 downto 0); COLUMNA: out std_logic_vector (8 downto 0);
		  CK0, CK1, HS, VS, INV, LATCH: out std_logic);
end entity;	

architecture STRUC of CONTROLADOR is
	signal CLKT: std_logic; -- CLKT es el clock general
	signal COL163, COLH0, CLRCOL0, CLRCOL1, COL0: std_logic;
	signal ROW240, ROWH0, ROWH1, ROWH2, CLRROW0, CLRROW1: std_logic;
	signal COLUMNAS, FILAS: std_logic_vector (7 downto 0);
	signal CK00: std_logic;
	signal ENABLE: std_logic;
--	signal CK00, CK10, HS0, VS0, INV2, LATCH0: std_logic; -- Para armar las salidas tri-state
	component CONTROL
		port (CLR, CLK, INV0, INV1, COLIN, ROWIN, MODE: in std_logic;
			  COLH, ROWH, CLRCOL, CLRROW, CK0, CK1, HS, VS, INV, LATCH: out std_logic);
	end component;
	component CONT_8_H
		port (CLR, CLK, ENA: in std_logic; SALIDAS: out std_logic_vector (7 downto 0));
	end component;
	component MUX_2
		port (IN0, IN1, SEL: in std_logic ; OUT1: out std_logic);
	end component;
	component BUFFER_OUT is
		port (IN0, ENA: in std_logic ; OUT0: out std_logic);
	end component;
begin
	CONTROL0: CONTROL port map (CLR, CLKT, INV0, INV1, COL163, ROW240, MODOLOAD, COLH0, ROWH0, CLRCOL0, CLRROW0, CK00, CK1, HS, VS, INV, LATCH);
	CONTADOR_COL: CONT_8_H port map (CLRCOL1, CLKT, COLH0, COLUMNAS);
	CONTADOR_ROW: CONT_8_H port map (CLRROW1, CLKT, ROWH2, FILAS);
	MUX_CLK: MUX_2 port map (CLKOSC, CLKUC, MODOLOAD, CLKT);
	MUX_ROWH: MUX_2 port map (ROWH0, ROWH1, MODOLOAD, ROWH2);
	MUX_COL0: MUX_2 port map (CK00, COLH0, MODOLOAD, COL0);

	BUF_CK0: BUFFER_OUT port map (CK00,ENABLE,CK0);
	
--	CK0 <= CK00;
	ENABLE <= not SLEEP;
	COL163 <= COLUMNAS(7) and COLUMNAS(5) and COLUMNAS(1) and COLUMNAS(0);
	ROW240 <= FILAS(7) and FILAS(6) and FILAS(5) and FILAS(4);
	CLRROW1 <= CLR or CLRROW0;
	ROWH1 <=  COL163 and COLH0;
	CLRCOL1 <= CLR or CLRCOL0;

--	COL0 <= (CK00 and MODOLOAD) or (COLH0 and (not MODOLOAD));
	COLUMNA <= COLUMNAS (7 downto 0) & COL0;
	FILA <= FILAS;
end architecture;

-------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity CONTROL is
	port (CLR, CLK, INV0, INV1, COLIN, ROWIN, MODE: in std_logic;
		  COLH, ROWH, CLRCOL, CLRROW, CK0, CK1, HS, VS, INV, LATCH: out std_logic);
end entity;

architecture BEH of CONTROL is

begin
	process (CLK,CLR)
		variable CUENTA: natural range 0 to 180;
	begin
		if CLR = '1' then
			CUENTA := 0;
			COLH <= '0';
			CLRCOL <= '0';
			ROWH <= '0';
			CLRROW <= '0';
			CK0 <= '0';
			CK1 <= '0';
			VS <= '0';
			HS <= '0';
			INV <= 'Z';   --Debería ser cero
			LATCH <= '0';
		elsif CLK = '1' and CLK'EVENT then
			if CUENTA = 0 then
				if MODE = '0' then
					CUENTA := CUENTA + 1;
				else
					CUENTA := 179;
				end if;
			elsif CUENTA = 1 then
				CLRCOL <= '1';
				CLRROW <= '1';
				CUENTA := CUENTA + 1;
			elsif CUENTA = 9 then
				CLRCOL <= '0';
				CLRROW <= '0';
				VS <= '1';
				CUENTA := CUENTA + 1;
			elsif CUENTA = 29 then
				CK1 <= '0';
				VS <= '0';
				CUENTA := CUENTA + 1;
			elsif CUENTA = 43 then
				INV <= INV0;
				CUENTA := CUENTA + 1;
			elsif CUENTA = 49 then
				HS <= '1';
				CUENTA := CUENTA + 1;
			elsif CUENTA = 55 then
				INV <= '0';       -- ¿podria ser alta impedancia o indefinido?
				CUENTA := CUENTA + 1;
			elsif CUENTA = 143 then
				INV <= INV1;
				CUENTA := CUENTA + 1;
			elsif CUENTA = 149 then
				HS <= '0';
				CUENTA := CUENTA + 1;
			elsif CUENTA = 155 then
				INV <= '0';       -- ¿podria ser alta impedancia o indefinido?
				CUENTA := CUENTA + 1;
			elsif CUENTA = 160 then
				if ROWIN = '1' then
					CUENTA := 1;
				else
					CUENTA := CUENTA + 1;
				end if;
			elsif CUENTA = 165 then
				CLRCOL <= '1';
				CUENTA := CUENTA + 1;
			elsif CUENTA = 166 then
				CLRCOL <= '0';
				CUENTA := CUENTA + 1;
			elsif CUENTA = 167 then
				LATCH <= '1';
				CUENTA := CUENTA + 1;
			elsif CUENTA = 168 then
				LATCH <= '0';
				CUENTA := CUENTA + 1;
			elsif CUENTA = 169 then
				CK0 <= '1';
				CK1 <= '0';
				CUENTA := CUENTA + 1;
			elsif CUENTA = 170 then
--				CK0 <= '1';   --- esta linea no es necesaria
--				CK1 <= '0';   --- esta linea no es necesaria
				LATCH <= '1';
				CUENTA := CUENTA + 1;
			elsif CUENTA = 171 then
--				CK0 <= '1';   --- esta linea no es necesaria
--				CK1 <= '0';   --- esta linea no es necesaria
				LATCH <= '0';
				COLH <= '1';
				if COLIN = '1' then
					CUENTA := 175;
				else
					CUENTA := CUENTA + 1;
				end if;
			elsif CUENTA = 172 then
				CK0 <= '0';
				CK1 <= '1';
--				LATCH <= '0';   --- esta linea no es necesaria
				COLH <= '0';
				CUENTA := CUENTA + 1;
			elsif CUENTA = 173 then
--				CK0 <= '0';   --- esta linea no es necesaria
--				CK1 <= '1';   --- esta linea no es necesaria
				LATCH <= '1';
				CUENTA := CUENTA + 1;
			elsif CUENTA = 174 then
--				CK0 <= '0';   --- esta linea no es necesaria
--				CK1 <= '1';   --- esta linea no es necesaria
				LATCH <= '0';
				CUENTA := 169;
			elsif CUENTA = 175 then
				CK0 <= '0';
				CK1 <= '1';
				COLH <= '0';
				CUENTA := CUENTA + 1;
			elsif CUENTA = 176 then
--				CK0 <= '0';
--				CK1 <= '1';
				ROWH <= '1';
				CUENTA := CUENTA + 1;
			elsif CUENTA = 177 then
--				CK0 <= '0';
--				CK1 <= '1';
				ROWH <= '0';
				CUENTA := 29;
			elsif CUENTA = 178 then
				if COLIN = '1' then
					CLRCOL <= '1';
				else
					CLRCOL <= '0';
				end if;
				COLH <= '0';
				CUENTA := CUENTA + 1;
			elsif CUENTA = 179 then
				CLRCOL <= '0';
				COLH <= '1';
				CUENTA := 178;
--			elsif CUENTA = 181 then ---- tendria que ser 180?? en realidad no hace falta esto
--				CLRCOL <= '0';
				----- este es el último estado, de aca salgo con reset ¿¿es necesario este estado?
				----- llego alguna vez aca?
			else
				CUENTA := CUENTA + 1;
			end if;
		end if;
	end process;
end architecture BEH;

-------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity CONT_8_H is
	port (CLR, CLK, ENA: in std_logic; SALIDAS: out std_logic_vector (7 downto 0));
end entity;

architecture STRUCTUR of CONT_8_H is
	signal DIN: std_logic_vector (7 downto 0);
	signal QOUT: std_logic_vector (7 downto 0);
	component FFDH
		port (D, CLK, RST, ENA: in std_logic; Q: out std_logic);
	end component;

begin
	CONT: for I in 0 to 7 generate
		FFD_I: FFDH port map (DIN(I), CLK, CLR, ENA, QOUT(I));
		SALIDAS(I) <= QOUT(I);
	end generate;
	DIN(0) <= not QOUT(0);
	DIN(1) <= QOUT(0) xor QOUT(1);
	DIN(2) <= (QOUT(0) and QOUT(1)) xor QOUT(2);
	DIN(3) <= (QOUT(0) and QOUT(1) and QOUT(2)) xor QOUT(3);
	DIN(4) <= (QOUT(0) and QOUT(1) and QOUT(2) and QOUT(3)) xor QOUT(4);
	DIN(5) <= (QOUT(0) and QOUT(1) and QOUT(2) and QOUT(3) and QOUT(4)) xor QOUT(5);
	DIN(6) <= (QOUT(0) and QOUT(1) and QOUT(2) and QOUT(3) and QOUT(4) and QOUT(5)) xor QOUT(6);
	DIN(7) <= (QOUT(0) and QOUT(1) and QOUT(2) and QOUT(3) and QOUT(4) and QOUT(5) and QOUT(6)) xor QOUT(7);
	SALIDAS <= QOUT;

end architecture STRUCTUR;

-------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity FFDH is
	port (D, CLK, RST, ENA: in std_logic; Q: out std_logic);
end entity FFDH;

-- con la siguiente arquitectura esta funcionando bien
--architecture BEHAVIOR of FFDH is
--
--begin
--	process (CLK, RST)
--	begin
--		if RST = '1' then
--			Q <= '0';
--		elsif CLK = '1' and CLK'EVENT and H = '1' then
--			Q <= D;
--		end if;
--	end process;
--end architecture BEHAVIOR;


architecture BEHAVIOR of FFDH is

begin
	process (CLK, RST, ENA)
	begin
		if RST = '1' then
			Q <= '0';
		elsif ENA = '1' then
			if CLK = '1' and CLK'EVENT then
				Q <= D;
			end if;
		end if;
	end process;
end architecture BEHAVIOR;

-------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity MUX_2 is
	port (IN0, IN1, SEL: in std_logic ; OUT1: out std_logic);
end entity MUX_2;

architecture STRUCTUR of MUX_2 is

begin
	OUT1 <= (IN0 and (not SEL)) or (IN1 and SEL);
end architecture STRUCTUR;

-------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity BUFFER_OUT is
	port (IN0, ENA: in std_logic ; OUT0: out std_logic);
end entity BUFFER_OUT;

architecture STRUCTUR of BUFFER_OUT is

begin
	with ENA select
		OUT0 <=	IN0 when '1',
				'Z' when others;
end architecture STRUCTUR;
