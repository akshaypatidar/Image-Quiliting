function [output_image] = overlapping_blocks(input_texture, output_image_size,patch_size,overlap,tolerance)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    % output_image_size size is number of rows and columns of patches. Ex [100,100] 
    
    % dimension of input texture
    input_texture_dim = size(size(input_texture),2);
    
    if(input_texture_dim == 2)
        patches = get_patches(input_texture,patch_size);
        patches = double(patches);
        output_image = zeros((patch_size-overlap)*output_image_size(1)+overlap,(patch_size-overlap)*output_image_size(2)+overlap);

    elseif(input_texture_dim == 3)
        patches(:,:,1) = get_patches(input_texture(:,:,1),patch_size);
        patches(:,:,2) = get_patches(input_texture(:,:,2),patch_size);
        patches(:,:,3) = get_patches(input_texture(:,:,3),patch_size);
        patches = double(patches);
        output_image = zeros((patch_size-overlap)*output_image_size(1)+overlap,(patch_size-overlap)*output_image_size(2)+overlap,3);

    end
    
    num_patches = size(patches,2);
    
    first_patch = randi([1,num_patches],1,1);
    
    output_image(1:patch_size,1:patch_size,:) = reshape(patches(:,first_patch(1),:),patch_size,patch_size,input_texture_dim);
    
    for row = 1:output_image_size(1)
        for col = 1:output_image_size(2)
            if(row == 1)
                if(col > 1)
                    left_block = output_image(1:patch_size,1+(patch_size-overlap)*(col-2):(patch_size-overlap)*(col-2)+patch_size,:); 
                    left_block = reshape(left_block,patch_size*patch_size,1,input_texture_dim);
                    %display(patches(1,1,1));
                    %display(left_block(1,1));
                    %display(size(patches));
                    %display(size(repmat(left_block,1,num_patches)));
                    
                    error = patches - repmat(left_block,1,num_patches);
                    error = sum(sum(error.^2,1),3);
                    [min_error,~] = min(error);
                    if(min_error == 0)
                        [min_error,~] = min(setdiff(error,0));
                    end
                    index = 1:num_patches;
                    possible_blocks = (error < (1+tolerance)*min_error & error > 0).*index;
                    possible_blocks(possible_blocks==0)=[];
                    next_block_no = randi([1,size(possible_blocks,2)],1,1);
                    fprintf('Row = %d, Col = %d, Next Patch No. = %d, No. of possible blocks = %d\n',row,col,next_block_no(1),size(possible_blocks,2));
                    next_patch = patches(:,next_block_no(1),:);
                    next_patch = reshape(next_patch,patch_size,patch_size,input_texture_dim);
                    left_block = reshape(left_block,patch_size,patch_size,input_texture_dim);
                    output_image(1:patch_size,(patch_size-overlap)*(col-1)+1:(patch_size-overlap)*(col-1)+patch_size,:)=cut(next_patch,left_block,0,overlap,'left');
                    
                end
            elseif(col == 1)
                if(row > 1)
                    top_block = output_image(1+(patch_size-overlap)*(row-2):(patch_size-overlap)*(row-2)+patch_size,1:patch_size,:);
                    top_block = reshape(top_block,patch_size*patch_size,1,input_texture_dim);
                    error = patches - repmat(top_block,1,num_patches);
                    error = sum(sum(error.^2,1),3);
                    [min_error,~] = min(error);
                    if(min_error == 0)
                        [min_error,~] = min(setdiff(error,0));
                    end
                    index = 1:num_patches;
                    possible_blocks = (error < (1+tolerance)*min_error & error > 0).*index;
                    possible_blocks(possible_blocks==0)=[];
                    next_block_no = randi([1,size(possible_blocks,2)],1,1);
                    fprintf('Row = %d, Col = %d, Next Patch No. = %d, No. of possible blocks = %d\n',row,col,next_block_no(1),size(possible_blocks,2));
                    next_patch = patches(:,next_block_no(1),:);
                    next_patch = reshape(next_patch,patch_size,patch_size,input_texture_dim);
                    top_block = reshape(top_block,patch_size,patch_size,input_texture_dim);
                    output_image((patch_size-overlap)*(row-1)+1:(patch_size-overlap)*(row-1)+patch_size,1:patch_size,:)=cut(next_patch,0,top_block,overlap,'top');

                end
            else
                left_block = output_image(1+(patch_size-overlap)*(row-1):(patch_size-overlap)*(row-1)+patch_size,1+(patch_size-overlap)*(col-2):(patch_size-overlap)*(col-2)+patch_size,:);
                top_block = output_image(1+(patch_size-overlap)*(row-2):(patch_size-overlap)*(row-2)+patch_size,1+(patch_size-overlap)*(col-1):(patch_size-overlap)*(col-1)+patch_size,:);
                left_block = reshape(left_block,patch_size*patch_size,1,input_texture_dim);
                top_block = reshape(top_block,patch_size*patch_size,1,input_texture_dim);
                error1 = patches - repmat(top_block,1,num_patches);
                error1 = sum(sum(error1.^2,1),3);
                error2 = patches - repmat(left_block,1,num_patches);
                error2 = sum(sum(error2.^2,1),3);
                error = error1+error2;
                [min_error,~] = min(error);
                if(min_error == 0)
                    [min_error,~] = min(setdiff(error,0));
                end
                index = 1:num_patches;
                
                possible_blocks = (error < (1+tolerance)*min_error & error > 0).*index;
                possible_blocks(possible_blocks==0)=[];
                next_block_no = randi([1,size(possible_blocks,2)],1,1);
                fprintf('Row = %d, Col = %d, Next Patch No. = %d, No. of possible blocks = %d\n',row,col,next_block_no(1),size(possible_blocks,2));
                next_patch = patches(:,next_block_no(1),:);
                next_patch = reshape(next_patch,patch_size,patch_size,input_texture_dim);
                top_block = reshape(top_block,patch_size,patch_size,input_texture_dim);
                left_block = reshape(left_block,patch_size,patch_size,input_texture_dim);
                output_image((patch_size-overlap)*(row-1)+1:(patch_size-overlap)*(row-1)+patch_size,(patch_size-overlap)*(col-1)+1:(patch_size-overlap)*(col-1)+patch_size,:)=cut(next_patch,left_block,top_block,overlap,'both');

                
            end
        end
    end
       
end
