function [G, D] = sobel(I)
% SOBEL - Computes orientation gradients using a 3 × 3 Sobel mask.
%   [G, D] = sobel(I)
%
% Arguments:
%   I - Image to be processed.
%
% Returns:
%   S - Matrix of gradient amplitudes.
%   D - Matrix of gradient orientations (in degrees 0-360).

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
