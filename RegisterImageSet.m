% rigidly register all but the first one to the first one
function [out] = RegisterImageSet(imgs, thresh, pad) 
    [sy,sx,sz] = size(imgs);  out =[];
    out(:,:,1) = imgs(:,:,1);
    for idx=1:(sz-1)      
        fprintf('\n\nRegistering image %d of %d.',idx,(sz-1));
       [Rest,res]=register_rotation(imgs(:,:,1),imgs(:,:,idx+1),thresh,pad);
       out(:,:,idx+1) = res;
    end
    fprintf('\nDone with image registration...\n\n');
end