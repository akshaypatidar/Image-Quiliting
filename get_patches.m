function [ patches ] = get_patches( input_image, patch_size )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    patches = im2col(input_image,[patch_size,patch_size],'sliding');
    patches = patches(:,1:1:end,:);
    fprintf('Total Number of Patches = %d \n',size(patches,2));
    
end

