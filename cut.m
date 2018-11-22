function [output,line] = cut(block,left_block,top_block,overlap,type)

%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    patch_size = size(block,1);
    output = zeros(patch_size,patch_size,size(block,3));
    if(strcmp(type,'left')==1)
        
        output(:,overlap+1:patch_size,:)=block(:,overlap+1:patch_size,:);
        error_surface = block(:,1:overlap,:)-left_block(:,patch_size-overlap+1:patch_size,:);
        error_surface = sum(error_surface.^2,3);
        line = zeros(1,patch_size);
        E = zeros(patch_size,overlap);
        
        E(1,:) = error_surface(1,:);
       
        for i=2:patch_size
            for j=1:overlap
                if(j==1)
                    E(i,j) = error_surface(i,j)+min(E(i-1,j),E(i-1,j+1));
                elseif(j==overlap)
                    E(i,j) = error_surface(i,j)+min(E(i-1,j-1),E(i-1,j));
                else
                    E(i,j) = error_surface(i,j)+min(E(i-1,j-1),min(E(i-1,j),E(i-1,j+1)));
                end
            end
        end
        [~,index]=min(E(patch_size,:));
        line(patch_size) = index;
        for i = 1:patch_size-1
            j=patch_size-i;
            if(line(j+1)==1)
                [~,ind] = min([E(j,line(j+1)),E(j,line(j+1)+1)]);
                if(ind==1)
                    index=line(j+1);
                else
                    index = line(j+1)+1;
                end
            elseif(line(j+1)==overlap)    
                [~,ind] = min([E(j,line(j+1)-1),E(j,line(j+1))]);
                if(ind==1)
                    index=line(j+1)-1;
                else
                    index = line(j+1);
                end
            else
                [~,ind] = min([E(j,line(j+1)-1),E(j,line(j+1)),E(j,line(j+1)+1)]);
                if(ind==1)
                    index=line(j+1)-1;
                elseif(ind==2)
                    index=line(j+1);
                else
                    index = line(j+1)+1;
                end
            end
            line(j)=index;
        end
        overlapping_region=zeros(patch_size,overlap,size(block,3));
        for i=1:patch_size
            for j=1:overlap
                if(j<line(i))
                    overlapping_region(i,j,:)=left_block(i,patch_size-overlap+j,:);
                else
                    overlapping_region(i,j,:)=block(i,j,:);
                end
            end
        end
        output(:,1:overlap,:)=overlapping_region;
        return;
        
        
        
    elseif(strcmp(type,'top')==1)
        %display(size(cat(3,block(:,:,1)', block(:,:,2)', block(:,:,3)')));
        
        [output,line] = cut(cat(3,block(:,:,1)', block(:,:,2)', block(:,:,3)'),cat(3,top_block(:,:,1)', top_block(:,:,2)',top_block(:,:,3)'),0,overlap,'left');
        %display(size(output));
        output=cat(3,output(:,:,1)',output(:,:,2)',output(:,:,3)');
        line=fliplr(line);
        return;
    elseif(strcmp(type,'both')==1)
        [vert_output,vert_line] = cut(block,left_block,0,overlap,'left');
        [horz_output,horz_line] = cut(block,0,top_block,overlap,'top');
        output(overlap+1:patch_size,overlap+1:patch_size,:)=block(overlap+1:patch_size,overlap+1:patch_size,:);
        output(overlap+1:patch_size,1:overlap,:)=vert_output(overlap+1:patch_size,1:overlap,:);
        output(1:overlap,overlap+1:patch_size,:)=horz_output(1:overlap,overlap+1:patch_size,:);
        for i=1:overlap
            for j=1:overlap
                if(j>=vert_line(i) && i >= horz_line(j))
                    output(i,j,:)=block(i,j,:);
                elseif(j>=vert_line(i))
                    output(i,j,:)=0.5*(top_block(patch_size-overlap+i,j,:)+block(i,j,:));
                elseif(i>=horz_line(j))
                    output(i,j,:)=0.5*(left_block(i,patch_size-overlap+j,:)+block(i,j,:)); 
                else
                    output(i,j,:)=0.5*(top_block(patch_size-overlap+i,j,:)+left_block(i,patch_size-overlap+j,:));
                end
            end
        end
        line=0;
        return;
    end


end

