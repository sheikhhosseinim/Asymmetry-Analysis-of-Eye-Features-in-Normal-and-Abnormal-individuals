function [ThicknessMapL,ThicknessMapR]=ThicknessOrganization(thicknessL1_L,thicknessL2_L,thicknessL3_L,...
    thicknessL4_L,thicknessL5_L,thicknessall_L,thicknessT_L,thicknessL1_R,thicknessL2_R,...
    thicknessL3_R,thicknessL4_R,thicknessL5_R,thicknessall_R,thicknessT_R)

ThicknessMapL(:,:,1)=imresize(thicknessL1_L,[256,256]);
ThicknessMapL(:,:,2)=imresize(thicknessL2_L,[256,256]);
ThicknessMapL(:,:,3)=imresize(thicknessL3_L,[256,256]);
ThicknessMapL(:,:,4)=imresize(thicknessL4_L,[256,256]);
ThicknessMapL(:,:,5)=imresize(thicknessL5_L,[256,256]);
ThicknessMapL(:,:,6)=imresize(thicknessall_L,[256,256]);
ThicknessMapL(:,:,7)=imresize(thicknessT_L,[256,256]);%%% at macula slice

ThicknessMapR(:,:,1)=imresize(thicknessL1_R,[256,256]);
ThicknessMapR(:,:,2)=imresize(thicknessL2_R,[256,256]);
ThicknessMapR(:,:,3)=imresize(thicknessL3_R,[256,256]);
ThicknessMapR(:,:,4)=imresize(thicknessL4_R,[256,256]);
ThicknessMapR(:,:,5)=imresize(thicknessL5_R,[256,256]);
ThicknessMapR(:,:,6)=imresize(thicknessall_R,[256,256]);
ThicknessMapR(:,:,7)=imresize(thicknessT_R,[256,256]);%%% at macula slice