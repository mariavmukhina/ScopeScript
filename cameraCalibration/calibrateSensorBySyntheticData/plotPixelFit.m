function [] = plotPixelFit(A,B,y,x)
%PLOTPIXELFIT Summary of this function goes here
%   Detailed explanation goes here

% A is energy variance
% B is means

means = B(x,y,:);
vars  = A(x,y,:);
means = means(:);
vars = vars(:);
figure;scatter(means,vars);
meansFit = [ones(length(means),1) means];
[fit,stdx,mse] = lscov(meansFit,vars);
hold on; plot(means,means*fit(2)+fit(1),'r');
title(['gain :' num2str(fit(2))]);

dlr = fitlm(means,vars,'RobustOpts','on');
robustEstimate = dlr.Coefficients.Estimate;
plot(means,means*robustEstimate(2)+robustEstimate(1),'--g');
end

