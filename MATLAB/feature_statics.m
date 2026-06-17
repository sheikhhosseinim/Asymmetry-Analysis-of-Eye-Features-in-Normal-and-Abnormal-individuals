function feature_vec=feature_statics(subjects,feat_name)

feature_vec=[];

for i=1:length(subjects)

    features=subjects{1,i};

    switch feat_name

        case 'thickness_diff_mean'
            feature_vec=[feature_vec;mean(features.relativethickness_mean)];
        case 'relativethickness_std'
            feature_vec=[feature_vec;std(features.relativethickness_std)];
        case 'entropy_mean'
            feature_vec=[feature_vec;mean(features.entropy_mean)];
        case 'entropy_std'
            feature_vec=[feature_vec;std(features.entropy_std)];
        case 'asymmetry_index_mean'
            feature_vec=[feature_vec;mean(features.asymmetry_index_column_mean)];
        case 'gradMag_mean'
            feature_vec=[feature_vec;mean(features.gradMag_mean)] ;
        case 'gradMag_std'
            feature_vec=[feature_vec;std(features.gradMag_std)] ;
        case 'Contrast'
            feature_vec=[feature_vec;mean(features.glcm_contrast)];
        case 'Correlation'
            feature_vec=[feature_vec;mean(features.glcm_corr)];
        case 'Homogeneity'
            feature_vec=[feature_vec;mean(features.glcm_homo)];
        case 'skewness'
            feature_vec=[feature_vec;(features.skewness)];
        case 'kurtosis'
            feature_vec=[feature_vec;(features.kurtosis )];
        case 'Energy'
            feature_vec=[feature_vec;mean(features.glcm_energy )];

    end

end