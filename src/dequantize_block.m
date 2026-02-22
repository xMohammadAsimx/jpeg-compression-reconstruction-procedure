% This function performs quantization in reverse by multiplying each block
% with its Q matrix
function Yd = dequantize_block(Yq, Qmat)
% since quantized values are usually int16
Yq = double(Yq);

% multiplying block wise each 8x8 with the quantization matrix
Yd = blockproc(Yq, [8, 8], @(blk) blk.data .* Qmat);
end