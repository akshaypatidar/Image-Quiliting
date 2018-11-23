function [output_image] = texture_transfer(input_texture, target_image,patch_size,overlap,tolerance,alph)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    % output_image_size size is number of rows and columns of patches. Ex [100,100] 
    
    % dimension of input texture
    input_texture_dim = size(size(input_texture),2);
    [sz1,sz2,sz3] = size(target_image);
    if(input_texture_dim == 2)
        patches_original = get_patches(input_texture,patch_size);
        patches_original = double(patches_original);
        output_image = zeros(fix((sz1-overlap)/(patch_size-overlap)),fix((sz2-overlap)/(patch_size-overlap)));

    elseif(input_texture_dim == 3)
        patches_original(:,:,1) = get_patches(input_texture(:,:,1),patch_size);
        patches_original(:,:,2) = get_patches(input_texture(:,:,2),patch_size);
        patches_original(:,:,3) = get_patches(input_texture(:,:,3),patch_size);
        patches_original = double(patches_original);
        output_image = zeros(fix((sz1-overlap)/(patch_size-overlap)),fix((sz2-overlap)/(patch_size-overlap)),sz3);
    end
    
    patches = patches_original;
    
    num_patches = size(patches,2);
    
    first_patch = randi([1,num_patches],1,1);
    fprintf('Row = %d, Col = %d, Patch No. = %d, No. of possible blocks = %d\n',1,1,first_patch,num_patches);

    output_image(1:patch_size,1:patch_size,:) = reshape(patches(:,first_patch(1),:),patch_size,patch_size,input_texture_dim);
    
    %%%%%
    % COMPUTE ERROR USING OVERLAPPING REGION
    %%%%%
    fprintf('sz1=%d sz2=%d patch=%d',sz1,sz2,patch_size);
    for row = 1:fix((sz1-overlap)/(patch_size-overlap))
        for col = 1:fix((sz2-overlap)/(patch_size-overlap))
            if(row == 1)
                if(col > 1)
                    left_block = output_image(1:patch_size,1+(patch_size-overlap)*(col-2):(patch_size-overlap)*(col-2)+patch_size,:); 
                    left_block = reshape(left_block,patch_size*patch_size,1,input_texture_dim);
                    cur_block = target_image(1:patch_size,(patch_size-overlap)*(col-1)+1:(patch_size-overlap)*(col-1)+patch_size,:);
                    cur_block = reshape(cur_block,patch_size*patch_size,1,input_texture_dim);
                    
                    
                    overlap_error = patches(1:patch_size*overlap,:,:)-repmat(left_block(size(patches,1)-overlap*patch_size+1:size(patches,1),:,:),1,num_patches);

                    error = overlap_error;
                    
                    cor_error = patches - repmat(cur_block,1,num_patches);
                    error = sum(alph*sum(error.^2,1)+(1-alph)*sum(cor_error.^2,1),3);
                    left_block = reshape(left_block,patch_size,patch_size,input_texture_dim);
                end
            elseif(col == 1)
                if(row > 1)
                    top_block = output_image(1+(patch_size-overlap)*(row-2):(patch_size-overlap)*(row-2)+patch_size,1:patch_size,:);
                    top_block = reshape(top_block,patch_size*patch_size,1,input_texture_dim);
                    cur_block = target_image((patch_size-overlap)*(row-1)+1:(patch_size-overlap)*(row-1)+patch_size,1:patch_size,:);
                    cur_block = reshape(cur_block,patch_size*patch_size,1,input_texture_dim);
                    
                    index = 1:patch_size*patch_size;
                    mask_top_block = (patch_size-overlap <= mod(index-1,patch_size));
                    mask_patches = (mod(index-1,patch_size) < overlap);
                    %display(size(repmat(mask',1,num_patches,input_texture_dim)));\
                    
                    patches_masked = patches.*(repmat(mask_patches',1,num_patches,input_texture_dim));
                    top_block_masked = top_block.*repmat(mask_top_block',1,1,input_texture_dim);

                    top_block_masked_new = zeros(patch_size*overlap,1,3);
                    patches_masked_new = zeros(patch_size*overlap,num_patches,3);
       
                    top_block_masked_new(:,:,1)= nonzeros(top_block_masked(:,:,1));
                    top_block_masked_new(:,:,2)= nonzeros(top_block_masked(:,:,2));
                    top_block_masked_new(:,:,3)= nonzeros(top_block_masked(:,:,3));
                    
                    patches_masked_new(:,:,1) = reshape(nonzeros(patches_masked(:,:,1)), patch_size*overlap, num_patches);
                    patches_masked_new(:,:,2) = reshape(nonzeros(patches_masked(:,:,2)), patch_size*overlap, num_patches);
                    patches_masked_new(:,:,3) = reshape(nonzeros(patches_masked(:,:,3)), patch_size*overlap, num_patches);
                    
                    
                    
                    overlap_error = patches_masked_new-repmat(top_block_masked_new,1,num_patches);
                    error = overlap_error;
                    cor_error = patches - repmat(cur_block,1,num_patches);
                    error = sum(alph*sum(error.^2,1)+(1-alph)*sum(cor_error.^2,1),3);
                    top_block = reshape(top_block,patch_size,patch_size,input_texture_dim);

                end
            else
                left_block = output_image(1+(patch_size-overlap)*(row-1):(patch_size-overlap)*(row-1)+patch_size,1+(patch_size-overlap)*(col-2):(patch_size-overlap)*(col-2)+patch_size,:);
                top_block = output_image(1+(patch_size-overlap)*(row-2):(patch_size-overlap)*(row-2)+patch_size,1+(patch_size-overlap)*(col-1):(patch_size-overlap)*(col-1)+patch_size,:);
                left_block = reshape(left_block,patch_size*patch_size,1,input_texture_dim);
                top_block = reshape(top_block,patch_size*patch_size,1,input_texture_dim);
                cur_block = target_image((patch_size-overlap)*(row-1)+1:(patch_size-overlap)*(row-1)+patch_size,(patch_size-overlap)*(col-1)+1:(patch_size-overlap)*(col-1)+patch_size,:);
                cur_block = reshape(cur_block,patch_size*patch_size,1,input_texture_dim);
                cor_error = patches - repmat(cur_block,1,num_patches);
                
                overlap_error1 = patches(1:patch_size*overlap,:,:)-repmat(left_block(size(patches,1)-overlap*patch_size+1:size(patches,1),:,:),1,num_patches);
                overlap_error1 = sum(sum(overlap_error1.^2,1),3);
                
                index = 1:patch_size*patch_size;
                mask_top_block = (patch_size-overlap <= mod(index-1,patch_size));
                mask_patches = (mod(index-1,patch_size) < overlap);
                %display(size(repmat(mask',1,num_patches,input_texture_dim)));\
                
                patches_masked = patches.*(repmat(mask_patches',1,num_patches,input_texture_dim));
                top_block_masked = top_block.*repmat(mask_top_block',1,1,input_texture_dim);
                top_block_masked_new = zeros(patch_size*overlap,1,3);
                patches_masked_new = zeros(patch_size*overlap,num_patches,3);

                top_block_masked_new(:,:,1)=nonzeros(top_block_masked(:,:,1));
                top_block_masked_new(:,:,2)=nonzeros(top_block_masked(:,:,2));
                top_block_masked_new(:,:,3)=nonzeros(top_block_masked(:,:,3));

                patches_masked_new(:,:,1) = reshape(nonzeros(patches_masked(:,:,1)), patch_size*overlap, num_patches);
                patches_masked_new(:,:,2) = reshape(nonzeros(patches_masked(:,:,2)), patch_size*overlap, num_patches);
                patches_masked_new(:,:,3) = reshape(nonzeros(patches_masked(:,:,3)), patch_size*overlap, num_patches);



                overlap_error2 = patches_masked_new-repmat(top_block_masked_new,1,num_patches);
                
                overlap_error2 = sum(sum(overlap_error2.^2,1),3);
                error1 = overlap_error1; 
                error2 = overlap_error2;                
                
                error = alph*(error1+error2)+(1-alph)*sum(sum(cor_error.^2,1),3);
                top_block = reshape(top_block,patch_size,patch_size,input_texture_dim);
                left_block = reshape(left_block,patch_size,patch_size,input_texture_dim);

                
            end
            if(row ~= 1 || col ~= 1)
                [min_error,~] = min(error);
                if(min_error == 0)
                    [min_error,~] = min(setdiff(error,0));
                end
                index = 1:num_patches;

                possible_blocks = (error < (1+tolerance)*min_error & error > 0).*index;
                possible_blocks(possible_blocks==0)=[];
                next_block_no = randi([1,size(possible_blocks,2)],1,1);
                fprintf('Row = %d, Col = %d, Patch No. = %d, No. of possible blocks = %d\n',row,col,possible_blocks(next_block_no(1)),size(possible_blocks,2));
                next_patch = patches_original(:,possible_blocks(next_block_no(1)),:);
                next_patch = reshape(next_patch,patch_size,patch_size,input_texture_dim);
                
                if(row == 1)
                    output_image(1:patch_size,(patch_size-overlap)*(col-1)+1:(patch_size-overlap)*(col-1)+patch_size,:)=cut(next_patch,left_block,0,overlap,'left');
                elseif(col==1)
                    output_image((patch_size-overlap)*(row-1)+1:(patch_size-overlap)*(row-1)+patch_size,1:patch_size,:)=cut(next_patch,0,top_block,overlap,'top');
                else
                    output_image((patch_size-overlap)*(row-1)+1:(patch_size-overlap)*(row-1)+patch_size,(patch_size-overlap)*(col-1)+1:(patch_size-overlap)*(col-1)+patch_size,:)=cut(next_patch,left_block,top_block,overlap,'both');
                end
            end
            
            
        end
    end
       
end

