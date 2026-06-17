%%%%% main for statistical analysis
close all;clear;clc
%%%% to see the classification results related to each feature group,
%%%% change X variable(line 35)
%%%
%%
Dataset='H:\...\Dataset\';%%%% Main folder of dataset contains subj1, subj2,...,subj90 folders
load(strcat(Dataset,'\features.mat'));
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
[feature_vector_cls,labels]=Precls(normal_subjects,abnormal_subjects);

X0=feature_vector_cls(:,14);%%% std of thickness
X1=feature_vector_cls(:,15:20);%%%% average of entropy
X2=feature_vector_cls(:,29:34);%%%% AI
X3=feature_vector_cls(:,36:41);%%%% grad
X4=feature_vector_cls(:,50:55);%%%% Contrast
X5=feature_vector_cls(:,57:62);%%%% Correlation
X6=feature_vector_cls(:,64:69);%%%% homogeniety
X7=feature_vector_cls(:,71:76);%%%% skweness
X8=feature_vector_cls(:,78:83);%%%% kurtosis
X9=feature_vector_cls(:,85:89);%%% energy


X=[X2 X4 X6];
Y=labels;

feat_data=[X Y];

% Choose classifier: 'tree' or 'svm'
classifierType = 'tree'; % or 'svm'

% Set random seed for reproducibility
rng(1);

% Create 5-fold cross-validation partition
cv = cvpartition(Y, 'KFold', 5);
% cv = cvpartition(Y, 'LeaveOut');

% Initialize performance metrics
accuracy = zeros(cv.NumTestSets,1);
confMatrices = cell(cv.NumTestSets,1);
all_true = [];
all_pred = [];
 all_score = [];

for i = 1:cv.NumTestSets
    % Get training and test indices
    trainIdx = training(cv, i);
    testIdx = test(cv, i);
    
    % Prepare training and test data
    Xtrain = X(trainIdx, :);
    Ytrain = Y(trainIdx);
    Xtest = X(testIdx, :);
    Ytest = Y(testIdx);
    
 % --- IMPORTANT: normalize using training data only ---
    mu  = mean(Xtrain);
    sig = std(Xtrain);

    Xtrain = (Xtrain - mu) ./ sig;
    Xtest  = (Xtest - mu) ./ sig;

    % Train classifier
    switch classifierType
        case 'tree'
            model = fitctree(Xtrain, Ytrain);
        case 'svm'
            model = fitcsvm(Xtrain, Ytrain);
        otherwise
            error('Unsupported classifier type.');
    end
    


    % Predict test data
   
    [Ypred, score] = predict(model, Xtest);
    Ypred_train=predict(model, Xtrain);
    % Compute accuracy
    accuracy(i) = sum(Ypred == Ytest) / numel(Ytest);
        accuracy_train(i) = sum(Ypred_train == Ytrain) / numel(Ytrain);

    
    all_true  = [all_true; Ytest];
    all_pred  = [all_pred; Ypred];
     all_score = [all_score; score];

    % Confusion matrix
    confMatrices{i} = confusionmat(Ytest, Ypred);
positiveClass = 1;  % adjust if needed



Ctmp=confusionmat(Ytest, Ypred);
TP = Ctmp(2,2);
TN = Ctmp(1,1);
FP = Ctmp(1,2);
FN = Ctmp(2,1);

accuracy_fold (i)   = (TP+TN) / sum(Ctmp(:));
sensitivity_fold(i) = TP / (TP+FN);
specificity_fold(i) = TN / (TN+FP);

end

% Report overall accuracy
meanAccuracy = mean(accuracy);
fprintf('Mean classification accuracy of testing: %.2f%%\n ', 100 * meanAccuracy);
% fprintf('Mean classification accuracy of training: %.2f%%\n', 100 * mean(accuracy_train));
fprintf('STD of classification accuracy of testing: %.2f%%\n', 100 * std(accuracy));

C = confusionmat(all_true, all_pred);
confusionchart(C)


%% metrics 
TP = C(2,2);
TN = C(1,1);
FP = C(1,2);
FN = C(2,1);

accuracy    = (TP+TN) / sum(C(:));
sensitivity = TP / (TP+FN);
specificity = TN / (TN+FP);
precision   = TP / (TP+FP);
f1          = 2*(precision*sensitivity)/(precision+sensitivity);

%%% Confidence Interval
n = length(all_true);
correct = sum(all_true == all_pred);

[p_acc, pci_acc] = binofit(correct, n, 0.05);
[p_sens, pci_sens] = binofit(TP, TP+FN, 0.05);
[p_spec, pci_spec] = binofit(TN, TN+FP, 0.05);

positiveClass = 1;  % adjust if needed
[Xroc,Yroc,T,AUC] = perfcurve(all_true, all_score(:,2), positiveClass);

metrics={'accuracy';'sensitivity';'specificity';'precision'; 'F1-score'};
metrics_value= [accuracy;sensitivity;specificity;precision;f1];
CI=[pci_acc;pci_sens;pci_spec;0 0;0 0];
T=table(metrics,metrics_value,CI(:,1),CI(:,2))
%%
figure
plot(Xroc, Yroc, 'LineWidth', 2)
hold on
plot([0 1], [0 1], '--k')   % diagonal reference line
xlabel('False Positive Rate')
ylabel('True Positive Rate')
title(['ROC Curve (AUC = ' num2str(AUC,3) ')'])
grid on
axis square
hold off
