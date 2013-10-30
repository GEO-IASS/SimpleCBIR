function [x] = phod(I, K, L)

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
