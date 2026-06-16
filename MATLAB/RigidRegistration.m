function [roi_fundus_vessel,roi_enface_vessel,param_roi]=RigidRegistration(fundus_vessel,enface_vessel)


center=size(fundus_vessel)/2;%%%% 
clear corr_mat
k=1;

for i=center(1)-10:2:center(1)+10
    for j=center(2)-10:2:center(2)+10
        for w=600:50:800 %size(enface_vessel,1)+50
            for h=600:50:800 %600
                for r=-15:15
                    tic

                    froi_vessel=fundus_vessel(round(i-w/2):round(i+w/2),round(j-h/2):round(j+h/2));
                    erot_vessel=imresize(enface_vessel,size(froi_vessel));
                    erot_vessel=imrotate(erot_vessel,r,'bilinear','crop');

                    R=corr2(erot_vessel,froi_vessel);
                    corr_mat(k,:)=[i j w h r R];
                    k=k+1;
                    toc



                end
            end
        end
    end
end

[m,idx]=max(corr_mat(:,6));
i=corr_mat(idx,1);
j=corr_mat(idx,2);
w=corr_mat(idx,3);
h=corr_mat(idx,4);
r=corr_mat(idx,5);
roi_fundus_vessel=fundus_vessel(round(i-w/2):round(i+w/2),round(j-h/2):round(j+h/2));

roi_enface_vessel=imresize(enface_vessel,size(roi_fundus_vessel));
roi_enface_vessel=imrotate(roi_enface_vessel,r,'bilinear','crop');

param_roi=[i j w h r];