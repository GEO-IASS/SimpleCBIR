clear all; close all; clc;

pkg('load', 'image');

K = 40; L = 3; G = 5; N = 50;

% list all image files in the root
dataroot = './dataset/';
figroot = './figure/';
files = [ls([dataroot, '*/*.jpg']);
         ls([dataroot, '*/*.JPG']);
         ls([dataroot, '*/*.jpeg'])];

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
    X.gcm(idx, :) = gcm(I, G);
end

% perform random projection
d = size(X.phog, 1);
X.rp1 = randproj(X.phog, d);
X.rp2 = randproj(X.phog, d / 2);
X.rp3 = randproj(X.phog, d / 3);

% calculate distance for each pair of images.
printf('Computing the distance for each pair of images ...\n');
D = struct;
D.phog = pdist(X.phog);
D.gcm = pdist(X.gcm);
D.rp1 = pdist(X.rp1);
D.rp2 = pdist(X.rp2);
D.rp3 = pdist(X.rp3);
D.borda = borda(D.phog, D.gcm);

% create output directory, if needed
if exist(figroot) ~= 7
    mkdir(figroot);
end

U = unique(C);
len = length(U);
for idx = 1:len
    category = U{idx};
    printf('Ploting PR-curve for %s ...\n', category);

    % get all images with given image category
    T = strcmp(C, category);

    % perform leave-one-out and plot the PR curve
    [P, R] = loo(T, D.phog, N);
    f = prcurve({P}, {R}, [category, ' (PHOG)']);
    print(f, [figroot, category, '_phod.png'], '-dpng');

    [P, R] = loo(T, D.gcm, N);
    f = prcurve({P}, {R}, [category, ' (Grid Color Moments)']);
    print(f, [figroot, category, '_gcm.png'], '-dpng');

    [P1, R1] = loo(T, D.rp1, N);
    [P2, R2] = loo(T, D.rp2, N);
    [P3, R3] = loo(T, D.rp3, N);
    f = prcurve({P1, P2, P3}, {R1, R2, R3}, ...
                [category, ' (Random Projection)'], ...
                {'K = d', 'K = d/2', 'K = d/3'});
    print(f, [figroot, category, '_rp.png'], '-dpng');

    [P, R] = loo(T, D.borda, N);
    f = prcurve({P}, {R}, [category, ' (Borda Count)']);
    print(f, [figroot, category, '_bc.png'], '-dpng');
end
