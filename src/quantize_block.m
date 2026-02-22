% This function will apply quantization to each 8x8 DCT block using our
% quantization matrix
function Yq = quantize_block(Yd, Qmat)

% 8x8 block size
block_size = [8 8];

% Applying element wise division & rounding
quantize_function = @(block) round(block.data ./ Qmat);

% Applying to all 8x8 blocks using blockproc 
Yq = blockproc(Yd, block_size, quantize_function);

Yq = int16(Yq);

end