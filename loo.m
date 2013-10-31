function [P, R] = loo(images, category, N)
% LOO - Performs leave-one-out cross validation.
%   [P, R] = loo(images, category, N)
%
%   This function performs leave-one-out cross validation for given category,
%   and then calculates average recall and precision at different retrieved
%   image rank.
%
% Arguments:   image        - Array of image structures.
%              category     - Name of image category to be retrieved.
%              N            - Number of retrieved images.
%
% Returns:     P - Vector of precision values.
%              R - Vector of recall values.

% get all images with given image category
X = {images(strcmp({images.category}, category)).hist};
sizeX = size(X, 2);
if sizeX == 0
    P = R = [];
    return
end

P = zeros(1, N);
R = zeros(1, N);
for i = 1:sizeX
    % calculate distance between selected image and other images
    d = arrayfun(@(image) distance(X{i}, image.hist), images);

    % extract classes of top N images
    [_, idx] = sort(d);
    result = strcmp({images(idx(2:N + 1)).category}, category);

    % compute precision and recall at different rank
    acc = cumsum(result);
    P = P + acc ./ [1:N];
    R = R + acc / sizeX;
end

P = P' / N;
R = R' / N;

end
