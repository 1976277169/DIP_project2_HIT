%Name: ROI extraction
%Function: Extract ROI in a RGB image
%Author:    Changle Zhang, zhangchanglehit@163.com
clc;
clear all;
close all;
%Initilization
path=('E:\cl\DIP\Pro2_15S158746_�ų���\Pro2_15S158746_�ų���\testsample\G5');
cd(path);
dirs=dir;
dircell=struct2cell(dirs)';
filenames=dircell(3:23,1);
for num=1:20
    picname=char(filenames(num));
    picsavename=['Seg' picname];
    rgbimg=imread(picname);
    %rgbimg=imread('Fruit Samples For Project2/��ʯ��/��ʯ��_image119.jpg');
    
    %figure;
    %imshow(rgbimg);
    r=rgbimg(:,:,1);
    g=rgbimg(:,:,2);
    b=rgbimg(:,:,3);
    % imshow(r);
    % figure;
    % imshow(g);
    % figure;
    % imshow(b);
    grayimg=rgb2gray(rgbimg);
    % imshow(grayimg);
    hsvimg=rgb2hsv(rgbimg);
    H=hsvimg(:,:,1);
    S=hsvimg(:,:,2);
    V=hsvimg(:,:,3);
    % figure;
    % imshow(H);
    % title('H');
    % figure;
    % imshow(S);
    % title('S');
    % figure;
    % imshow(V);
    % title('V');
    
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
    bww=im2uint8(bw)/255;
    rgbimg(:,:,1)=bww.*rgbimg(:,:,1);
    rgbimg(:,:,2)=bww.*rgbimg(:,:,2);
    rgbimg(:,:,3)=bww.*rgbimg(:,:,3);
    %figure;
    %imshow(rgbimg);
    
    imgsize=size(grayimg);
    %�б߽�
    for i = 1:imgsize(1)
        sumrow(i)=sum(bww(i,:));
    end
    %�б߽�
    for j = 1:imgsize(2)
        sumcol(j)=sum(bww(:,j));
    end
    for x=1:imgsize(1)
        if sumrow(x)>0
            Seg(x,:,1)=rgbimg(x,:,1);
            Seg(x,:,2)=rgbimg(x,:,2);
            Seg(x,:,3)=rgbimg(x,:,3);
        end
    end
    counter=1;
    for y=1:imgsize(2)
        if sumcol(y)>0
            Seg1(:,counter,1)=Seg(:,y,1);
            Seg1(:,counter,2)=Seg(:,y,2);
            Seg1(:,counter,3)=Seg(:,y,3);
            counter=counter+1;
        end
    end
    %imshow(Seg1);
    imwrite(Seg1,picsavename,'jpg');
    cd(path)
end
