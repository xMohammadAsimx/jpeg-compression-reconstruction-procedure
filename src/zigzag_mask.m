function mask = zigzag_mask(K)

% zig-zag order for a list of (row, col) positions
zz_indices = zigzag();

% To make sure that K remains in a valid range
if K < 1
    K = 1;
elseif K > 64
    K = 64;
end

% An 8x8 mask with all false, we will set it to true where we need 
mask = false(8, 8);

% set only those true, that are in zig zag positions
for n = 1:K
    row = zz_indices(n, 1);
    col = zz_indices(n, 2);
    mask(row, col) = true;
end

end