%% Tab Length Parametric Study
% 24-785 Engineering Optimizaion
% Paula Arambel, Leah Chong, Chris Norville, Eric Reeder

%% Clean up
clear all
close all
clc

%% Initialization
minStrutLen = 143; % minimum strut length [mm]
maxStrutLen = 200; % maximum strut length [mm]
rideStrutLen = (maxStrutLen + minStrutLen)./2; % strut length at ride height [mm]
xdTube = 2.4; % x-coordinate of bellcrank mounting tube [mm]
ydTube = 263.2; % y-coordinate of bellcrank mounting tube [mm]
xfTube = -86.4; % x-coordinate of strut mounting tube [mm]
yfTube = 483.5; % y-coordinate of strut mounting tube [mm]
xgRide = 370; % x-coordinate of lower control arm to upright mount point [mm]
ygRide = 34.7; % y-coordinate of lower control arm to upright mount point [mm]
minTabLen = 32; % minimum tab length [mm]
maxTabLen = 75; % maximum tab length [mm]
minLinkLen = 100; % minimum link length for multistart [mm]
maxLinkLen = 500; % max link length for multistart [mm]
minBellcrankLen = 20; % min bellcrank side length for multistart [mm]
maxBellcrankLen = 150; % max bellcrank side length for multistart [mm]
N = 10; % number of sample points
startPts = 20; % number of multistarts

%% Optimization
f = @(x) objectiveFun(x, minStrutLen, maxStrutLen, N);
c = @(x) constraints(x, minStrutLen, maxStrutLen, rideStrutLen, xdTube, ...
    ydTube, xfTube, yfTube, xgRide, ygRide, minTabLen, maxTabLen,...
    maxBellcrankLen);
options = optimoptions('fmincon');
options.OptimalityTolerance = 1e-7;
options.MaxFunctionEvaluations = 20000;

results = zeros(10, startPts);
lambdas = zeros(27, startPts);
for n = 1:startPts
    x0 = genStartPoint(minLinkLen,maxLinkLen,minBellcrankLen,...
    maxBellcrankLen,minTabLen,maxTabLen,xdTube,ydTube,xfTube,yfTube,...
    minStrutLen,maxStrutLen);
    [xMinimizer, minimum, exitflag, output, lambda] = fmincon(f, x0, [], [], [], [],...
        [], [], c, options);
    if exitflag == 1
        results(1,n) = minimum;
        results(2:end,n) = xMinimizer;
        lambdas(1:end,n) = lambda.ineqnonlin;
    else
        results(:,n) = NaN;
    end
end

%% Plot
figure(2)
hold on

for n = 1:startPts
    [A, B, C, D, E, F] = calculateGeometry(results(2:end,n), rideStrutLen);
    
    xCoords = [A(1), B(1), C(1), D(1), E(1), F(1)];
    yCoords = [A(2), B(2), C(2), D(2), E(2), F(2)];

    plot(xCoords, yCoords, ':r')
    plot([C(1),E(1)],[C(2),E(2)],':r');
    plot(xdTube,ydTube,'o','MarkerEdgeColor','r')
    plot(xfTube,yfTube,'o','MarkerEdgeColor','r')
    axis([-100 500 -50 600])
    set(gca,'DataAspectRatio',[1 1 1])
end