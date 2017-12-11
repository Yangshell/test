for xuhao=21:21;
str=strcat(int2str(xuhao),'_training.tif');
A=imread(str);
A(:,:,2) = A(:,:,2);
A(:,:,1) = 0;
A(:,:,3) = 0;
A= rgb2gray(A);
%figure,imshow(A);
minconsize=7;
maxconsize=10;
for consize=minconsize:maxconsize
angle_t=12;
SUM=0;
for i=1:angle_t
    B{i}=strel('line',consize,180/angle_t*(i-1));
    E{i}=imopen(A,B{i});
    F{i}=imclose(A,B{i});
    %G{i}=F{i}-E{i};
    G{i}=F{i}-A;
    %figure,imshow(E{i});
    SUM=SUM+G{i}/12;
end
SUM=imadjust(SUM,[0 0.1],[0 1]);
%figure,imshow(SUM);
[SUMsizex,SUMsizey]=size(SUM);
for i=1:SUMsizex
    for j=1:SUMsizey
        if SUM(i,j)<5
            SUM(i,j)=255;
        else
            SUM(i,j)=0;
        end
    end
end
sum{consize}=255-SUM;
%figure,imshow(SUM);
%imwrite(SUM,strcat(int2str(xuhao),'-',int2str(consize),'血管','.jpg'));
end
img2=0;
img2=logical(img2);
for consize=minconsize:maxconsize
imlabel=bwlabel(sum{consize});
stats=regionprops(imlabel,'Area');
area=cat(1,stats.Area);
index=find(area<30);
img=ismember(imlabel,index);
%figure,imshow(img);
%imwrite(255-255*img,strcat(int2str(xuhao),'-',int2str(consize),'噪点','.jpg'));
se=strel('disk',2);
img=imdilate(img,se)+img2;
%imwrite(255-255*img,strcat(int2str(xuhao),'-',int2str(consize),'噪点膨胀','.jpg'));
%figure,imshow(img);
%figure,imshow(sum{consize});
if consize<maxconsize
sum{consize+1}=sum{consize+1}-uint8(255*img);
%imwrite(255-sum{consize+1},strcat(int2str(xuhao),'-',int2str(consize+1),'血管减并集','.jpg'));
%figure,imshow(sum{consize+1});
end
img2=img;
end
%figure,imshow(sum{consize});
%imwrite(255-sum{consize},strcat(int2str(xuhao),'-',int2str(consize),'血管减并集','.jpg'));
SUM=sum{consize};
imlabel=bwlabel(SUM);
stats=regionprops(imlabel,'Area');
area=cat(1,stats.Area);
index=find(area>200);
img=ismember(imlabel,index);
figure,imshow(img);
%imwrite(255-255*img,strcat(int2str(xuhao),'-最终结果','.jpg'));
end