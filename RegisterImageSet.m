% rigidly register all but the first one to the first one
function [out,Rest] = RegisterImageSet(imgs, thresh, pad) 
    [sy,sx,sz] = size(imgs);  out =[]; Rest =[];
    out(:,:,1) = imgs(:,:,1); Rest(:,:,1) = 0;
    for idx=2:(sz)      
        fprintf('\nRegistering image %d of %d.',idx,(sz));
       [Rest,res]=register_rotation(double(imgs(:,:,1)),double(imgs(:,:,idx)),thresh,pad);
       out(:,:,idx) = res;
       Rest(:,:,idx) = Rest;
    end
    fprintf('\nDone with image registration...\n\n');
end