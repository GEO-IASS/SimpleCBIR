function H = randproj(X, K)
% RANDPROJ - Generates k-bit binary codes by random projection.
%   H = randproj(X, K)
%
% Arguments:
%   X - Feature matrix of images.
%   K - Number of binary codes.
%
% Returns:
%   H - Generated K-bit binary codes for each image.

d = size(X, 2);
W = normrnd(0, 1, [d, K]);
H = (sign(X * W) + 1) / 2;

end
