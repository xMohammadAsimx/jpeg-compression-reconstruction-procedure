% This function does the reconstruction of our image in reverse process
function img_rec = reconst(bitstream, meta)

% huffman decode
symbols = huffman_decode(bitstream, meta.dict);
stream = int32(symbols) + meta.minVal;

% spliting into Y, Cb, Cr streams
nY  = double(meta.counts(1));
nCb = double(meta.counts(2));
nCr = double(meta.counts(3));

Yq  = reshape(stream(1:nY), meta.sizeY + meta.padY);
Cbq = reshape(stream(nY+1:nY+nCb), meta.sizeCb420 + meta.padC);
Crq = reshape(stream(nY+nCb+1:nY+nCb+nCr), meta.sizeCb420 + meta.padC);

% quantization in reverse 
Yd  = dequantize_block(double(Yq),  meta.QY);
Cbd = dequantize_block(double(Cbq), meta.QC);
Crd = dequantize_block(double(Crq), meta.QC);

% Inverse of DCT
Yp   = inverse_dct8x8(Yd);
Cb_p = inverse_dct8x8(Cbd);
Cr_p = inverse_dct8x8(Crd);

% removing padding and recomposing planes
Y    = uint8(unblockify8(Yp,   meta.sizeY)     + 128);
Cb_ds= uint8(unblockify8(Cb_p, meta.sizeCb420) + 128);
Cr_ds= uint8(unblockify8(Cr_p, meta.sizeCb420) + 128);

% upsample in 4:2:0 to luma size converting back to RGB
Cb = upsample420(Cb_ds, meta.sizeY);
Cr = upsample420(Cr_ds, meta.sizeY);
ycbcr_rec = cat(3, Y, Cb, Cr);
rgb_rec = ycbcr2rgb(ycbcr_rec);

% cropping to original RGB size
img_rec = rgb_rec(1:meta.sizeRGB(1), 1:meta.sizeRGB(2), :);
end

