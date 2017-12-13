%   Testing register_rotation
close all;
% clear all;

disp('now doing dataset 1...')

% im = 'Data2/shower_img_ref.jpg';
im = 'peppers.png';
orig_img = double(rgb2gray(imread(im)));
% orig_img = double(imread(im));
%   20 seperate images constructed with the following rot,shift(x,y) vals
rots=[0,2,5,-3,6,0,7,-4,0,3,1,-1,-5,2,0,-2,-6,3,-9,0];
sh_x=[2,8,1,5,0,-7,8,-5,-1,3,0,4,-6,-2,0,-7,4,3,8,1];
sh_y=[0,4,-6,-2,0,-7,4,3,8,1,2,8,1,5,0,-7,8,-5,-1,3,];

% downsampling factor
ds_f=5;
% border padding in generated images (optional)
pad=0;

% testImages = GenerateTransformedImages(im, rots, sh_x, sh_y, ds_f,pad);
% [registered_set, r_vecs] = RegisterImageSet(testImages, .1, 10);

% gobs will be all images put together
gobs=registered_set;

%   seperate from registration
[SR_Img,cost]=rls_restoration(gobs,.00001,100,ds_f,orig_img,r_vecs);
% 
% 

% unknown shift...
orig_img = circshift(orig_img, [0,-2]);
SR_Img = circshift(SR_Img, [-5,-4]);

figure
subplot(221)
plot(cost)
xlabel('Iteration');
ylabel('Cost');
title('Cost Function');
subplot(222)
imagesc(imresize(gobs(:,:,1), size(orig_img), 'box')), colormap 'gray'
title('Ideal')
subplot(223)
imagesc(gobs(:,:,1)), colormap 'gray'
title('Observed')
subplot(224)
imagesc(SR_Img), colormap 'gray'
title('Superresolution Image');






