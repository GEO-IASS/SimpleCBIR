function [x] = phog(I, K, L)
% PHOG - Implementation of Pyramid of Histograms of Orientation Gradients algorithm.
%   x = phod(I, K, L)
%
% Arguments:
%   I - Image to be processed.
%   K - Number of orientation histogram bins.
%   L - Number of pyramid levels.
%
% Returns:
%   x - Pyramid histogram of oriented gradients.
%
% Reference:
%   Anna Bosch, Andrew Zisserman, and Xavier Munoz. 2007. Representing shape
%   with a spatial pyramid kernel. In Proceedings of the 6th ACM international
%   conference on Image and video retrieval (CIVR '07). ACM, New York, NY,
%   USA, 401-408.

if size(I, 3) == 3
    I = rgb2gray(I);
end

% apply Canny edge detector and Sobel mask
E = edge(I, 'canny');
[G, D] = sobel(I);
G(~E) = 0;

% quantize edge orientations into K bins
w = 360 / K;
B = ceil(D / w);

% compute orientation histogram
x = pyramid(G, B, K, L);

% normalization
sumX = sum(x);
if sumX ~= 0
    x = x / sumX;
end

end

% =========================
%   Private Function(s)
% =========================

function [x] = pyramid(G, B, K, L)

m = size(G, 1);
n = size(G, 2);

x = [];
if L > 0
    % divide image into 4 blocks
    bm = ceil(m / 2);
    bn = ceil(n / 2);
    colG = mat2cell(G, [bm, m - bm], [bn, n - bn]);
    colB = mat2cell(B, [bm, m - bm], [bn, n - bn]);

    % compute orientation histograms for each block
    totalX = zeros(K, 1);
    for idx = 1:4
        blockG = colG{idx};
        blockB = colB{idx};

        blockX = pyramid(blockG, blockB, K, L - 1);
        totalX = totalX + blockX(1:K);
        x = [x; blockX];
    end

    x = [totalX; x];
else
    for k = 1:K
        x = [x; sum(G(B == k))];
    end
end

end
