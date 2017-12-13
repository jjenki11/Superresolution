close all;
clear all;

do_inspect =0;  % whether we want to display images for investigation

%   Initialize data and simulated images

% data = double(ReadData('Data2/lr_4/','shower_img_','.jpg'));% Read in the Low res data                        
% ref_img = imread('Data2/shower_img_ref.jpg');          % Read in the HR ref image

%   Initialize data and simulated images
data = double(ReadData('Data/','dwn_lr_','.png'));% Read in the Low res data                        
ref_img = imread('Data/ref_frame.png');          % Read in the HR ref image

ref_img_gray = double(rgb2gray((ref_img)));              % convert it to grayscale
[oy,ox] = size(ref_img_gray);                    % size of HR image
[dy,dx] = size(data(:,:,1));                     % size of LR image

%   Downsample HR image 
dsmpY = oy/dy; dsmpX = ox/dx;       % downsampling factor for HR given LR

% dsmpY = 4; dsmpX = 4;
downsampled_HR = ref_img_gray(1:dsmpY:oy, 1:dsmpX:ox); %downsample HR img
extended_sm_ref = (zeros(oy,ox));  %create blank img same size as HR
extended_sm_ref(1:dsmpY:oy, 1:dsmpX:ox) = downsampled_HR;%expand LR into it

%   Upsample it for comparison later
[resampled_hr,spc_x,spc_y] = ResampleImage(downsampled_HR, 1/dsmpY, 1/dsmpX, 'spline');

%   Check out some images
% if(do_inspect == 1)
%     figure(1),
%     imagesc(ref_img_gray), colormap 'gray';
%     figure(2),
%     imagesc(downsampled_HR), colormap 'gray';
%     figure(3),
%     imagesc(extended_sm_ref), colormap 'gray';
% end


%%   TBD - Weighted Nearest Neighbor Algorithm Steps

%   1) Read in the vector containing th shifts calculated by the reg
%   algorithm
[x_shifts, y_shifts,warped] = FindShifts(   double(downsampled_HR), ...
                                            double(data));

%   2) Determine each frame's position relative to the HR grid points
[XI,YI] = meshgrid(1:1/dsmpX:dx+1, 1:1/dsmpY:dy+1); % high res grid points
XI= XI(1:end-1,1:end-1); YI = YI(1:end-1,1:end-1);

ext_lr = uint8(zeros(oy,ox));  %create blank img same size as HR

shifts(:,:,1) = x_shifts/spc_x;
shifts(:,:,2) = y_shifts/spc_y;




% figure(100),
% imagesc(double(extended_sm_ref/max(extended_sm_ref(:)))), colormap 'gray'
% pause;

%   Cast the low res image into the high res grid
    %   TBD - what does he mean by position relative to?  Is this for
    %         each grid point in the HR image being compared to each 
    %         pixel in the low res version?  Do we need to make a seperate
    %         grid for the low res version?  Does the relative position
    %         represent a displacement (quiver plot)?

%   3) Round each position to the nearest HR grid point

    %   TBD - assuming that our position is in the HR grid space, what
    %         is the procedure to iterate through each grid point?
    
[xformed_data, combined_img] = TransformImages(data, shifts, dsmpY, dsmpX, oy, ox, spc_x, spc_y);

figure(99),
imagesc(combined_img/max(combined_img(:)) + double(extended_sm_ref/max(extended_sm_ref(:)))), colormap 'gray'
       

%   4) Rank frames from closest to farthest from the HR grid point

    %   TBD - this should be relatively straight forward.  I am passing
    %         three results out of 'FindShifts'.  I think we could
    %         construct a 1d euclidean distance vector by computing 
    %         sqrt((x_shifts(i) - Hr_x).^2 + (y_shifts(i) - Hr_y).^2) for
    %         each shift value.  then, we can sort this distance vector
    %         smallest to largest and maintain a reference to the indices
    %         Then, we can use this sorted array of indices in step 5
    

%   5) Form weights for each of the 3 nearest frames and sum the weights
    
    %   TBD - Take the sorted index array from step 4 and take the first 3
    %         indices of the 'warped' array, the last result of FindShifts.
    %         I didn't see any weights specifically defined in the paper, 
    %         but we could use normalized cross correlation as a
    %         coefficient (value between -1 and 1), or we could use a
    %         simple normalization based on the sum of the closest 3
    %         distances.  I think this will depend on what the weights
    %         need to come from.

%   6) Sum the 3 nearest frames and divide by the total weight

    %   TBD - Should be very straight forward once we have determined how
    %         he wants us to calculate the weights.  I am not sure how this
    %         weighted average actually gets applied to the HR grid at the
    %         end... Do we keep accumulating values into the 'black spots'
    %         from ALL low res images? Do we replace the value in each
    %         pixel if it is more similar?  Again, the assignment is not
    %         too clear here.
    
    

%%  After all of this is done, (TBD by Thursday night hopefully!! help!)
%   we can start on the rotation part, which we should hopefully have a
%   handle on algorithmically.  It is my hope that we will have some useful
%   functions that the rotation math can make use of.  It would be nice to
%   show how we are able to generalize the functions we are using for these 
%   as it is my opinion that this shows mastery of the algorithms.
    


%%  TBD some inspection stuff...
if(do_inspect == 1)
    lr_index = 5;
    resampled_low = ResampleImage(uint8(warped(:,:,lr_index)), 1/dsmpY, 1/dsmpX, 'spline');
    trans_img = imtranslate(uint8(warped(:,:,lr_index)),[-x_shifts(1,lr_index), -y_shifts(1,lr_index)],'FillValues',0);
    figure(4), imagesc(downsampled_HR);
    %   Hard to tell which is better... 
    figure(5), imagesc(warped(:,:,lr_index));
    figure(6), imagesc((uint8(warped(:,:,lr_index)) - downsampled_HR));
    %   Between these results...
    figure(7), imagesc((trans_img));
    figure(8), imagesc(((trans_img) - downsampled_HR));    
end
