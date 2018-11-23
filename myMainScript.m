clc;
clear;
tic;
input_image = imread('./images/fruits1.bmp');
input_image(input_image==0) = 1;
input_image_dim = size(size(input_image),2);
patch_size = 8;
overlap = 2;
tolerance = 0.5;
alph = 0.15;


% figure(1);
% imshow(input_image);
% title('Input Texture');

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

% output_cut = overlapping_blocks(im2double(input_image), [8,8],patch_size,overlap,tolerance,true);
% figure(4);
% imshow(output_cut);
% title('Synthesized Texture with Cut');


input_texture = imread('./images/Food.0009.png');
target_image = imread('./img/texture-synthesis/Tom-Cruise-01.jpg');
input_texture(input_texture==0) = 1;

figure(6);
imshow(input_texture);
title('Input Texture');
% c_map = imgaussfilt(im2double(input_texture));
% target_image = imgaussfilt(im2double(target_image));


textured_image = texture_transfer(im2double(input_texture), im2double(target_image), patch_size, overlap, tolerance, alph);

figure(5);
imshow(textured_image);
title('Texture Transfer');
toc;