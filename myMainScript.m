clc;
clear;
tic;
input_image = imread('./images/fruits1.bmp');
input_image(input_image==0) = 1;
input_image_dim = size(size(input_image),2);
patch_size = 36;
overlap = 6;
tolerance = 0.25;



figure(1);
imshow(input_image);
title('Input Texture');

% random_blocks_output = random_blocks(im2double(input_image),[6,6],patch_size);
% figure(2);
% imshow(random_blocks_output);
% title('Random Texture');
% 
% 
% output = overlapping_blocks(im2double(input_image), [6,6],patch_size,overlap,tolerance,false);
% clc;
% 
% figure(3);
% imshow(output);
% title('Synthesized Texture Without Cut');

output_cut = overlapping_blocks(im2double(input_image), [8,8],patch_size,overlap,tolerance,true);
figure(4);
imshow(output_cut);
title('Synthesized Texture with Cut');
toc;
