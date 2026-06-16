function [u,v]=NonRigidRegistration(fundus_aligned,enface,roi_fundus_vessel,roi_enface_vessel,param_roi)

constant=1;
alpha=0.3;

i=param_roi(1);
j=param_roi(2);
w=param_roi(3);
h=param_roi(4);
r=param_roi(5);

roi_fundus=fundus_aligned(round(i-w/2):round(i+w/2),round(j-h/2):round(j+h/2),:);
roi_enface=imresize(enface,[size(roi_enface_vessel,1),size(roi_enface_vessel,2)]);
roi_enface=imrotate(roi_enface,r,'bilinear','crop');


roi_fundus=0.01*double(roi_fundus)+constant*double(roi_fundus_vessel);
roi_enface=0.01*double(roi_enface)+constant*double(roi_enface_vessel);

roi_fundus=roi_fundus./max(roi_fundus(:));
roi_enface=roi_enface./max(roi_enface(:));


enface_phase_img = ExtractLocalPhase(roi_enface) / pi;
fundus_phase_img = ExtractLocalPhase(im2gray(roi_fundus)) / pi;

%
tic;[u,v,movingImagephase]=deformableReg2Dmind_asym(fundus_phase_img,enface_phase_img,alpha);toc


