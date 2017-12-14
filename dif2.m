function error = dif2(in1,in2)
%
% MAE, MSE, PSNR, SNR and average error between two vectors/matrices
%
% error = dif(in1,in2)
%
% error.mae		Average absolute error
% error.mse		Average squared error
% error.psnr    Peak signal-to-noise ratio assuming in1 is signal
% error.snr		Signal-to-Noise ratio assuming in1 is signal
%		 and in2 is corrupted (  Note: SNR=variance(in1(:))/variance(error(:))  ).  
% error.avg     Error average so you can see if your estimate is biased.
%
% Author: Dr. Russell C. Hardie
% modfied dif.m 5/22/01
% modified 1/31/07

in1 = double(in1);
in2 = double(in2);

[m,n]=size(in1);
temp=in1-in2;
error.mae=mean(abs(temp(:)));
error.mse=mean(temp(:).^2);
error.psnr_dB=20*log10( max( in1(:) ) / sqrt( error.mse ) );
error.snr_dB=10*log10( var(in1(:)) / var(temp(:)) );
error.avg=mean(temp(:));

