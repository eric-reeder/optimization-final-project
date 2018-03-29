function [A, B, C, D, E, F] = calculateGeometry(x, strutLen)

% Set A as origin
xa = 0;
ya = 0;
A = [xa, ya];

% Find coordinates of E
l7 = sqrt((x(8) - x(6)).^2 + (x(9) - x(7)).^2);
theta1 = acos((x(4).^2 - l7.^2 - strutLen.^2) ./ (-2.*l7.*strutLen));
theta2 = asin((x(6) - x(8)) ./ l7);
theta3 = pi./2 - theta1 - theta2;
xe = x(8) + strutLen.*cos(theta3);
ye = x(9) - strutLen.*sin(theta3);
E = [xe, ye];

% Find coordinates of C
theta4 = asin((xe - x(6)) ./ x(4));
theta5 = acos((x(5).^2 - x(3).^2 - x(4).^2) ./ (-2.*x(3).*x(4)));
theta6 = pi./2 - theta4 - theta5;
xc = x(6) + x(3).*cos(theta6);
yc = x(7) + x(3).*sin(theta6);
C = [xc, yc];

% Find coordinates of B
l6 = sqrt((xa - xc).^2 + (ya - yc).^2);
theta7 = asin((xc - xa) ./ l6);
theta8 = acos((x(1).^2 - x(2).^2 - l6.^2) ./ (-2.*x(2).*l6));
theta9 = theta8 - theta7;
xb = xc + x(2).*sin(theta9);
yb = yc - x(2).*cos(theta9);
B = [xb, yb];

% Assign D and F
D = [x(6), x(7)];
F = [x(8), x(9)];

end