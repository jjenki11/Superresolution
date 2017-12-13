function [new_data,combined_img] = TransformSingleImage(data, shift, dsmpY, dsmpX, ry, rx, sy, sx)
    %   expand each image and shift them, put into a vector
    [~,~,sz] = size(data);
    new_data = (zeros(ry,rx,sz));    
    tmp = new_data(:,:,1);
    combined_img = tmp;    
    tmp(1:dsmpY:ry, 1:dsmpX:rx) = data(:,:);        
    nearest_x = round(shift(1,2));
    nearest_y = round(shift(1,1));    
    X = circshift(tmp,[nearest_x, nearest_y]);
    new_data(:,:) = X;
    combined_img = combined_img + new_data(:,:);    
    figure(100),        
    imagesc(combined_img),colormap 'gray';
    pause
end