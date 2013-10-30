clear all; close all; clc;

pkg('load', 'image');

K = 40; L = 3; N = 50;

root = './dataset';
files = [ls([root, '/*/*.jpg']);
         ls([root, '/*/*.JPG']);
         ls([root, '/*/*.jpeg'])];

images = [];
nrows = size(files, 1);
for idx = 1:nrows
    filepath = deblank(files(idx, :));
    tokens = strsplit(filepath, '/');
    printf('Loading %s/%s ...\n', tokens{3}, tokens{4});

    I = imread(filepath);
    x = phod(I, K, L);

    images(idx).path = filepath;
    images(idx).name = tokens{4};
    images(idx).class = tokens{3};
    images(idx).hist = x;
end

while true
    name = deblank(input('> ', 's'));
    if strcmp(name, '')
        continue
    end

    [P, R] = loo(images, name, N);
    if size(P) == 0
        printf('Image class ''%s'' not exists.\n', name);
        continue
    end
    prcurve(P, R, name);

    fprintf('Press any key to continue...');
    pause;
    fprintf('\n');
end
