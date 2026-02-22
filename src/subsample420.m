% This function does chroma subsampling in 4:2:0 format for cb and cr
function [cb_down, cr_down] = subsample420(cb, cr)

cb = double(cb);
cr = double(cr);

[height, width] = size(cb);

% Making sure that dimensions are even, we pad with the same value as last

if mod(height, 2) ~= 0
    cb(end+1, :) = cb(end, :); % repeat the last value of row
    cr(end+1, :) = cr(end, :);
end

if mod(width, 2) ~= 0
    cb(:, end+1) = cb(:, end);  % repeat the last column
    cr(:, end+1) = cr(:, end);
end

% There are multiple ways, to chroma subsample, I am going with filter
% since its easy
average_filter = ones(2,2) / 4;

% Applying covolution to our cb and cr components
cb_blurred = conv2(cb, average_filter, 'valid');
cr_blurred = conv2(cr, average_filter, 'valid');

% subsampling pixels in the image
cb_down = cb_blurred(1:2:end, 1:2:end);
cr_down = cr_blurred(1:2:end, 1:2:end);

cb_down = uint8(round(cb_down));
cr_down = uint8(round(cr_down));

end
