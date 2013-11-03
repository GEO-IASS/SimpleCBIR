function [x] = gcm(I, G)
% GCM - Calculates 1st, 2nd, and 3rd color moments for each grid.
%   H = gcm(X, K)
%
% Arguments:
%   I - Image to be processed.
%   G - Number of grids.
%
% Returns:
%   x - 1st, 2nd, and 3rd moments for each grid.

if size(I, 3) == 1
    I = repmat(I, [1, 1, 3]);
end

I = rgb2hsv(I);

% calculate size of blocks
m = size(I, 1);
n = size(I, 2);
bm = round(m / G);
bn = round(n / G);
sizeM = [ones(1, G - 1) * bm, m - bm * (G - 1)];
sizeN = [ones(1, G - 1) * bn, n - bn * (G - 1)];

% calculate color moments
x = [];
for channel = 1:3
    C = mat2cell(I(:, :, channel), sizeM, sizeN);
    M = cellfun(@(B) [mean(B(:)); var(B(:)); skewness(B(:))], ...
                C, 'UniformOutput', false);
    x = [x; cell2mat(M)(:)];
end

end
