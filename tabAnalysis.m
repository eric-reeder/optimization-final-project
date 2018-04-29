%% Pushrod, Bellcrank, and Strut Geometry Optimization - Tab Length Analysis
% 24-785 Engineering Optimizaion
% Paula Arambel, Leah Chong, Chris Norville, Eric Reeder

%% Clean up
clear all
close all
clc

%% Read results files
resultsFiles = 6;
results = zeros(10,20,resultsFiles);
lambdas = zeros(27,20,resultsFiles);
nums = 16:4:36;
for n = 1:resultsFiles
    filename = ['tab',num2str(nums(n)),'.mat'];
    currResults = load(filename);
    results(:,:,n) = currResults.results;
    lambdas(:,:,n) = currResults.lambdas;
end

%% Plot heatmap of results
rideStrutLen = 171.5;
xdTube = 2.4; % x-coordinate of bellcrank mounting tube [mm]
ydTube = 263.2; % y-coordinate of bellcrank mounting tube [mm]
xfTube = -86.4; % x-coordinate of strut mounting tube [mm]
yfTube = 483.5; % y-coordinate of strut mounting tube [mm]

colors = ['r','g','b','c','m','k'];
figure(1)
hold on
for i = 1:resultsFiles
    color = colors(i);
    for n = 1:20
        [A, B, C, D, E, F] = calculateGeometry(results(2:end,n,i), rideStrutLen);

        xCoords = [A(1), B(1), C(1), D(1), E(1), F(1)];
        yCoords = [A(2), B(2), C(2), D(2), E(2), F(2)];

        plot(xCoords, yCoords, ['-',color])
        plot([C(1),E(1)],[C(2),E(2)],['-',color])
        axis([-100 450 -50 550])
        set(gca,'DataAspectRatio',[1 1 1])
    end
end

%% Sort results by minimum
tolerance = 1e-4;
finalResults = zeros(10,4,resultsFiles);
finalLambdas = zeros(27,4,resultsFiles);

for n = 1:resultsFiles
    index = 1;
    minima = [0,0,0,0];
    % Find distinct minima
    for i = 1:size(results,2)
        currResult = results(1,i,n);
        isMember = false;

        for j = 1:length(minima)
            if abs(currResult - minima(j)) <= tolerance || isnan(currResult)
                isMember = true;
            end
        end

        if ~isMember
            minima(index) = currResult;
            index = index + 1;
        end
    end
    
    minima

    % Find corresponding x
    for i = 1:size(results,2)
        currResult = results(:,i,n);
        currLambda = lambdas(:,i,n);

        for j = 1:size(finalResults,2)
            if abs(currResult(1) - minima(j)) <= tolerance && finalResults(1,j,n) == 0
                finalResults(:,j,n) = currResult;
                finalLambdas(:,j,n) = currLambda;
            end
        end
    end
end

%% Plot sorted results

figure(2)
hold on
for i = 1:resultsFiles
    color = colors(i);
    for n = 1:size(finalResults,2)
        [A, B, C, D, E, F] = calculateGeometry(finalResults(2:end,n,i), rideStrutLen);

        xCoords = [A(1), B(1), C(1), D(1), E(1), F(1)];
        yCoords = [A(2), B(2), C(2), D(2), E(2), F(2)];

        plot(xCoords,yCoords,color)
        plot([C(1),E(1)],[C(2),E(2)],color)
        axis([-100 450 -50 550])
        set(gca,'DataAspectRatio',[1 1 1])
    end
end
title('Optimized Geometries')




