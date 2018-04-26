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
    filename = ['results',num2str(n),'.mat'];
    currResults = load(filename);
    results(:,startPoint:startPoint+24) = currResults.results;
    startPoint = startPoint + 25;
end

n = 1;
for i = 1:200
    if ~isnan(results(1,i))
        cleanResults(:,n) = results(:,i);
        n = n + 1;
    end
end

%% Plot heatmap of results
rideStrutLen = 171.5;
xdTube = 2.4; % x-coordinate of bellcrank mounting tube [mm]
ydTube = 263.2; % y-coordinate of bellcrank mounting tube [mm]
xfTube = -86.4; % x-coordinate of strut mounting tube [mm]
yfTube = 483.5; % y-coordinate of strut mounting tube [mm]

figure(1)
hold on
for n = 1:size(cleanResults,2)
    if cleanResults(1,n)<0.0003
        color = 'r';
    else
        color = 'b';
    end
    [A, B, C, D, E, F] = calculateGeometry(cleanResults(2:end,n), rideStrutLen);
    
    xCoords = [A(1), B(1), C(1), D(1), E(1), F(1)];
    yCoords = [A(2), B(2), C(2), D(2), E(2), F(2)];

    plot(xCoords, yCoords, [':',color])
    plot([C(1),E(1)],[C(2),E(2)],[':',color]);
    axis([-100 500 -50 600])
    set(gca,'DataAspectRatio',[1 1 1])
end