%%%%% main for statistical analysis
close all;clear;clc
%%%
%%
Dataset='H:\...\Dataset\';%%%% Main folder of dataset contains subj1, subj2,...,subj90 foldersload(strcat(Dataset,'\features.mat'));
Num_subj=numel(dir(Dataset))-2;

for subj_idx=1:Num_subj

data_path=strcat(Dataset,'subj',num2str(subj_idx),'\');
load(strcat(data_path,'label.txt'));

    if label==0
        normal_subjects{subj_idx}=features{subj_idx};
    else
        abnormal_subjects{subj_idx-45}=features{subj_idx};

    end
end
    %%
    p1(1,:)=statistical_analysis(normal_subjects,abnormal_subjects,'thickness_diff_mean');
    p1(2,:)=statistical_analysis(normal_subjects,abnormal_subjects,'relativethickness_std');
    p1(3,:)=statistical_analysis(normal_subjects,abnormal_subjects,'entropy_mean');
    p1(4,:)=statistical_analysis(normal_subjects,abnormal_subjects,'entropy_std');
    p1(5,:)=statistical_analysis(normal_subjects,abnormal_subjects,'asymmetry_index_mean');
    p1(6,:)=statistical_analysis(normal_subjects,abnormal_subjects,'gradMag_mean');
    p1(7,:)=statistical_analysis(normal_subjects,abnormal_subjects,'gradMag_std');
    p1(8,:)=statistical_analysis(normal_subjects,abnormal_subjects,'Contrast');
    p1(9,:)=statistical_analysis(normal_subjects,abnormal_subjects,'Correlation');
    p1(10,:)=statistical_analysis(normal_subjects,abnormal_subjects,'Homogeneity');

    p1(11,:)=statistical_analysis(normal_subjects,abnormal_subjects,'skewness');
    p1(12,:)=statistical_analysis(normal_subjects,abnormal_subjects,'kurtosis');
    p1(13,:)=statistical_analysis(normal_subjects,abnormal_subjects,'Energy');

    biomarkers={'thickness_diff_mean';'relativethickness_std';'entropy_mean';'entropy_std';...
        'asymmetry_index_mean';'gradMag_mean';'gradMag_std';'Contrast';'Correlation';'Homogeneity';'skewness';'kurtosis';'Energy'};

    % layers={'first', 'seconds','third','forth','fifth','total','central slice'};
    first_layer=p1(:,1);
    seconds_layer=p1(:,2);
    third_layer=p1(:,3);
    forth_layer=p1(:,4);
    fifth_layer=p1(:,5);
    all_layers=p1(:,6);
    macula_slice=p1(:,7);

    T=table(biomarkers,first_layer,seconds_layer,third_layer,forth_layer,fifth_layer,all_layers,macula_slice)
