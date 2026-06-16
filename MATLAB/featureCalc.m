function features=featureCalc(Diff,Avg,asym,ThicknessMapL,ThicknessMapR)

features=struct();

for i=1:7

    thickL(:,i)=mean(mean(ThicknessMapL(:,:,i)));
    thickR(:,i)=mean(mean(ThicknessMapR(:,:,i)));

    thickness_diff_mean(:,i)=mean(Diff(:,:,i));
    thickness_diff_std(:,i)=mean(Diff(:,:,i));

    % --- Entropy
    entropyMap = entropyfilt(Diff(:,:,i));
%     entropyMap(isnan(entropyMap)) = 0;
%     entropyMap(isinf(entropyMap)) = 0;
    entropy_mean(:,i) = mean(entropyMap);
    entropy_std(:,i)  = std(entropyMap);

    AI_column(:,i)=mean(asym(:,:,i),1);
    AI_row(:,i)=(mean(asym(:,:,i),2))';

    % --- Gradient Magnitude
    [Gx, Gy] = gradient(Diff(:,:,i));
    gradMag = sqrt(Gx.^2 + Gy.^2);
    gradMag_mean(:,i)=mean(gradMag);
    gradMag_std(:,i)=std(gradMag);

    % --- Texture: GLCM Features
    map_scaled = rescale(Diff(:,:,i), 0, 1);  % normalize to [0, 1]
    map_uint8 = im2uint8(map_scaled);
    offsets = [0 1; -1 1; -1 0; -1 -1];  % 0°, 45°, 90°, 135°
    glcm = graycomatrix(map_uint8, 'Offset', offsets, 'Symmetric', true);
    stats = graycoprops(glcm, {'Contrast', 'Correlation', 'Energy','Homogeneity'});

    Contrast(:,i)=(stats.Contrast)';
    Correlation(:,i)=(stats.Correlation)';
    Homogeneity(:,i)=(stats.Homogeneity)';
    Energy(:,i)=(stats.Energy)';

    value=Diff(:,:,i);
    skew(:,i)  = (skewness(value(:)));
    kurt(:,i)  =(kurtosis(value(:))) ;
end

features.thick_left=thickL;
features.thick_right=thickR;


features.relativethickness_mean=thickness_diff_mean;
features.relativethickness_std=thickness_diff_std;

features.entropy_mean=entropy_mean;
features.entropy_std=entropy_std;

features.asymmetry_index_column_mean=AI_column;
features.asymmetry_index_row_mean=AI_row;


features.gradMag_mean = gradMag_mean;
features.gradMag_std  = gradMag_std;

features.glcm_contrast = Contrast;
features.glcm_corr     = Correlation;
features.glcm_homo     = Homogeneity;
features.glcm_energy=Energy;

features.skewness = skew;
features.kurtosis = kurt;
