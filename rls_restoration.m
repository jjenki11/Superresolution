function [ fest, cost ] = rls_restoration( gobs, alpha, num_its, us_factor, padding, new_sz )
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
% Author: Dr. Russell C. Hardie
% University of Dayton

% [lrsy,lrsx] = size(g_obs);

% gobs = g_obs(padding:(lrsy+1)-padding, padding:(lrsx+1)-padding);

figure,
imagesc(gobs)
pause;

% size of image
[lrsy,lrsx] = size(gobs);

psf = zeros(5,5)/25;
psf(1:4,1:4) = 1/ 16;

% Get size info about the system psf
[psfy,psfx] = size(psf);

% Determine the required border padding when using psf.
BPy = (psfy-1)/2;
BPx = (psfx-1)/2;

% flip PSF for correlation
psf_flip = fliplr( flipud( psf ) );

%--------------------------------%
% Define all convolution kernels %
%--------------------------------%

% Generate the regularization kernel used to evaluate the
% image smoothness. It produces the difference between each center
% sample and the average of its cardinal neighbors.
lap = [0   -1/4 0
      -1/4  1  -1/4
       0   -1/4 0];

% Define the gradient kernel for regularization
% Note: lap_lap = conv2(lap,lap) = xcorr2(lap,lap)
lap_lap = [0     0    1/16 0   0
           0     1/8 -1/2  1/8 0
           1/16 -1/2  5/4 -1/2 1/16
           0     1/8 -1/2  1/8 0
           0     0    1/16 0   0];

% interpoloate to hi res
[oy,ox]= size(gobs);

figure,
imagesc(gobs);


[X,Y] = meshgrid([1:ox],[1:oy]);

% size([X,Y])
XI = linspace(1,ox, us_factor*oy);
% XI = [1:new_sz(1,1)];
% pause
YI = linspace(1,oy, us_factor*ox)';
% YI = [1:new_sz(1,2)]';


size(XI)
size(YI)
% size([XI';YI])
pause;
% pause
%------------------%
% initial estimate %
%------------------%

% Create initial image estimate
fest = interp2(X,Y, gobs, XI,YI, 'bil');

figure,
imagesc(fest)
pause;
%-------------------------------------%
% Begin iterations to update estimate %
%-------------------------------------%

for k = 1 : num_its
    
    disp(['***Beginning iteration ' int2str(k)])

    %----------------------------%
    % Put estimate through model %
    %----------------------------%

    % Current estimate put through model (estimated gobs data)
%     gest = conv2(padarray(fest,[BPy,BPx],'both','symmetric'),psf,'valid');
    
    % Compute the error image
%     error = gest - gobs;
    
    % Compute roughness of current estimate
    fest_lap = conv2(padarray(fest,[1,1],'both','symmetric'),lap,'valid');
    
    % cost(k) = 1/2 * 
    %   loop over every pixel in all images 
    %       take current estimated image (hr bilinear interpolated 1st
    %       image) and apply weights (after rot and trans the weights are all 1, then
    %       perform AverageBlocksInImage 
    
    %   z is current estimate (fest)
    
    % Compute the cost for this iteration
    cost(k) = sum(error(:).^2) + alpha*sum(fest_lap(:).^2);

    %------------------%
    % Compute gradient %
    %------------------%
        
    % There are two terms to the gradient:
    % 1.)  The linear equation gradient  (grad1)
    % 2.)  The regularization (smoothness) gradient (grad2).

    % Correlate error with PSF
    grad1 = conv2(padarray(error,[BPy,BPx],'both','symmetric'),...
        psf_flip,'valid');

    % Compute the regularization gradient part
    grad2 = conv2(padarray(fest,[2,2],'both','symmetric'),lap_lap,'valid');

    % Total gradient
    grad = grad1 + alpha*grad2;

    %-----------------------------%
    % Determine optimal step size %
    %-----------------------------%
    
    % Gradient through model
    gamma = conv2(padarray(grad,[BPy,BPx],'both','symmetric'),psf,'valid');
     
    part1 = sum(gamma(:).*error(:));
    part2 = sum(gamma(:).^2);

    % Roughness of gradient
    gbar = conv2(padarray(grad,[1,1],'both','symmetric'),lap,'valid');
    
    part3 = alpha*sum(fest_lap(:).*gbar(:));
    part4 = alpha*sum(gbar(:).^2);
    
    % Step size
    epsilon = (part1+part3)/(part2+part4);

    %-----------------------%
    % Update image estimate %
    %-----------------------%
        
    fest = fest - epsilon*(grad);
    
end
