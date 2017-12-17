close all;
clear all;

do_inspect =0;  % whether we want to display images for investigation

%   Initialize data and simulated images

%   Initialize data and simulated images
data = double(ReadData('Data/Car_Controlled_microscanning/','dwn_lr_','.png'));% Read in the Low res data                        
ref_img = imread('Data/Car_Controlled_microscanning/ref_frame.png');          % Read in the HR ref image

[aa,bb,cc] = size(data);

for idx=1:cc
   figure(999),
   imagesc(data(:,:,idx)),colormap 'gray';
   pause(1/7);    
end

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


[x_shifts, y_shifts,warped] = FindShifts(   double(downsampled_HR), ...
                                            double(data));

%   2) Determine each frame's position relative to the HR grid points
[XI,YI] = meshgrid(1:1/dsmpX:dx+1, 1:1/dsmpY:dy+1); % high res grid points
XI= XI(1:end-1,1:end-1); YI = YI(1:end-1,1:end-1);

ext_lr = uint8(zeros(oy,ox));  %create blank img same size as HR

shifts(:,:,1) = x_shifts/spc_x;
shifts(:,:,2) = y_shifts/spc_y;
    
[xformed_data, combined_img] = TransformImages(data, shifts, dsmpY, dsmpX, oy, ox, spc_x, spc_y);

figure(99),
imagesc(combined_img/max(combined_img(:)) + double(extended_sm_ref/max(extended_sm_ref(:)))), colormap 'gray'
       
%fill in holes
% combined_img(find(combined_img(:,:) == 0)) = mean(combined_img(:));

figure,
imagesc(medfilt2(combined_img)), colormap 'gray'

srd = dif2(double(rgb2gray(ref_img)), medfilt2(combined_img));
[oy,ox] = size(rgb2gray(ref_img));
ideal = imresize(downsampled_HR, [oy,ox]);

idealDiff = dif2(double(rgb2gray(ref_img)), ideal);


srd.mae
idealDiff.mae

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
