function [x] = phod(I, K, L)

if size(I, 3) == 3
    I = rgb2gray(I);
end

% apply Canny edge detector and Sobel mask
E = edge(I, 'canny');
[G, D] = sobel(I);
G(~E) = 0;

% compute orientation histogram
B = ceil(D * K / 360);
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

if L > 0
    % divide image into 4 blocks
    m = size(G, 1); bm = ceil(m / 2);
    n = size(G, 2); bn = ceil(n / 2);
    colG = mat2cell(G, [bm, m - bm], [bn, n - bn]);
    colB = mat2cell(B, [bm, m - bm], [bn, n - bn]);

    % compute orientation histograms for each block
    X = cellfun(@(blockG, blockB) pyramid(blockG, blockB, K, L - 1), ...
                colG, colB, 'UniformOutput', false);
    X = cell2mat(X);
    x = [sum(X(1:K, :), 2); X(:)];
else
    x = arrayfun(@(k) sum(G(B == k)), 1:K).';
end

end
