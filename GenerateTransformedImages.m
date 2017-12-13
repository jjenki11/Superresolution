
function [out_imgs] = GenerateTransformedImages(in_img, rots, x_sh, y_sh, ds_fa, pad)

    %   accepts a single image as reference and shifts & rotates it based
    %   on input vectors then downsamples & returns them        
%     pd=250;    
    Ip = double(rgb2gray(imread(in_img)));      
    im1 = padarray(Ip, pad,'both');
    im1a = padarray(im1',pad);
    Ip=im1a';
    iters = max(size(rots));
    
    out_imgs=[];
    formatSpec = 'Processing image %d of %d.';
    for i=1:2%iters
        clc
        fprintf(formatSpec,i,iters);
        Ir = imrotate(Ip, rots(1,i),'bicubic','crop');
        It = circshift(Ir, [x_sh(1,i), y_sh(1,i)]);        
        h = 1/ds_fa*ones(ds_fa,1);
        H = h*h';
        Ids = filter2(H,It);
%         out_imgs(:,:,i) = AverageBlocksInImage(Ids(pd:end-pd, pd:end-pd), ds_fa);        
        out_imgs(:,:,i) = AverageBlocksInImage(Ids, ds_fa);        
    end
    clc;
    fprintf('\nDone...\n\n');
end