% This function compresses a stream of integer symbols with the help of
% huffman dictionary
function bytes = huffman_encode(symbols, dict) 

% make a lookup table from symbol
sym_to_code = containers.Map(dict.symbols, dict.codes);

% converting symbols to their corresponding huffman bitstrings
bit_chunks = strings(numel(symbols), 1);
for i = 1:numel(symbols)
    bit_chunks(i) = sym_to_code(int32(symbols(i))); 
end

% merging all bitstrings into one long binary string
bit_str = join(bit_chunks, "");
bit_str = bit_str{1};
bit_str = char(bit_str);  % just a character array of 0 & 1

% padding bit string so that we make its length a multiple of 8
bit_len = numel(bit_str);
pad_len = mod(8 - mod(bit_len, 8), 8);  % 0 to 7 bits of padding
if pad_len > 0
    bit_str = [bit_str, repmat('0', 1, pad_len)];  % padding with zeros
end

% converting every 8 bits into a byte
total_bits = numel(bit_str);
num_bytes = ceil(total_bits / 8);
bytes = zeros(1, num_bytes, 'uint8'); 

for k = 1:num_bytes
    start_Index = (k-1)*8 + 1;
    end_Index = start_Index + 7;

    if end_Index > total_bits
        end_Index = total_bits;
    end

    byte_bits = bit_str(start_Index:end_Index);

    % if not full 8 bits we pad it again
    if numel(byte_bits) < 8
        byte_bits = [byte_bits, repmat('0', 1, 8 - numel(byte_bits))];
    end

    % converting binary string to number
    bytes(k) = uint8(bin2dec(byte_bits));
end

end
