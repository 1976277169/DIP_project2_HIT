%Name: HSV feature�� extraction
%Function: Extract ROI feature from HSV images
%Author:    Changle Zhang, zhangchanglehit@163.com
clc;
clear all;
close all;
%Initilization

pathname='E:\Pro2_15S158746_�ų���\Fruit Samples For Project2\ѩɽ��ƻ��';           %�޸��ļ�������
cd(pathname);

dirs=dir([,'*.jpg']);
dircell=struct2cell(dirs)';
filenames=dircell(:,1);
hsvmean=zeros(10,3);             %Ԥ����ƽ������
for number=1:10

rgbimg=imread(char(filenames(number)));
r=rgbimg(:,:,1);
g=rgbimg(:,:,2);
b=rgbimg(:,:,3);

grayimg=rgb2gray(rgbimg);

hsvimg=rgb2hsv(rgbimg);
H=hsvimg(:,:,1);
S=hsvimg(:,:,2);
V=hsvimg(:,:,3);


%rgb = imread('pears.png');%��ȡԭͼ��
I = S;%ת��Ϊ�Ҷ�ͼ��
hy = fspecial('sobel');%sobel����
hx = hy';
Iy = imfilter(double(I), hy, 'replicate');%�˲���y�����Ե
Ix = imfilter(double(I), hx, 'replicate');%�˲���x�����Ե
gradmag = sqrt(Ix.^2 + Iy.^2);%����
%3.�ֱ��ǰ���ͱ������б�ǣ�������ʹ����̬ѧ�ؽ�������ǰ��������б�ǣ�����ʹ�ÿ�������������֮�����ȥ��һЩ��С��Ŀ�ꡣ
se = strel('disk', 20);%Բ�νṹԪ��
Io = imopen(I, se);%��̬ѧ������
Ie = imerode(I, se);%��ͼ����и�ʴ
Iobr = imreconstruct(Ie, I);%��̬ѧ�ؽ�
Ioc = imclose(Io, se);%��̬ѧ�ز���
Iobrd = imdilate(Iobr, se);%��ͼ���������
Iobrcbr = imreconstruct(imcomplement(Iobrd), imcomplement(Iobr));%��̬ѧ�ؽ�
Iobrcbr = imcomplement(Iobrcbr);%ͼ����
bw = im2bw(Iobrcbr, graythresh(Iobrcbr));%ת��Ϊ��ֵͼ��
%figure;
%imshow(bw), %��ʾ��ֵͼ��
%title('Thresholded opening-closing by reconstruction')
bww=double(bw);
hsvimg(:,:,1)=bww.*hsvimg(:,:,1);
hsvimg(:,:,2)=bww.*hsvimg(:,:,2);
hsvimg(:,:,3)=bww.*hsvimg(:,:,3);
%figure;
%imshow(rgbimg);

imgsize=size(grayimg);
counter=0;
hsv=[0 0 0];
hsv=double(hsv);
for i=1:imgsize(1)
    for j=1:imgsize(2)
        if bww(i,j)>0
            hsv(1)=hsv(1)+double(hsvimg(i,j,1));
            hsv(2)=hsv(2)+double(hsvimg(i,j,2));
            hsv(3)=hsv(3)+double(hsvimg(i,j,3));
            counter=counter+1;
        end
    end
end
hsvmean(number,:)=hsv/counter;
end
allhsvmean=mean(hsvmean);
save('hsvmean.txt','hsvmean','-ascii');             %����ÿ��ͼ���ROI��hsv��ֵ������Ϣ
save('allhsvmean.txt','allhsvmean','-ascii');       %������������ROI hsv��ֵ������Ϣ
