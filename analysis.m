%% Pushrod, Bellcrank, and Strut Geometry Optimization - Results Analysis
% 24-785 Engineering Optimizaion
% Paula Arambel, Leah Chong, Chris Norville, Eric Reeder

%% Clean up
clear all
close all
clc

%% Read results files
resultsFiles = 5;
results = zeros(10,100);
lambdas = zeros(27,100);
startPoint = 1;
for n = 1:resultsFiles
    filename = ['results',num2str(n),'.mat'];
    currResults = load(filename);
    results(:,startPoint:startPoint+19) = currResults.results;
    lambdas(:,startPoint:startPoint+19) = currResults.lambdas;
    startPoint = startPoint + 20;
end

n = 1;
for i = 1:100
    if ~isnan(results(1,i))
        cleanResults(:,n) = results(:,i);
        cleanLambdas(:,n) = lambdas(:,i);
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
    color = 'r';
    [A, B, C, D, E, F] = calculateGeometry(cleanResults(2:end,n), rideStrutLen);
    
    xCoords = [A(1), B(1), C(1), D(1), E(1), F(1)];
    yCoords = [A(2), B(2), C(2), D(2), E(2), F(2)];

    plot(xCoords, yCoords, [':',color])
    plot([C(1),E(1)],[C(2),E(2)],[':',color])
    axis([-100 450 -50 550])
    set(gca,'DataAspectRatio',[1 1 1])
end
plot(xdTube,ydTube,'o','MarkerEdgeColor','k')
plot(xfTube,yfTube,'o','MarkerEdgeColor','k')
title('Multistart Results')
xlabel('Y-Coordinate')
ylabel('Z-Coordinate')

%% Sort results by minimum
minima = [];
index = 1;
tolerance = 1e-6;

% Find distinct minima
for i = 1:size(cleanResults,2)
    currResult = cleanResults(1,i);
    isMember = false;
    
    for j = 1:length(minima)
        if abs(currResult - minima(j)) <= tolerance
            isMember = true;
        end
    end
    
    if ~isMember
        minima(index) = currResult;
        index = index + 1;
    end
end

% Find corresponding x
finalResults = zeros(10,length(minima));
finalLambdas = zeros(27,length(minima));

for i = 1:size(cleanResults,2)
    currResult = cleanResults(:,i);
    currLambda = cleanLambdas(:,i);
    
    for j = 1:size(finalResults,2)
        if abs(currResult(1) - minima(j)) <= tolerance && finalResults(1,j) == 0
            finalResults(:,j) = currResult;
            finalLambdas(:,j) = currLambda;
        end
    end
end

%% Plot sorted results

figure(2)
hold on
colors = ['r','g','b','k'];
for n = 1:size(finalResults,2)
    color = colors(n);
    [A, B, C, D, E, F] = calculateGeometry(finalResults(2:end,n), rideStrutLen);
    
    xCoords = [A(1), B(1), C(1), D(1), E(1), F(1)];
    yCoords = [A(2), B(2), C(2), D(2), E(2), F(2)];

    plot(xCoords,yCoords,color)
    plot([C(1),E(1)],[C(2),E(2)],color)
    axis([-100 450 -50 550])
    set(gca,'DataAspectRatio',[1 1 1])
end
plot(xdTube,ydTube,'o','MarkerEdgeColor','k')
plot(xfTube,yfTube,'o','MarkerEdgeColor','k')
title('Optimized Geometries')
xlabel('Y-Coordinate [mm]')
ylabel('Z-Coordinate [mm]')




