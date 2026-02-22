function [bitstream, meta_info] = compress_image(img, Q, threshold, visualize)

if nargin < 4
    visualize = false;
end

assert( Q>=1 && Q<=100, 'Q should be in the range of 1 to 100');
assert( threshold>=1 && threshold<=100, 'Threshold must be in the range of 1 to 64');
assert ( ndims(img) == 3 && size(img,3) == 3 && isa(img, 'uint8'), 'Image needs to be in RGB uint8');

% conversion into color space
ycbcr = rgb2ycbcr(img);
Y = ycbcr(:, :, 1);
cb = ycbcr(:, :, 2);
cr = ycbcr(:, :, 3);

% chroma subsampling in 4:2:0 format
[cb_down, cr_down] = subsample420(cb, cr);

if visualize
    figure('Name','chroma subsampling 4:2:0');
    subplot(2,2,1);
    imshow(img);
    title('Original RGB Image');

    subplot(2,2,2);
    imshow(Y);
    title('Original Luma (Y)');

    cb_upsample_vis = upsample420(cb_down, size(Y));
    cr_upsample_vis = upsample420(cr_down, size(Y));
    vis = ycbcr2rgb(cat(3, Y, cb_upsample_vis, cr_upsample_vis));
    subplot(2,2,3);
    imshow(vis);
    title('After 4:2:0 (nearest upsample)')
    
    subplot(2,2,4);
    imshow(cat(3, Y, 128*ones(size(Y), 'like', Y), 128*ones(size(Y), 'like', Y)));
    title('Y for reference');
end

% 8x8 blocks partitioning
Y_shifted  = double(Y) - 128;
Cb_shifted = double(cb_down) - 128;
Cr_shifted = double(cr_down) - 128;

[Y_blocks, padY]   = block8x8(Y_shifted);
[Cb_blocks, padC]  = block8x8(Cb_shifted);
[Cr_blocks, ~]     = block8x8(Cr_shifted);

% DCT to 8x8 block of our image
Yd  = dct8x8(Y_blocks);
Cbd = dct8x8(Cb_blocks);
Crd = dct8x8(Cr_blocks);

% masking to remove high frequency
mask = zigzag_mask(threshold); % logical 8x8 to keep first threshold coefficients
Yd  = apply_mask(Yd, mask);
Cbd = apply_mask(Cbd, mask);
Crd = apply_mask(Crd, mask);

% Quantization using our table
[Q_lum, Q_chrom] = std_quant_tables(Q);
Y_q  = quantize_block(Yd,  Q_lum);
Cb_q = quantize_block(Cbd, Q_chrom);
Cr_q = quantize_block(Crd, Q_chrom);

% Huffman encoding over combined streams
stream = [Y_q(:); Cb_q(:); Cr_q(:)];
minVal = min(stream);
maxVal = max(stream);
symbols = int32(stream - minVal);
dict = build_huffman_dict(symbols);
bitstream = huffman_encode(symbols, dict);

% metadata that we need for decoding
meta_info = struct();
meta_info.sizeRGB   = size(img);
meta_info.sizeY     = size(Y);
meta_info.sizeCb420 = size(cb_down);
meta_info.padY      = padY;
meta_info.padC      = padC;  % same for Cb/Cr
meta_info.Q         = Q;
meta_info.thr       = threshold;  
meta_info.QY        = Q_lum;
meta_info.QC        = Q_chrom;  
meta_info.minVal    = int32(minVal);
meta_info.maxVal    = int32(maxVal);
meta_info.dict      = dict;
meta_info.counts    = int32([numel(Y_q), numel(Cb_q), numel(Cr_q)]);

end