%   accepts a single image as reference and shifts & rotates it based
%   on input vectors then downsamples & returns them
function [out]=GenerateTransformedImages(in,rots,x_sh,y_sh,ds_fa,pad)  
    Ip=padarray(padarray(in,pad,'both')',pad,'both')';
    
    iters = max(size(rots));  out=[];
    fprintf('Starting Image generation... (%d)\n',iters);
    hb = waitbar(0,'Please wait... Generating images');
    for i=1:iters
        fprintf('Generating image %d of %d.\n',i,iters);        
        h= 1/ds_fa*ones(1,ds_fa);        
        out(:,:,i) =imresize(imtranslate(imrotate(Ip,rots(1,i),'bilinear','crop'),...
                  [x_sh(1,i),y_sh(1,i)]), size(Ip)/ds_fa);  % 'box', {ds_fa, ds_fa}); %/ds_fa);
%         out(:,:,i) = AverageBlocksInImage(...
%         filter2(h*h',imtranslate(imrotate(Ip,rots(1,i),'bilinear','crop'),...
%                   [x_sh(1,i),y_sh(1,i)])), ds_fa);      
%               ds_fa
        figure(555),
        imagesc(out(:,:,i)), colormap 'gray'
        pause(1/10);
        waitbar(i/iters,hb);
    end
    pause(1/20);
    delete(hb);
    fprintf('\nDone with image generation...\n\n');
end