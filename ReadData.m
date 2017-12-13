


function [imgs] = ReadData(folder, prefix, type)

    filename_0= strcat(folder,prefix);
    
    imgs = [];
    
    
    for i=1:16
        filename_1 = strcat(filename_0, int2str(i));
        filename_2 = strcat(filename_1, type);
        imgs(:,:,i) = uint8(imread(filename_2));
        
        
    end

    
    
% 
%     for i=1:16
%         clf;
%         figure(1),
%         imagesc(imgs(:,:,i));
%         pause(1/7);
%     end


end