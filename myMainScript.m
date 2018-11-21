clc;
clear;
tic;
input_image = imread('./img/image-quilting/input_1.bmp');
input_image_dim = size(size(input_image),2);
patch_size = 48;
overlap = 8;
tolerance = 3;

output = overlapping_blocks(im2double(input_image), [5,5],patch_size,overlap,tolerance);


figure(1);
imshow(input_image);
title('Input Texture');

figure(2);
imshow(output);
title('Synthesized Texture');
toc;
