function [P, R] = loo(C, X, category, N)
% LOO - Performs leave-one-out cross validation.
%   [P, R] = loo(images, category, N)
%
%   This function performs leave-one-out cross validation for given category,
%   and then calculates average recall and precision at different retrieved
%   image rank.
%
% Arguments:
%   C           - Array of image categories.
%   X           - Feature matrix of images.
%   category    - Name of image category to be retrieved.
%   N           - Number of retrieved images.
%
% Returns:
%   P - Vector of precision values.
%   R - Vector of recall values.

sizeX = size(X, 1);

% get all images with given image category
idx = strcmp(C, category);;
sizeZ = sum(idx);
if sizeZ == 0
    P = R = [];
    return
end

Z = X(idx, :);
P = zeros(1, N);
R = zeros(1, N);
for i = 1:sizeZ
    % calculate distance between selected image and other images
    d = arrayfun(@(j) distance(Z(i, :), X(j, :)), 1:sizeX);

    % extract classes of top N images
    [_, idx] = sort(d);
    result = strcmp(C(idx), category);

    % compute precision and recall at different rank
    acc = cumsum(result(2:N + 1));
    P = P + acc ./ [1:N];
    R = R + acc / (sizeZ - 1);
end

P = P' / sizeZ;
R = R' / sizeZ;

end
