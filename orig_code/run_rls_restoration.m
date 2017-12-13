f=double(imread('cameraman.tif'));


psf = zeros(5,5)/25;
% psf
% pause
psf(1:4,1:4) = 1/ 16;


% psf = fspecial('gaussian',7,2);

% psf = ones(5,5)/25;

[psfy,psfx]=size(psf);
padx = (psfx-1)/2;
pady = (psfy-1)/2;

gobs = conv2( padarray(f,[pady,padx],'both','symmetric'),psf, 'valid' ) + randn(size(f))*1;

imagesc(gobs)
pause

[fest,cost]=rls_restoration(gobs,psf,.001,50);


figure
subplot(221)
plot(cost)
xlabel('Iteration');
ylabel('Cost');
title('Cost Function');
subplot(222)
im(f,0)
title('Ideal')
subplot(223)
im(gobs,0)
title('Observed')
subplot(224)
im(fest,0)
title('RLS Estimate');

