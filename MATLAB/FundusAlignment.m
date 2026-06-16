function [fundus_left_aligned, fundus_right_aligned]=FundusAlignment(data_path)

name=strcat(data_path,'fundus_left.txt');
raphe_points1=load(name);
od1=raphe_points1(1:2);
fovea1=raphe_points1(3:4);
if od1(1)<fovea1(1)%%%%% for left eye
    teta1=-atand((fovea1(2)-od1(2))/(fovea1(1)-od1(1)));
else %%%%% for rigth eye
    teta1=atand((fovea1(2)-od1(2))/abs(fovea1(1)-od1(1)));
end

name=strcat(data_path,'fundus_right.txt');
raphe_points2=load(name);
od2=raphe_points2(1:2);
fovea2=raphe_points2(3:4);
if od2(1)<fovea2(1)%%%%% for left eye
    teta2=-atand((fovea2(2)-od2(2))/(fovea2(1)-od2(1)));
else %%%%% for rigth eye
    teta2=atand((fovea2(2)-od2(2))/abs(fovea2(1)-od2(1)));
end

name=strcat(data_path,'\fundus_left.jpg');
fundus1=imread(name);
fundus_left_aligned=imrotate(fundus1,-teta1);

name=strcat(data_path,'\fundus_right.jpg');
fundus2=imread(name);
fundus_right_aligned=imrotate(fundus2,-teta2);

name=strcat(data_path,'\fundus_left_aligned.jpg');
imwrite(fundus_left_aligned,name);

name=strcat(data_path,'\fundus_right_aligned.jpg');
imwrite(fundus_right_aligned,name);
