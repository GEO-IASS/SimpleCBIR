clear all; close all; clc;

pkg('load', 'image');

K = 40; L = 3; N = 50;

% list all image files in the root
root = './dataset';
files = [ls([root, '/*/*.jpg']);
         ls([root, '/*/*.JPG']);
         ls([root, '/*/*.jpeg'])];

% load images and extract features
C = {};
X = struct;
nrows = size(files, 1);
for idx = 1:nrows
    filepath = deblank(files(idx, :));
    tokens = strsplit(filepath, '/');
    printf('Loading %s/%s ...\n', tokens{3}, tokens{4});

    I = imread(filepath);
    C{idx} = tokens{3};
    X.phog(idx, :) = phog(I, K, L);
    X.gcm(idx, :) = gcm(I, 5);
end

% perform random projection
d = size(X.phog, 1);
X.rp1 = randproj(X.phog, d);
X.rp2 = randproj(X.phog, d / 2);
X.rp3 = randproj(X.phog, d / 3);

% calculate distance for each pair of images.
D = struct;
D.phog = distance(X.phog);
D.gcm = distance(X.gcm);
D.rp1 = distance(X.rp1);
D.rp2 = distance(X.rp2);
D.rp3 = distance(X.rp3);

while true
    category = deblank(input('> ', 's'));
    if strcmp(category, '')
        continue
    elseif ~any(strcmp(C, category))
        printf('Category ''%s'' not exists.\n', category);
        continue
    end

    % get all images with given image category
    T = strcmp(C, category);

    % perform leave-one-out and plot the PR curve
    [P, R] = loo(T, D.phog, N);
    prcurve({P}, {R}, [category, ' (PHOG)']);

    [P, R] = loo(T, D.gcm, N);
    prcurve({P}, {R}, [category, ' (Grid Color Moments)']);

    [P1, R1] = loo(T, D.rp1, N);
    [P2, R2] = loo(T, D.rp2, N);
    [P3, R3] = loo(T, D.rp3, N);
    prcurve({P1, P2, P3}, {R1, R2, R3}, ...
            [category, ' (Random Projection)'], ...
            {'K = d', 'K = d/2', 'K = d/3'});

    fprintf('Press any key to continue...');
    pause;
    fprintf('\n');
end
