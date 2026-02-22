function dict = build_huffman_dict(symbols)

symbols = symbols(:);

% Computing our histogram of symbol frequencies
max_sym = double(max(symbols));
counts = accumarray(double(symbols) + 1, 1, [max_sym + 1, 1]);

% Normalizing so we get probabilities
totalCount = sum(counts);
prob = counts / totalCount;

% Discarding symbols that are not appearing
used_Index = find(prob > 0);
actual_symbols = used_Index - 1;           
symbol_probs = prob(used_Index);

% Initializing Huffman tree as cell array of leaf nodes
nodes   = num2cell(actual_symbols(:));  
weights = num2cell(symbol_probs(:));    

% Building the Huffman tree by merging lowest weight nodes
while numel(nodes) > 1
    % nodes by their weights in ascending order
    [~, sorted_index] = sort(cell2mat(weights), 'ascend');
    i1 = sorted_index(1);
    i2 = sorted_index(2);

    % merge two lightest nodes
    combined_node = {nodes{i1}, nodes{i2}};
    combined_weight = weights{i1} + weights{i2};

    % Removing merged nodes and also appending the new one
    keep_mask = true(numel(nodes), 1);
    keep_mask([i1 i2]) = false;

    nodes   = [nodes(keep_mask);   {combined_node}];
    weights = [weights(keep_mask); {combined_weight}];
end

% the final remaining node is the root of our tree
tree = nodes{1};

% Traversing the Huffman tree to assign binary codes
codeMap = containers.Map('KeyType', 'int32', 'ValueType', 'char');

assignCode(tree, '');

% Build the output struct
dict.symbols = int32(actual_symbols(:));
dict.codes   = cellfun(@(s) codeMap(int32(s)), num2cell(actual_symbols), 'UniformOutput', false);
dict.counts  = int32(counts);  % including zeros for unused symbols

% Recursive tree traversal
function assignCode(node, prefix)
    if ~iscell(node)
        % Leaf node
        codeMap(int32(node)) = prefix;
    else
        % Binary tree of left gets 0 and right gets 1
        assignCode(node{1}, [prefix '0']);
        assignCode(node{2}, [prefix '1']);
    end
end

end
