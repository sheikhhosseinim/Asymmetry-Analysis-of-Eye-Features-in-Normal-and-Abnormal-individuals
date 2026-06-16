% img=imread('E:\PostDoctoral\Database\Selected Data\Normal\2\171_Layer_vesselmind_phasev\S171_fds_testing_0.png');

% folderpath='E:\PostDoctoral\Database\Selected Data\Normal\2\172_Layer_vesselmind_phasev';

function [thicknessL1,thicknessL2,thicknessL3,thicknessL4,thicknessL5,thicknessall,thicknessT]=layerBorder(folderpath)
%%
path=dir(folderpath);
for i=3:numel(path)
    name=path(i).name;
    tmp1=find(name=='_');
    idx1(i-2)=str2double(name(tmp1(end)+1:end-4));
end
name=name(1:tmp1(end));

thicknessL1=[];
thicknessL2=[];
thicknessL3=[];
thicknessL4=[];
thicknessL5=[];
thicknessall=[];


for idx=min(idx1):max(idx1)
    namei=strcat(folderpath,'\',name,num2str(idx),'.png');
    if exist(namei, 'file')

        img=(imread(namei));

        img1=rgb2ycbcr(img);
        L1=(img1(:,:,1)==81);
        L2=(img1(:,:,1)==49);
        L3=(img1(:,:,1)==93);
        L4=(img1(:,:,1)==61);


        [row,col]=find(img1(:,:,1)==61);
        [row2,col2]=find(img1(:,:,1)==16);

        L5=zeros(256,256);

        for i=1:numel(col)
            point=[row(i),col(i)];
            tmp=find(col2==col(i));
            for j=1:numel(tmp)
                if row2(tmp(j))>row(i)  && row2(tmp(j))<row(i)+20
                    L5(row2(tmp(j)),col2(tmp(j)))=1;

                end
            end
        end


        %         [meanThickness1,thicknessValues1,D1]=LayerThick(L1);
        %         [meanThickness2,thicknessValues2,D2]=LayerThick(L2);
        %         [meanThickness3,thicknessValues3,D3]=LayerThick(L3);
        %         [meanThickness4,thicknessValues4,D4]=LayerThick(L4);
        %         [meanThickness5,thicknessValues5,D5]=LayerThick(L5);

        %         D=D1+D2+D3+D4+D5;

        % Compute distance transform
        D1 = bwdist(~L1);
        D2 = bwdist(~L2);
        D3 = bwdist(~L3);
        D4 = bwdist(~L4);
        D5 = bwdist(~L5);
         D=D1+D2+D3+D4+D5;

        thicknessL1=[thicknessL1;max(D1)];
        thicknessL2=[thicknessL2;max(D2)];
        thicknessL3=[thicknessL3;max(D3)];
        thicknessL4=[thicknessL4;max(D4)];
        thicknessL5=[thicknessL5;max(D5)];
        thicknessall=[thicknessall;max(D)];
    end
end
%%
slice_num=64;%%%% in complete oCT with 128 bscans, bscan 64 may be related to fovea
path=dir(folderpath);
for i=3:numel(path)
    name=path(i).name;
    tmp1=find(name=='_');
    idx(i-2)=str2double(name(tmp1(end)+1:end-4));
end
name=name(1:tmp1(end));

idx_d=idx-slice_num;
[m,idx_m]=min(abs(idx_d));
slice=idx(idx_m);

namei=strcat(folderpath,'\',name,num2str(slice),'.png');

img=(imread(namei));

img1=rgb2ycbcr(img);
L=(img1(:,:,1)>40);

D = bwdist(~L);

thickness=max(D);
thicknessT=thickness(50:200);%%%% because of registration left and right columns have zero thickness, and they do not show the real thickness of layers
% thick_statistic=[mean(thicknessT) var(thicknessT) min(thicknessT)];

