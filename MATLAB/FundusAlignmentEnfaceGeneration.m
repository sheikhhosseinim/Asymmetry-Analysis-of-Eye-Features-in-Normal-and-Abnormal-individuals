%%%%% fundus alignment and enface generation


main_path=pwd;%%%% folder path of m-files

Dataset='H:\...\Dataset\';%%%% Main folder of dataset contains subj1, subj2,...,subj90 folders


for subj_idx=1:90

    data_path=strcat(Dataset,'subj',num2str(subj_idx),'\');

    %%% step 1: extract Optic Disc & fovea for fundus images-
    % This step was run by Python and the extracted coordinates were saved
    % in a .txt file for each fundus image.

    %%% step 2: alignment of the left and right fundus images for each subject
    [fundus_left_aligned, fundus_right_aligned]=FundusAlignment(data_path);

    %%% step 3: creat enface image
    [enface_left,enface_right]=EnfaceGeneration(data_path);

end



