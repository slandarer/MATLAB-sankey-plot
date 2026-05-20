function globalAdj = mergeAdjMat(layerAdj)
% MERGEADJMAT Merge inter-layer adjacency matrices into global block matrix
%   globalAdj = mergeAdjMat(layerAdj) assembles a block matrix where
%   the super-diagonal blocks are the inter-layer adjacency matrices.
%
%   Input:  layerAdj - cell array {A12, A23, ..., A_{n-1,n}}
%   Output: globalAdj - block matrix with zero diagonal blocks
%
%   Example:
%       A12 = rand(3); A23 = rand(3);
%       globalAdj = mergeAdjMat({A12, A23});

if ~iscell(layerAdj)
    error('Input must be a cell array.');
end
n = length(layerAdj);
for k = 1:n-1
    [~, col] = size(layerAdj{k});
    [row, ~] = size(layerAdj{k + 1});
    if col ~= row
        error('Dimension mismatch: A%d%d has %d columns, but A%d%d has %d rows.', k, k+1, col, k+1, k+2, row);
    end
end
blkSize = zeros(n + 1, 2);
for k = 1:n
    blkSize(k + 1, :) = size(layerAdj{k});
end
blkSize(1, 2) = blkSize(2, 1);
N = sum(blkSize(:, 2));

globalAdj = zeros(N, N);
blkPos = cumsum(blkSize, 1);
for k = 1:n
    globalAdj((blkPos(k, 1) + 1):blkPos(k + 1, 1), ...
              (blkPos(k, 2) + 1):blkPos(k + 1, 2)) = layerAdj{k};
end
end