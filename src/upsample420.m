function z = upsample420(c_down, targetSize)

% size of our input chroma
[height, width] = size(c_down);

% initializing an array of twice the size of our input chroma
c_big = zeros(2*height, 2*width);

% duplicating each pixel into a 2x2 block type
for i = 1:height
    for j = 1:width
        pixel = double(c_down(i, j));
        rowIndex = (i-1)*2 + 1;
        colIndex = (j-1)*2 + 1;
        c_big(rowIndex:rowIndex+1, colIndex:colIndex+1) = pixel;
    end
end

z = uint8(c_big(1:targetSize(1), 1:targetSize(2)));

end