function [D] = pdist(X)
% PDIST - Computes distance between each pair of vectors.
%   D = distance(X)
%
% Arguments:
%   X - Data matrix.
%
% Returns:
%   D - The distance between instances in the data matrix, X.

% If u and v are binary codes, Hamming distance = L1 distance = L2 distance.
% In such a case,
%   d = sum(xor(u, v));
% is equal to
%   d = norm(u - v);

n = size(X, 1);
D = zeros(n, n);
for i = 1:n
    D(i, :) = arrayfun(@(j) norm(X(i, :) - X(j, :)), 1:n);
end

end
