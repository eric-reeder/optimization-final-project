%% Pushrod, Bellcrank, and Strut Geometry Optimization
% 24-785 Engineering Optimizaion
% Paula Arambel, Leah Chong, Chris Norville, Eric Reeder

%% Clean Up
clear all
close all
clc

%% Initialization
x0 = [341.1; % x1: control arm effective length [mm]
     352;    % x2: pushrod length [mm]
     94;     % x3: bellcrank pivot-pushrod link [mm]
     91.2;   % x4: bellcrank pivot-strut link [mm]
     34.7;   % x5: bellcrank pushrod-strut link [mm]
     31.9;   % x6: bellcrank-chassis attachment x-coordinate [mm]
     281;    % x7: bellcrank-chassis attachment y-coordinate [mm]
     -50.8;  % x8: strut-chassis attachment x-coordinate [mm]
     455;];  % x9: strut-chassis attachment y-coordinate [mm]

minStrutLen = 143; % minimum strut length [mm]
maxStrutLen = 200; % maximum strut length [mm]
rideStrutLen = (maxStrutLen + minStrutLen)./2; % strut length at ride height [mm]
xdTube = 2.4; % x-coordinate of bellcrank mounting tube [mm]
ydTube = 263.2; % y-coordinate of bellcrank mounting tube [mm]
xfTube = -86.4; % x-coordinate of strut mounting tube [mm]
yfTube = 483.5; % y-coordinate of strut mounting tube [mm]
xgRide = 370; % x-coordinate of lower control arm to upright mount point [mm]
ygRide = 34.7; % y-coordinate of lower control arm to upright mount point [mm]
minTabLen = 25; % minimum tab length [mm]
maxTabLen = 75; % maximum tab length [mm]
N = 10; % number of sample points

%% Testing
rideHeightStrutLen = 171.5;
[A, B, C, D, E, F] = calculateGeometry(x0, rideHeightStrutLen);
plotGeometry(A, B, C, D, E, F, 'Current Geometry', 'b');
% findMotionRatio(x0,strutLen,maxStrutLen)
% findMotionRatio(x0,minStrutLen,maxStrutLen)
% constraints(x0,minStrutLen,maxStrutLen,xdTube,ydTube,xfTube,yfTube,...
%     minTabLen,maxTabLen)
% objectiveFun(x0, minStrutLen, maxStrutLen, N)

%% Optimization
f = @(x) objectiveFun(x, minStrutLen, maxStrutLen, N);
c = @(x) constraints(x, minStrutLen, maxStrutLen, rideStrutLen, xdTube, ...
    ydTube, xfTube, yfTube, xgRide, ygRide, minTabLen, maxTabLen);
[xMinimizer, minimum, exitflag, output] = fmincon(f, x0, [], [], [], [],...
    [], [], c)

[A, B, C, D, E, F] = calculateGeometry(xMinimizer, rideStrutLen);
plotGeometry(A, B, C, D, E, F, xdTube, ydTube, xfTube, yfTube,...
    'Optimized Geomtery', 'r');


