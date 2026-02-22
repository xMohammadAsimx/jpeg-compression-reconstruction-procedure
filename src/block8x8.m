% This function pads matrix in a way that its size becomes multiple of 8 in both
% dimensions
function [B, padding] = block8x8(A)

[height, width] = size(A);

% to find how much padding we need to make it a multiple of 8
pad_rows = mod(8 - mod(height, 8), 8);
pad_cols = mod(8 - mod(width, 8), 8);
padding = [pad_rows, pad_cols];

A_padded = A; % copy of original

% to pad if we don't have height multiple of 8, padding with last row as
% repeated
if pad_rows > 0
    last_row = A(end, :); % take the last row
    row_padding = repmat(last_row, pad_rows, 1);
    A_padded = [A_padded; row_padding];
end

if pad_cols > 0
    last_col = A(:, end);
    col_padding = repmat(last_col, 1, pad_cols);
    A_padded = [A_padded, col_padding];
end

B = A_padded;

end
