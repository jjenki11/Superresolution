function [new_data,combined_img] = TransformImages(data, shifts, dsmpY, dsmpX, ry, rx, sy, sx)
    %   expand each image and shift them, put into a vector
    [~,~,sz] = size(data);
    new_data = (zeros(ry,rx,sz));    
    tmp = new_data(:,:,1);
    combined_img = tmp;    
    for i=1:sz
        tmp(1:dsmpY:ry, 1:dsmpX:rx) = data(:,:,i);        
        nearest_x = round(shifts(1,i,2));%/sx);
        nearest_y = round(shifts(1,i,1));%/sy);        
        X = circshift(tmp,[nearest_x, nearest_y]);
        new_data(:,:,i) = X;
        combined_img = combined_img + new_data(:,:,i);
    end
    figure(100),        
    imagesc(combined_img),colormap 'gray';
    pause
end