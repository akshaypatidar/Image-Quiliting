function [output_image] = random_blocks(input_texture, output_image_size,patch_size)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    
    % output_image_size size is number of rows and columns of patches. Ex [100,100] 
    
    
    
    % dimension of input texture
    input_texture_dim = size(size(input_texture),2);
    
    if(input_texture_dim == 2)
        patches = get_patches(input_texture,patch_size);
        output_patches = zeros(patch_size*patch_size,output_image_size(1)*output_image_size(2));

    elseif(input_texture_dim == 3)
        patches(:,:,1) = get_patches(input_texture(:,:,1),patch_size);
        patches(:,:,2) = get_patches(input_texture(:,:,2),patch_size);
        patches(:,:,3) = get_patches(input_texture(:,:,3),patch_size);
        output_patches = zeros(patch_size*patch_size,output_image_size(1)*output_image_size(2),3);

    end
    
    num_patches = size(patches,2);
    
    r = randi([1,num_patches],1,output_image_size(1)*output_image_size(2));
        
    for i = 1:output_image_size(1)*output_image_size(2)
        output_patches(:,i,:) = patches(:,r(i),:);
    end
    
    output_image(:,:,1) = col2im(output_patches(:,:,1),[patch_size,patch_size],[patch_size*output_image_size(1),patch_size*output_image_size(2)],'distinct');
    output_image(:,:,2) = col2im(output_patches(:,:,2),[patch_size,patch_size],[patch_size*output_image_size(1),patch_size*output_image_size(2)],'distinct');
    output_image(:,:,3) = col2im(output_patches(:,:,3),[patch_size,patch_size],[patch_size*output_image_size(1),patch_size*output_image_size(2)],'distinct');
    
        

end

