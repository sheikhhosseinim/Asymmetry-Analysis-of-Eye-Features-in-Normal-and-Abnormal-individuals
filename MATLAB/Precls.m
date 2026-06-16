function [feature_vector_cls,labels]=Precls(normal_subjects,abnormal_subjects)



feat_cls_normal=[];
feat_cls_normal=[feat_cls_normal,feature_statics(normal_subjects,'thickness_diff_mean')];
feat_cls_normal=[feat_cls_normal,feature_statics(normal_subjects,'relativethickness_std')];
feat_cls_normal=[feat_cls_normal,feature_statics(normal_subjects,'entropy_mean')];
feat_cls_normal=[feat_cls_normal,feature_statics(normal_subjects,'entropy_std')];
feat_cls_normal=[feat_cls_normal,feature_statics(normal_subjects,'asymmetry_index_mean')];
feat_cls_normal=[feat_cls_normal,feature_statics(normal_subjects,'gradMag_mean')];
feat_cls_normal=[feat_cls_normal,feature_statics(normal_subjects,'gradMag_std')];
feat_cls_normal=[feat_cls_normal,feature_statics(normal_subjects,'Contrast')];
feat_cls_normal=[feat_cls_normal,feature_statics(normal_subjects,'Correlation')];
feat_cls_normal=[feat_cls_normal,feature_statics(normal_subjects,'Homogeneity')];
feat_cls_normal=[feat_cls_normal,feature_statics(normal_subjects,'skewness')];
feat_cls_normal=[feat_cls_normal,feature_statics(normal_subjects,'kurtosis')];
feat_cls_normal=[feat_cls_normal,feature_statics(normal_subjects,'Energy')];



feat_cls_abnormal=[];
feat_cls_abnormal=[feat_cls_abnormal,feature_statics(abnormal_subjects,'thickness_diff_mean')];
feat_cls_abnormal=[feat_cls_abnormal,feature_statics(abnormal_subjects,'relativethickness_std')];
feat_cls_abnormal=[feat_cls_abnormal,feature_statics(abnormal_subjects,'entropy_mean')];
feat_cls_abnormal=[feat_cls_abnormal,feature_statics(abnormal_subjects,'entropy_std')];
feat_cls_abnormal=[feat_cls_abnormal,feature_statics(abnormal_subjects,'asymmetry_index_mean')];
feat_cls_abnormal=[feat_cls_abnormal,feature_statics(abnormal_subjects,'gradMag_mean')];
feat_cls_abnormal=[feat_cls_abnormal,feature_statics(abnormal_subjects,'gradMag_std')];
feat_cls_abnormal=[feat_cls_abnormal,feature_statics(abnormal_subjects,'Contrast')];
feat_cls_abnormal=[feat_cls_abnormal,feature_statics(abnormal_subjects,'Correlation')];
feat_cls_abnormal=[feat_cls_abnormal,feature_statics(abnormal_subjects,'Homogeneity')];
feat_cls_abnormal=[feat_cls_abnormal,feature_statics(abnormal_subjects,'skewness')];
feat_cls_abnormal=[feat_cls_abnormal,feature_statics(abnormal_subjects,'kurtosis')];
feat_cls_abnormal=[feat_cls_abnormal,feature_statics(abnormal_subjects,'Energy')];

feature_vector_cls=[feat_cls_normal;feat_cls_abnormal];
labels=[zeros(45,1);ones(45,1)];
% labels=[repmat('n',[21,1]);repmat('A',[20,1])];