%   accepts a single image as reference and shifts & rotates it based
%   on input vectors then downsamples & returns them
function [out]=GenerateTransformedImages(in,rots,x_sh,y_sh,ds_fa,pad)  
    x=imread(in);
    [~,~,dim]=size(x); 
    if(dim ==3)
        Ip=padarray(padarray(double(rgb2gray(x)),pad,'both')',pad,'both')';
    
    elseif(dim ==1)
        Ip=padarray(padarray(double((x)),pad,'both')',pad,'both')';
        figure,
        imagesc(Ip);
        pause
%         Ip=padarray(padarray(double((imread(in))),pad,'both')',pad,'both')';
%         Ip = double((imread(in)));
    end
    iters = max(size(rots));  out=[];
    fprintf('Starting Image generation... (%d)\n',iters);
    for i=1:iters
        fprintf('Generating image %d of %d.\n',i,iters);
        h= 1/ds_fa*ones(1,ds_fa);        
        out(:,:,i) = imresize(imtranslate(imrotate(Ip,rots(1,i),'bilinear','crop'),...
                  [x_sh(1,i),y_sh(1,i)]), size(Ip)/ds_fa, 'box',{ds_fa, ds_fa});
%         out(:,:,i) = AverageBlocksInImage(...
%         filter2(h*h',imtranslate(imrotate(Ip,rots(1,i),'bilinear','crop'),...
%                   [x_sh(1,i),y_sh(1,i)])), ds_fa);        
    end
    fprintf('\nDone with image generation...\n\n');
end