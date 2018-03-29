%% Pushrod, Bellcrank, and Strut Geometry Optimization
% 24-785 Engineering Optimizaion
% Paula Arambel, Leah Chong, Chris Norville, Eric Reeder

%% Clean Up
clear all
close all
clc

%% Things

x0 = [341.1; % x1: control arm effective length
     352;    % x2: pushrod length
     94;     % x3: bellcrank pivot-pushrod link
     91.2;   % x4: bellcrank pivot-strut link
     34.7;   % x5: bellcrank pushrod-strut link
     31.9;   % x6: bellcrank-chassis attachment x-coordinate
     281;    % x7: bellcrank-chassis attachment y-coordinate
     -50.8;  % x8: strut-chassis attachment x-coordinate
     455;];  % x9: strut-chassis attachment y-coordinate
 
 strutLen = 171.5;
 [A, B, C, D, E, F] = calculateGeometry(x0, strutLen);
 plotGeometry(A, B, C, D, E, F);