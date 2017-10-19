// xFFT scaling schedule

case Nfft_s is  //Scale output
	when "00110" =>
		FftScaleSch_s	<= "00" & x"01A";
	when "00111" =>
		FftScaleSch_s	<= "00" & x"02A";
	when "01000" =>
		FftScaleSch_s	<= "00" & x"06A";
	when "01001" =>
		FftScaleSch_s	<= "00" & x"0AA";
	when "01010" =>
		FftScaleSch_s	<= "00" & x"1AA";
	when "01011" =>
		FftScaleSch_s	<= "00" & x"2AA";
	when "01100" =>
		FftScaleSch_s	<= "00" & x"6AA";
	when others =>
		FftScaleSch_s	<= "00" & x"AAA";
end case;