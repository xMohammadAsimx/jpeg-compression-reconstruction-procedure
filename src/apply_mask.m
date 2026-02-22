function output = apply_mask(input, mask)

block_size = 8;
[height, width] = size(input);

output = input;

for row = 1:block_size:height
    for col = 1:block_size:width
        % Extract one 8x8 block
        currBlock = input(row:row+block_size-1, col:col+block_size-1);
        
        % Apply the binary mask, zeroing out unwanted coefficients
        maskedBlock = currBlock;
        maskedBlock(~mask) = 0;

        % copyinh it back in the output matrix
        output(row:row+block_size-1, col:col+block_size-1) = maskedBlock;
    end
end

end
