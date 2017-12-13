function [xV, yV, warped] = FindShifts(ref_img, shift_data)
    [~,~,sz] = size(shift_data);
    xV = [];
    yV = [];    
%     thresh = 1.4;
%     pad = 20;
    thresh = .1;
    pad = 4;
    warped=[];
    for i=1:sz        
        [S,ww] = register_shift(ref_img, shift_data(:,:,i), thresh, pad);
        warped(:,:,i) = ww;
        xV = [xV, S(1,1)];
        yV = [yV, S(2,1)];    
    end
end