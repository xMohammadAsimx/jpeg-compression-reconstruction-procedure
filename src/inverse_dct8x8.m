% This function applies 2D DCT in inverse for each 8x8 block of input
function Yp = inverse_dct8x8(Yd)

blockSize = [8, 8];

% applying the inverse DCT to each block using pre made blockproc
Yp = blockproc(Yd, blockSize, @(block) idct2(block.data));

end
