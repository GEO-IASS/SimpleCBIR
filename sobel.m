function [G, D] = sobel(I)

if ~strcmp(class(I), 'double')
    I = double(I);
end

%[Gx, Gy] = gradient(I);
h = fspecial('sobel');
Gx = imfilter(I, h, 'replicate');
Gy = imfilter(I, h', 'replicate');

G = hypot(Gx, Gy);
D = (atan2(Gy, Gx) + pi) * 180 / pi;

end
