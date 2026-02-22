% This function crop B (multiple of 8) back to its original size
function A = unblockify8(B, orig_size)
A = B(1:orig_size(1), 1:orig_size(2));
end
