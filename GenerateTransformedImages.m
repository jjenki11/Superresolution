%   accepts a single image as reference and shifts & rotates it based
%   on input vectors then downsamples & returns them
function [out]=GenerateTransformedImages(in,rots,x_sh,y_sh,ds_fa,pad)    
    Ip=padarray(padarray(double(rgb2gray(imread(in))),pad,'both')',pad)';
    iters = max(size(rots));  out=[];
    for i=1:iters
        fprintf('Generating image %d of %d.\n',i,iters);
        out(:,:,i) = AverageBlocksInImage(...
        filter2(( 1/ds_fa*(ones(ds_fa,1)*ones(ds_fa,1)')),...
                  circshift(imrotate(Ip,rots(1,i),'bicubic','crop'),...
                  [x_sh(1,i),y_sh(1,i)])), ds_fa);        
    end
    fprintf('\nDone with image generation...\n\n');
end