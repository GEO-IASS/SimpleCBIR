function [x] = pyramid(G, B, K, l)

m = size(G, 1);
n = size(G, 2);

x = [];
if l > 0
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

        blockX = pyramid(blockG, blockB, K, l - 1);
        totalX = totalX + blockX(1:K);
        x = [x; blockX];
    end

    x = [totalX; x];
else
    for k = 1:K
        x = [x; sum(G(B == k))];
    end
end
