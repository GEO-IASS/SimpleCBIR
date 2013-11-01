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
X = struct('phog', []);
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

while true
    category = deblank(input('> ', 's'));
    if strcmp(category, '')
        continue
    elseif ~any(strcmp(C, category))
        printf('Category ''%s'' not exists.\n', category);
        continue
    end

    % perform leave-one-out and plot the PR curve
    [P, R] = loo(C, X.phog, category, N);
    prcurve({P}, {R}, [category, ' (PHOG)']);

    [P, R] = loo(C, X.gcm, category, N);
    prcurve({P}, {R}, [category, ' (Grid Color Moments)']);

    [P1, R1] = loo(C, X.rp1, category, N);
    [P2, R2] = loo(C, X.rp2, category, N);
    [P3, R3] = loo(C, X.rp3, category, N);
    prcurve({P1, P2, P3}, {R1, R2, R3}, ...
            [category, ' (Random Projection)'], ...
            {'K = d)', 'K = d/2', 'K = d/3'});

    fprintf('Press any key to continue...');
    pause;
    fprintf('\n');
end
