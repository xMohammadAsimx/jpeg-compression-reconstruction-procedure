% This function returns us scaled JPEG quantization tables based on quality setting
function [Q_lum, Q_Chrom] = std_quant_tables(Q)

% Default JPEG standard quantization tables
Q_lum = [16 11 10 16 24 40 51 61;
      12 12 14 19 26 58 60 55;
      14 13 16 24 40 57 69 56;
      14 17 22 29 51 87 80 62;
      18 22 37 56 68 109 103 77;
      24 35 55 64 81 104 113 92;
      49 64 78 87 103 121 120 101;
      72 92 95 98 112 100 103 99];

Q_Chrom = [17 18 24 47 99 99 99 99;
      18 21 26 66 99 99 99 99;
      24 26 56 99 99 99 99 99;
      47 66 99 99 99 99 99 99;
      99 99 99 99 99 99 99 99;
      99 99 99 99 99 99 99 99;
      99 99 99 99 99 99 99 99;
      99 99 99 99 99 99 99 99];

% Normalizing the quality scale
if Q < 50
    scale = 5000 / Q;
else 
    scale = 200 - 2 * Q;
end

% scaling both the tables
Q_lum = floor((Q_lum * scale + 50) / 100);
Q_Chrom = floor((Q_Chrom * scale + 50) / 100);

% minimum values to 1
Q_lum(Q_lum == 0) = 1;
Q_Chrom(Q_Chrom == 0) = 1;

end
