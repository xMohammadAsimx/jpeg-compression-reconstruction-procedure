function Yd = dct8x8(Yp)

block_size = [8, 8];

% Creating an anonymous function
dctFunc = @(blockStruct) dct2(blockStruct.data);

% Applying the DCT to 8x8
Yd = blockproc(Yp, block_size, dctFunc);

end