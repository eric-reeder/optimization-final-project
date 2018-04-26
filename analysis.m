%% Pushrod, Bellcrank, and Strut Geometry Optimization - Results Analysis
% 24-785 Engineering Optimizaion
% Paula Arambel, Leah Chong, Chris Norville, Eric Reeder

%% Clean up
clear all
close all
clc

%% Read results files
resultsFiles = 8;
results = zeros(10,200);
startPoint = 1;
for n = 1:resultsFiles
    currResults = load(['results',num2str(n),'.mat'])
    results(:,startPoint:startPoint+24) = currResults.results;
end

results