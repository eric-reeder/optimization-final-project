function plotGeometry(A, B, C, D, E, F)

xCoords = [A(1), B(1), C(1), D(1), E(1), F(1)];
yCoords = [A(2), B(2), C(2), D(2), E(2), F(2)];

figure
hold on
plot(xCoords(1:2), yCoords(1:2), 'r')
plot(xCoords(2:3), yCoords(2:3), 'g')
plot(xCoords(3:5), yCoords(3:5), 'b')
plot(xCoords(5:6), yCoords(5:6), 'm')

end