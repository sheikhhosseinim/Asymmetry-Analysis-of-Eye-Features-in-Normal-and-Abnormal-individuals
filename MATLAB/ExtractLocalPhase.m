function [LP_mean] = ExtractLocalPhase(I)
    [Y,X] = size(I);
    cw = 5*1.5.^(0:10);
    filtStruct = createMonogenicFilters(Y,X,cw,'lg',0.55);
    [m1,m2,m3] = monogenicSignal(I,filtStruct);
    LP = localPhase(m1,m2,m3);
    LP_mean = squeeze(mean(LP, 4));
end
