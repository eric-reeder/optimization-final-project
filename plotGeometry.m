function plotGeometry(A, B, C, D, E, F, xdTube, ydTube, xfTube, yfTube,...
    name, color)

xCoords = [A(1), B(1), C(1), D(1), E(1), F(1)];
yCoords = [A(2), B(2), C(2), D(2), E(2), F(2)];

figure('Name', name)
hold on
plot(xCoords, yCoords, color)
plot([C(1),E(1)],[C(2),E(2)],color);
plot(xdTube,ydTube,'o','MarkerEdgeColor',color)
plot(xfTube,yfTube,'o','MarkerEdgeColor',color)
axis([-100 500 -50 600])
set(gca,'DataAspectRatio',[1 1 1])

end