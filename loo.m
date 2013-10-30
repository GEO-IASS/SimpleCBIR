function [P, R] = loo(images, classname, N)

X = {images(strcmp({images.class}, classname)).hist};
sizeX = size(X, 2);

P = zeros(1, N);
R = zeros(1, N);
for i = 1:sizeX
    d = arrayfun(@(image) distance(X{i}, image.hist), images);
    [_, idx] = sort(d);

    result = strcmp({images(idx(2:N + 1)).class}, classname);
    acc = cumsum(result);
    P = P + acc ./ [1:N];
    R = R + acc / sizeX;
end

P = P' / N;
R = R' / N;
