function p=statistical_analysis(normal_subjects,abnormal_subjects,feat_name)

feature_vec_normal=feature_statics(normal_subjects,feat_name);
feature_vec_abnormal=feature_statics(abnormal_subjects,feat_name);

for i=1:size(feature_vec_normal,2)

    [h1, ~] = kstest(feature_vec_normal(:,i));%%%% Kolmogorov-Smirnov Test
    [h2, ~] = kstest(feature_vec_abnormal(:,i));%%%% Kolmogorov-Smirnov Test

    if h1==0 && h2==0
        [h, p(1,i)] = ttest2(feature_vec_normal(:,i), feature_vec_abnormal(:,i));
    else
        p(1,i) = ranksum(feature_vec_normal(:,i), feature_vec_abnormal(:,i));
    end
end