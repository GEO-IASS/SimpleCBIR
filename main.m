clear all; close all; clc;

pkg('load', 'image');

K = 40; L = 3; N = 50;

% list all image files in the root
root = './dataset';
files = [ls([root, '/*/*.jpg']);
         ls([root, '/*/*.JPG']);
         ls([root, '/*/*.jpeg'])];

% load images and extract features
images = [];
nrows = size(files, 1);
for idx = 1:nrows
    filepath = deblank(files(idx, :));
    tokens = strsplit(filepath, '/');
    printf('Loading %s/%s ...\n', tokens{3}, tokens{4});

    I = imread(filepath);
    x = phog(I, K, L);

    images(idx).path = filepath;
    images(idx).name = tokens{4};
    images(idx).category = tokens{3};
    images(idx).hist = x;
end

while true
    category = deblank(input('> ', 's'));
    if strcmp(category, '')
        continue
    end

    % perform leave-one-out and plot the PR curve
    [P, R] = loo(images, category, N);
    if size(P) == 0
        printf('Category ''%s'' not exists.\n', category);
        continue
    end
    prcurve(P, R, category);

    fprintf('Press any key to continue...');
    pause;
    fprintf('\n');
end
