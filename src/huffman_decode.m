% This function decodes a huffman byte stream into its original symbols
function symbols = huffman_decode(bytes, dict)
% Starting with a root node
trie = struct('left', [], 'right', [], 'val', []);
trie(1).left = 0; trie(1).right = 0; trie(1).val = -1;  % here root is empty
nextFree = 2;  % index for our next new node

% Inserting each symbol/code pair into the trie
for i = 1:numel(dict.symbols)
    sym  = dict.symbols(i);
    code = dict.codes{i};
    node = 1;  % we start at root

    for bit = code
        if bit == '0'
            if trie(node).left == 0
                trie(node).left = nextFree;
                trie(nextFree) = struct('left', 0, 'right', 0, 'val', -1);
                nextFree = nextFree + 1;
            end
            node = trie(node).left;
        else
            if trie(node).right == 0
                trie(node).right = nextFree;
                trie(nextFree) = struct('left', 0, 'right', 0, 'val', -1);
                nextFree = nextFree + 1;
            end
            node = trie(node).right;
        end
    end

    % as soon as we reach the end of the path, assign the symbol to that node
    trie(node).val = sym;
end

% Converting byte stream to bit string
bitStr = '';
for b = bytes
    bitStr = [bitStr, dec2bin(b, 8)];  % Converting each byte to 8 character of binary string
end

% Decoding here using the trie

expectedSymbols = sum(double(dict.counts));  % how many here to decode exactly
symbols = zeros(expectedSymbols, 1, 'int32');  % preallocating output
outIndex = 1;
node = 1;  % Starting at root
bitIndex = 1;

while bitIndex <= length(bitStr) && outIndex <= expectedSymbols
    if bitStr(bitIndex) == '0'
        node = trie(node).left;
    else
        node = trie(node).right;
    end
    bitIndex = bitIndex + 1;

    % checking if we are at a leaf node
    if node == 0
        break;
    end

    if trie(node).val ~= -1
        symbols(outIndex) = int32(trie(node).val);
        outIndex = outIndex + 1;
        node = 1;
    end
end

% cut in case we decoded fewer symbols than expected
symbols = symbols(1:outIndex-1);

end
