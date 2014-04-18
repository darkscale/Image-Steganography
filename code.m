clc;
clear;
[X Y]=uigetfile('*.jpg;*.png;*.ppm;*.tif;*.tiff');
file=fullfile( Y,X);
carrier_in=imread(file);
[X Y]=uigetfile('*.jpg;*.png;*.ppm;*.tif;*.tiff,*.bmp');
file=fullfile(Y,X);
data_in=imread(file);



%      Preprocessing

% converting carrier image to rgb if image is grayscale 
if ndims(carrier_in)==2
    carrier_in= cat(3,carrier_in,carrier_in,carrier_in);
end

% converting data image to gray if image is rgb
if ndims(data_in)==3    
    disp('data image is colourful, converting the image to graysacale');
    data_in=rgb2gray(data_in);
end

s2=size(data_in);
s=size(carrier_in);

%compressing image if data image is bigger than carrier image
ratio=1.0;
if ratio > s(1)/s2(1)
    ratio=s(1)/s2(1)-0.01;    
end
if ratio > s(2)/s2(2)
    ratio=s(2)/s2(2)-0.01;
end

if ratio < 1.0
    disp('data image size is bigger than carrier image size, therefore adjusting the size of data image');
    data_in=imresize(data_in,ratio);
    s2=size(data_in);
end






% encrypting the data iamge in carrier image
carrier_out=carrier_in;
for i=1:s(1)
    for j=1:s(2)
        if i<s2(1) && j<s2(2)
            val=data_in(i,j);
        else
            val=0;
        end
            val = val - mod(val,4);
            val=fix(val/4);
            carrier_out(i,j,3)=carrier_in(i,j,3) - mod(carrier_in(i,j,3),4) + mod(val,4);
            val = val - mod(val,4);
            val=fix(val/4);
            carrier_out(i,j,2)=carrier_in(i,j,2) - mod(carrier_in(i,j,2),4) + mod(val,4);
            val = val - mod(val,4);
            val=fix(val/4);
            carrier_out(i,j,1)=carrier_in(i,j,1) - mod(carrier_in(i,j,1),4) + mod(val,4);
    end
end




% decrypting the data image from original image
data_out=rgb2gray(carrier_out);
row=0;
col=0;
for i=1:s(1)
    for j=1:s(2)
        val=0;
        val = val + (mod(carrier_out(i,j,1),4));
        val=val*4;
        val = val + (mod(carrier_out(i,j,2),4));
        val=val*4;
        val = val + (mod(carrier_out(i,j,3),4));
        data_out(i,j)=val*4;
        if data_out(i,j) >0
            if i>row
                row=i;
            end
            if j>col
                col=j;
            end
        end
    end
end

% cropping unnecessary part from data image 
data_out=imcrop(data_out,[0,0,col,row]);


imwrite(carrier_in,'carrier_in.png');
imwrite(data_in,'data_in.png');
imwrite(carrier_out,'carrier_out.png');
imwrite(data_out,'data_out.png');

figure(1);imshow(carrier_in);
figure(2);imshow(data_in);
figure(3);imshow(carrier_out);
figure(4);imshow(data_out);
