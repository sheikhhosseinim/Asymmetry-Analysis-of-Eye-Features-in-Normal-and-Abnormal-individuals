%%%%% main for feature exctraction from the aligned left and right B-scans
close all;clear;clc
%%% 
%%
Dataset='H:\...\Dataset\';%%%% Main folder of dataset contains subj1, subj2,...,subj90 folders
Num_subj=numel(dir(Dataset))-2;

for subj_idx=1:Num_subj

    data_path=strcat(Dataset,'subj',num2str(subj_idx),'\');


    folderpathL=strcat(data_path,'left_after_recons_layers\');
    folderpathR=strcat(data_path,'right_after_recons_layers\');


    [thicknessL1_L,thicknessL2_L,thicknessL3_L,thicknessL4_L,thicknessL5_L,thicknessall_L,thicknessT_L]=layerBorder(folderpathL);
    [thicknessL1_R,thicknessL2_R,thicknessL3_R,thicknessL4_R,thicknessL5_R,thicknessall_R,thicknessT_R]=layerBorder(folderpathR);

    [ThicknessMapL,ThicknessMapR]=ThicknessOrganization(thicknessL1_L,thicknessL2_L,thicknessL3_L,...
        thicknessL4_L,thicknessL5_L,thicknessall_L,thicknessT_L,thicknessL1_R,thicknessL2_R,...
        thicknessL3_R,thicknessL4_R,thicknessL5_R,thicknessall_R,thicknessT_R);

    [Diff,Avg,asym]=relativeMeasure(ThicknessMapR,ThicknessMapL);

    features_subj=featureCalc(Diff,Avg,asym,ThicknessMapL,ThicknessMapR);

    features{subj_idx}=features_subj;


end

save(strcat(Dataset,'\features.mat'),'features');



