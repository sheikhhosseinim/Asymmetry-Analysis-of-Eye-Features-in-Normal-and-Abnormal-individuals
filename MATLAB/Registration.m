%%%%% main for alignment of the left and right OCT B-scans

%% add required files to Matlab path: monogenic, MIND
addpath('\monogenic_signal_matlab-master')
addpath('\MIND')

main_path=pwd;%%%% folder path of m-files

Dataset='H:\...\Dataset\';%%%% Main folder of dataset contains subj1, subj2,...,subj90 folders


for subj_idx=1:90

    data_path=strcat(Dataset,'subj',num2str(subj_idx),'\');


    %%% step 4: vessel extraction of fundus image by B-COSFIRE(python)
    %%% step 5: vessel extraction of enface image by U-Net framework, with a
    % ResNet-50 backbone (python)
    enface_vessel_left=imread(strcat(data_path,'enface_vessel_left.jpg'));
    enface_vessel_right=imread(strcat(data_path,'enface_vessel_right.jpg'));

    fundus_vessel_left=imread(strcat(data_path,'fundus_vessel_left.jpg'));
    fundus_vessel_right=imread(strcat(data_path,'fundus_vessel_right.jpg'));

    %%% some morphology processings
    if size(enface_vessel_left,3)==3;enface_vessel_left=im2gray(enface_vessel_left);end
    enface_vessel_left=enface_vessel_left>10;
    enface_vessel_left=bwareaopen(enface_vessel_left,100);

    if size(fundus_vessel_left,3)==3;fundus_vessel_left=im2gray(fundus_vessel_left);end
    if size(fundus_left_aligned,3)==3;fundus_left_aligned=im2gray(fundus_left_aligned);end
    fundus_vessel_left=fundus_vessel_left>20;
    fundus_vessel_left=bwareaopen(fundus_vessel_left,20);


    if size(enface_vessel_right,3)==3;enface_vessel_right=im2gray(enface_vessel_right);end
    enface_vessel_right=enface_vessel_right>10;
    enface_vessel_right=bwareaopen(enface_vessel_right,100);

    if size(fundus_vessel_right,3)==3;fundus_vessel_right=im2gray(fundus_vessel_right);end
    if size(fundus_right_aligned,3)==3;fundus_right_aligned=im2gray(fundus_right_aligned);end
    fundus_vessel_right=fundus_vessel_right>20;
    fundus_vessel_right=bwareaopen(fundus_vessel_right,20);

    %%% step 6: rigid registration
    [roi_fundus_vessel_left,roi_enface_vessel_left,param_left]=RigidRegistration(fundus_vessel_left,enface_vessel_left);
    [roi_fundus_vessel_right,roi_enface_vessel_right,param_right]=RigidRegistration(fundus_vessel_right,enface_vessel_right);

    %%% step 7: non-rigid registrtion
    [u_left,v_left]=NonRigidRegistration(fundus_left_aligned,enface_left,roi_fundus_vessel_left,roi_enface_vessel_left,param_left);
    [u_right,v_right]=NonRigidRegistration(fundus_right_aligned,enface_right,roi_fundus_vessel_right,roi_enface_vessel_right,param_right);

    %%% step 8: bscan reconstruction
    cd (data_path)
    mkdir left_after_recons
    mkdir right_after_recons

    mkdir left_after_recons_layers
    mkdir right_after_recons_layers
    cd(main_path)

    bscanfolder=strcat(data_path,'left\');
    new_bscanfolder=strcat(data_path,'left_after_recons\');
    BscansRecons(bscanfolder, new_bscanfolder, param_left, u_left);

    bscanfolder=strcat(data_path,'right\');
    new_bscanfolder=strcat(data_path,'right_after_recons\');
    BscansRecons(bscanfolder, new_bscanfolder, param_left, u_left);
end



