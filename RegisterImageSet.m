% rigidly register all but the first one to the first one
function [out,Rest] = RegisterImageSet(imgs, thresh, pad) 
    [sy,sx,sz] = size(imgs);  out =[]; Rest =[];
    out(:,:,1) = imgs(:,:,1); Rest(:,:,1) = 0;
    hb = waitbar(0,'Please wait... Registering images');
    for idx=2:(sz)      
        fprintf('\nRegistering image %d of %d.',idx,(sz));
       [Rest,res]=register_rotation(double(imgs(:,:,1)),double(imgs(:,:,idx)),thresh,pad);
       out(:,:,idx) = res;
       Rest(:,:,idx) = Rest;
       waitbar(idx/sz,hb);
    end
    pause(1/20);
    delete(hb);
    fprintf('\nDone with image registration...\n\n');
end