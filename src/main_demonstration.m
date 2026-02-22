% Author: Mohammad Asim

% This is the main file that loads both our compress_image() and reconst() function

% Our test image (RGB), I'm using MATLAB builtin image from library
img = imread('peppers.png');

% Compression settings
% Q = 80;              % quality factor 1 to 100
% thr = 32;            % number of zig zag DCT coefficients to keep
Q = input('Enter quality factor Q between 1 and 100: ');
thr = input('Enter number of zig-zag coefficients to keep between 1 and 64: ');
visualize = true;    % to show intermediate chroma subsampling

fprintf('Compressing with Q = %d, thr = %d\n', Q, thr);

% running compression algorithm
[bitstream, meta] = compress_image(img, Q, thr, visualize);
fprintf('Bitstream length: %d bytes\n', numel(bitstream));

% reconstruction of iamge
reconstructed = reconst(bitstream, meta);

% display side by side
figure;
subplot(1,2,1); 
imshow(img);          
title('Original Image');

subplot(1,2,2); 
imshow(reconstructed); 
title('Reconstructed Image');

% calculation of PSNR
diff = double(img(:)) - double(reconstructed(:));
mse = mean(diff .^ 2);  % mean squared error
psnr_val = 10 * log10(255^2 / mse);

fprintf('PSNR: %.2f dB\n', psnr_val);

