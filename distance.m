function [d] = distance(u, v)
% DISTANCE - Computes distance between two vectors.
%   d = distance(u, v)

% if u and v are binary codes,
% L1 distance = L2 distance = Hamming distance
% d = sum(xor(u, v));
d = norm(u - v);

end
