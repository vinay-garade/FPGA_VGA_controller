library IEEE;
library STD;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_logic_unsigned.all;
use ieee.std_logic_textio.all;

use std.textio.all;

Entity sync is
port(
clk: IN STD_LOGIC
--B:OUT STD_LOGIC_vector(3 downto 0)
);
END sync;

ARCHITECTURE MAIN of sync is
signal HSYNC, VSYNC :  STD_LOGIC;
signal R,G:  STD_LOGIC_vector(2 downto 0);
signal B:  STD_LOGIC_vector(1 downto 0);
SIGNAL HPOS : INTEGER RANGE 0 TO 799:=0;
SIGNAL VPOS : INTEGER RANGE 0 TO 525:=0;
SIGNAL earth_add, moon_add: std_logic_vector(9 downto 0) := "0000000000";
SIGNAL earth_out, moon_out: std_logic_vector(11 downto 0);
constant earth_x: INTEGER RANGE 0 TO 799:=384;
constant earth_y: INTEGER RANGE 0 TO 525:=255;
signal counter: INTEGER:=0;
signal moon_x: INTEGER RANGE 0 TO 799:=360;
signal moon_y: INTEGER RANGE 0 TO 525:=180;

-----
Component terre is
PORT
	(
		address		: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		q		: OUT STD_LOGIC_VECTOR (11 DOWNTO 0)
	);
END component;
-----
Component lune is
PORT
	(
		address		: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		q		: OUT STD_LOGIC_VECTOR (11 DOWNTO 0)
	);
END component;
-----
BEGIN

R1: terre port map(earth_add, clk, earth_out);
R2: lune port map(moon_add, clk, moon_out);
PROCESS(clk)
BEGIN
 if( clk ' EVENT AND clk ='1') THEN
 if (counter =0)then
		moon_x<=360;
		moon_y<=180;
	end if;
	if (VPOS=524) THEN
			counter<= counter+1;
	end if;
	
	if (HPOS<799) THEN
		HPOS<= HPOS+1;
	ELSE
		HPOS<=0;
		if (VPOS<524) THEN
			VPOS<= VPOS+1;
		ELSE
			VPOS<=0;
		END IF;
	END IF;
	
	IF(HPOS>0 AND HPOS<95) THEN
		HSYNC<='0';
	ELSE
		HSYNC<='1';
	END IF;
	
	IF(VPOS>0 AND VPOS<2) THEN
		VSYNC<='0';
	ELSE
		VSYNC<='1';
	END IF;
	
	IF((HPOS>0 AND HPOS<141) OR(VPOS>0 AND VPOS<34)or (HPOS>781 AND HPOS<799) OR(VPOS>514 AND VPOS<524)) THEN
		R<=(OTHERS=>'0');
		B<=(OTHERS=>'0');
		G<=(OTHERS=>'0');
	END IF;

	if(counter=1)  then
		moon_x<=399;
		moon_y<=188;
	End if;
	if(counter=2)  then
		moon_x<=430;
		moon_y<=210;
	End if;
	if(counter=3)  then
		moon_x<=453;
		moon_y<=242;
	End if;
	if(counter=4)  then
		moon_x<=460;
		moon_y<=280;
	End if;
	if(counter=5) then
		moon_x<=453;
		moon_y<=318;
	End if;
	if(counter=6)  then
		moon_x<=430;
		moon_y<=350;
	End if;
	if(counter=7)  then
		moon_x<=399;
		moon_y<=372;
	End if;
	if(counter=8)  then
		moon_x<=360;
		moon_y<=380;
	End if;
	if(counter=9)  then
		moon_x<=322;
		moon_y<=372;
	End if;
	if(counter=10) then
		moon_x<=290;
		moon_y<=350;
	End if;
	if(counter=11)  then
		moon_x<=268;
		moon_y<=318;
	End if;
	if(counter=12)  then
		moon_x<=260;
		moon_y<=280;
	End if;
	if(counter=13)  then
		moon_x<=268;
		moon_y<=241;
	End if;
	if(counter=14)  then
		moon_x<=290;
		moon_y<=210;
	End if;
	if(counter=15)  then
		moon_x<=322;
		moon_y<=188;
	End if;
	if (counter=16) then
	counter<=0;
	end if;
			R<=(OTHERS=>'0');
			B<=(OTHERS=>'0');
			G<=(OTHERS=>'0');
	if((VPOS >= earth_y) and (VPOS < earth_y+32)) then
		if((HPOS >= earth_x) and (HPOS < earth_x+32)) then
			earth_add <= earth_add+1;
			R<=earth_out(2 downto 0);
			G<=earth_out(6 downto 4);
			B<=earth_out(9 downto 8);
		end if;
	else
		earth_add <= (OTHERS=>'0');
	end if;
	if((VPOS >= moon_y) and (VPOS < moon_y+32)) then
		if((HPOS >= moon_x) and (HPOS < moon_x+32)) then
			moon_add <= moon_add+1;
			R<=moon_out(2 downto 0);
			G<=moon_out(6 downto 4);
			B<=moon_out(9 downto 8);
		end if;
	else
		moon_add <= (OTHERS=>'0');
	end if;
END IF;
end process;
process (clk)
    file file_pointer: text is out "video_earth_moon.txt";
    variable line_el: line;
begin

    if rising_edge(clk) then

        -- Write the time
        write(line_el, now); -- write the line.
       WRITE(line_el, string'(":")); -- write the line.

        -- Write the hsync
       write(line_el, string'(" "));
        write(line_el, (HSYNC)); -- write the line.

        -- Write the vsync
        write(line_el, string'(" "));
        write(line_el, (VSYNC)); -- write the line.

        -- Write the red
       write(line_el, string'(" "));
       write(line_el, ( R)); -- write the line.

        -- Write the green
        write(line_el, string'(" "));
        write(line_el, (G)); -- write the line.

        -- Write the blue
        write(line_el, string'(" "));
        write(line_el, (B)); -- write the line.
        --write(line_el, string'(" "));
        --write(line_el, (yellow)); -- write the line.

        writeline(file_pointer, line_el); -- write the contents into the file.

    end if;
end process;
End main;
