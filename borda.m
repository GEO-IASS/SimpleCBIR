function [B] = borda(varargin)
% BORDA - Computes borda counts according to the given distance matrices.
%   [B] = borda(D, ...)
%
% Arguments:
%   D - Distance matrix of images.
%
% Returns:
%   B - Borda count matrix.

if nargin == 0
    B = [];
    return;
end

n = size(varargin{1}, 1);
B = zeros(n, n);
for d = 1:nargin
    D = varargin{d};
    [_, idx] = sort(D);

    P = zeros(n, n);
    for i = 1:n
        P(idx(:, i), i) = [1:n];
    end

    B = B + P;
end

end
