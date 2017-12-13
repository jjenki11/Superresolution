im = 'Data2/shower_img_ref.jpg';

rots=[0,2,5,-3,6,0,7,-4,0,3];

sh_x=[2,8,1,5,0,-7,8,-5,-1,3];

sh_y=[0,4,-6,-2,0,-7,4,3,8,1];

ds_f=5;

testImages = GenerateTransformedImages(im, rots, sh_x, sh_y, ds_f);

