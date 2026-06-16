function [enface_left,enface_right]=EnfaceGeneration(data_path)

%% enfce generation 
bscanpath=strcat(data_path,'left\');
[img3D,~]=Readdata(bscanpath);

for i=1:size(img3D,3)
    img_proj(i,:)=std(double(img3D(:,:,i)));
end
 enface_left=(img_proj-min(min(img_proj)))/(max(max(img_proj))-min(min(img_proj)));


bscanpath=strcat(data_path,'right\');
[img3D,~]=Readdata(bscanpath);

for i=1:size(img3D,3)
    img_proj(i,:)=std(double(img3D(:,:,i)));
end
 enface_right=(img_proj-min(min(img_proj)))/(max(max(img_proj))-min(min(img_proj)));


 name=strcat(data_path,'\enface_left.jpg');
imwrite(enface_left,name);

name=strcat(data_path,'\enface_right.jpg');
imwrite(enface_right,name);