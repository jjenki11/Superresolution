function [ superres, cost ] = rls_restoration( gobs, alpha, num_its, us_factor, g_truth, Rvecs )
%
% [ fest, cost ] = rls_restoration( gobs, psf, alpha, num_its )
%
% Regularized least squares image restoration
%
% fest		Restored image
% cost		Cost function vs. iterations so you can track convergence
%
% gobs		Observed image
% psf       2D FIR impulse repsonse (odd dimensions)
%
% alpha     The amount of regularization (suggested range 0-1)
%		    0 = no regularization = maximum likelihood
%		    1 = lots of regularization = smooth estimate
%
% num_its   Number of iterations to perform (suggested range 10-100)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   TBD unused...

blur = [0 1 0;...
        1 2 1;...
        0 1 0];
blur = blur / sum(blur(:));

sharpen = [0 -0.25 0;...
          -0.25 2 -0.25;...
           0 -0.25 0];

% reg_imgs = gobs(:,:,2:end);
[ry,rx,rz]=size(gobs);

% interpoloate to hi res
[oy,ox]= size(gobs(:,:,1));

[Xx,Yy] = meshgrid([1:ox],[1:oy]);
XI = linspace(1,(ox), us_factor*(ox));
YI = linspace(1,(oy), us_factor*(oy))';

%------------------%
% initial estimate %
%------------------%
[ygt,xgt] = size(g_truth);

XXI=linspace(1,ox, xgt);
YYI=linspace(1,oy, ygt)';

% Create initial image estimate out of first image in set
up_guess = interp2(Xx,Yy, gobs(:,:,1), XXI,YYI, 'bil');
% up_guess = conv2( padarray(ug,[BPy,BPx],'both','symmetric'),blur, 'valid' );

% fest=up_guess;

SR_IMG = up_guess;

min_gt = min(g_truth(:));
max_gt = max(g_truth(:));

% [ygt,xgt]=size(g_truth);

imOrigBig = imresize(gobs(:,:,1), [ygt,xgt], 'bilinear');

% imOrigBig = imresize(gobs(:,:,1), us_factor, 'bilinear');

size(imOrigBig)
pause
X=imOrigBig;
X_prev = X;
E = [];

max_iter = num_its;
iter = 1;

while iter < max_iter
%     waitbar(min(10*iter/max_iter, 1), wait_handle);
    % Compute the gradient of the total squared error of reassembling the HR
    % image:
    %iter
    % -----------------------------
    G = zeros(size(X));
    for i=1:length(max(Rvecs))
        
        xshift = Rvecs(1,1,i); yshift=Rvecs(2,1,i); rot=Rvecs(3,1,i);
        
        temp = imtranslate(X, -[(us_factor * xshift), (us_factor * yshift)]);
        size(temp)
        pause;
        temp = imrotate(temp, rot, 'bilinear', 'crop');
        
        %temp = PSF * temp;
        temp = imfilter(temp, blur, 'symmetric', 'same');
        
        temp = temp(1:us_factor:end, 1:us_factor:end);
        size(temp)
        pause;
%         size(temp)
%         size(gobs(:,:,i))
%         pause
        size(gobs(:,:,i))
        pause;
        temp = temp - gobs(:,:,i);
        temp = imresize(temp, us_factor, 'box');
        
        %temp = PSF' * temp;
        temp = imfilter(temp, sharpen, 'symmetric', 'same');
        
        temp = imrotate(temp, -rot, 'bilinear', 'crop');
        G = G + imtranslate(temp, [(us_factor * xshift), (us_factor * yshift)]);
    end

    % Now that we have the gradient, we will go in its direction with a step
    % size of lambda
    X = X - (alpha) * G;   
    %max(X(:))
    %max(G(:))
    X = X / max(X(:));
    delta = norm(X-X_prev)/norm(X);
    E=[E; iter delta];
    cost(iter) = delta;
    if iter>3 
      if abs(E(iter-3,2)-delta) <1e-4
         break  
      end
    end
    X_prev = X;
    iter = iter+1;
end

SR_IMG = X;

bilin = up_guess;

superres = SR_IMG;

figure(122),
imagesc(g_truth), colormap 'gray'
figure(123),
imagesc(bilin), colormap 'gray'
figure(124),
imagesc(superres), colormap 'gray'
