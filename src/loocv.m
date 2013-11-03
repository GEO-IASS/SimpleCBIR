function [P, R] = loocv(T, D, N)
% LOOCV - Performs leave-one-out cross validation.
%   [P, R] = loocv(T, D, N)
%
%   This function performs leave-one-out cross validation for given category,
%   and then calculates average recall and precision at different retrieved
%   image rank.
%
% Arguments:
%   T - Vector of bools indicating whether the instance is the retrieval target.
%   D - Distance matrix of images.
%   N - Number of retrieved images.
%
% Returns:
%   P - Vector of precision values.
%   R - Vector of recall values.

targets = find(T);
len = length(targets);
if len == 0
    P = R = [];
    return
end

P = zeros(1, N);
R = zeros(1, N);
for i = 1:len
    % get top N images with smallest distance
    d = D(targets(i), :);
    [_, idx] = sort(d);
    result = T(idx);

    % compute precision and recall at different rank
    acc = cumsum(result(2:N + 1));
    P = P + acc ./ [1:N];
    R = R + acc / (len - 1);
end

P = P' / len;
R = R' / len;

end
