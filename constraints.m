function [cIneq, cEq] = constraints(x,minStrutLen,maxStrutLen,rideStrutLen,...
    xdTube,ydTube,xfTube,yfTube,xgRide,ygRide,minTabLen,maxTabLen,...
    maxBellcrankLen)

numIneqConstraints = 27;
cIneq = zeros(numIneqConstraints, 1);
cEq = [];

% Bellcrank mounting point constraints
dTabLen = sqrt((x(6)-xdTube).^2 + (x(7)-ydTube).^2);
cIneq(1) = -x(6) + xdTube;
cIneq(2) = -dTabLen + minTabLen;
cIneq(3) = dTabLen - maxTabLen;

% Strut mounting point constraints
fTabLen = sqrt((x(8)-xfTube).^2 + (x(9)-yfTube).^2);
cIneq(4) = -x(8) + xfTube;
cIneq(5) = -fTabLen + minTabLen;
cIneq(6) = fTabLen - maxTabLen;

% Link lengths all positive constrints
cIneq(7) = -x(1);
cIneq(8) = -x(2);
cIneq(9) = -x(3);
cIneq(10) = -x(4);
cIneq(11) = -x(5);

% Calcluate max and min lengths of l6
l6Len = @(strutLen) findl6(x, strutLen);
[minls,minl6] = fminbnd(l6Len,minStrutLen,maxStrutLen);
[maxls,maxl6] = fminbnd(@(strutLen)-l6Len(strutLen),minStrutLen,maxStrutLen);
maxl6 = -maxl6;

% Triangle ABC is valid
cIneq(12) = x(1) - x(2) - minl6;
cIneq(13) = x(2) - x(1) - minl6;
cIneq(14) = maxl6 - x(1) - x(2);

% Triangle CDE is valid
cIneq(15) = x(3) - x(4) - x(5);
cIneq(16) = x(4) - x(3) - x(5);
cIneq(17) = x(5) - x(3) - x(4);

% Calculate l7
l7 = sqrt((x(8) - x(6)).^2 + (x(9) - x(7)).^2);

% Triangle DEF is valid
cIneq(18) = x(4) - l7 - minStrutLen;
cIneq(19) = l7 - x(4) - minStrutLen;
cIneq(20) = maxStrutLen - x(4) - l7;

% Pushrod to control arm connection point constraints
[A, B, C, D, E, F] = calculateGeometry(x, rideStrutLen);
gTabLen = sqrt((B(1) - xgRide).^2 + (B(2) - ygRide).^2);
cIneq(21) = B(1) - xgRide;
cIneq(22) = ygRide - B(2);
cIneq(23) = minTabLen - gTabLen;
cIneq(24) = gTabLen - maxTabLen;

% Bellcrank lengths less than maximum
cIneq(25) = x(3) - maxBellcrankLen;
cIneq(26) = x(4) - maxBellcrankLen;
cIneq(27) = x(5) - maxBellcrankLen;

% Bellcrank does not intersect chassis tube
% N = 10;
% strutLen = linspace(minStrutLen, maxStrutLen, N+1);
% strutLen = strutLen(1:end-1); % remove NaN at end
% rTube = 25.4;
% 
% cIneq(28) = 0;
% % syms xSolu ySolu
% for i = 1:N
%     [A, B, C, D, E, F] = calculateGeometry(x, strutLen(i));
%     xd = D(1);
%     yd = D(2);
%     xe = E(1);
%     ye = E(2);
% %     eqn1 = (xSolu-xdTube)^2 + (ySolu-ydTube)^2 == rTube^2;
% %     eqn2 = ySolu - yd == ((ye-yd)/(xe-xd))*(xSolu-xd);
% %     sol = solve(eqn1, eqn2, xSolu, ySolu);
%     xSolu = -(xd*ye - xe*yd - (xd*(xd^2*ye + xe^2*yd + yd^2*ydTube + ydTube*ye^2 + yd*(rTube^2*xd^2 - 2*rTube^2*xd*xe + rTube^2*xe^2 + rTube^2*yd^2 - 2*rTube^2*yd*ye + rTube^2*ye^2 - xd^2*ydTube^2 + 2*xd^2*ydTube*ye - xd^2*ye^2 + 2*xd*xdTube*yd*ydTube - 2*xd*xdTube*yd*ye - 2*xd*xdTube*ydTube*ye + 2*xd*xdTube*ye^2 - 2*xd*xe*yd*ydTube + 2*xd*xe*yd*ye + 2*xd*xe*ydTube^2 - 2*xd*xe*ydTube*ye - xdTube^2*yd^2 + 2*xdTube^2*yd*ye - xdTube^2*ye^2 + 2*xdTube*xe*yd^2 - 2*xdTube*xe*yd*ydTube - 2*xdTube*xe*yd*ye + 2*xdTube*xe*ydTube*ye - xe^2*yd^2 + 2*xe^2*yd*ydTube - xe^2*ydTube^2)^(1/2) - ye*(rTube^2*xd^2 - 2*rTube^2*xd*xe + rTube^2*xe^2 + rTube^2*yd^2 - 2*rTube^2*yd*ye + rTube^2*ye^2 - xd^2*ydTube^2 + 2*xd^2*ydTube*ye - xd^2*ye^2 + 2*xd*xdTube*yd*ydTube - 2*xd*xdTube*yd*ye - 2*xd*xdTube*ydTube*ye + 2*xd*xdTube*ye^2 - 2*xd*xe*yd*ydTube + 2*xd*xe*yd*ye + 2*xd*xe*ydTube^2 - 2*xd*xe*ydTube*ye - xdTube^2*yd^2 + 2*xdTube^2*yd*ye - xdTube^2*ye^2 + 2*xdTube*xe*yd^2 - 2*xdTube*xe*yd*ydTube - 2*xdTube*xe*yd*ye + 2*xdTube*xe*ydTube*ye - xe^2*yd^2 + 2*xe^2*yd*ydTube - xe^2*ydTube^2)^(1/2) + xd*xdTube*yd - xd*xe*yd - xd*xdTube*ye - xdTube*xe*yd - xd*xe*ye + xdTube*xe*ye - 2*yd*ydTube*ye))/(xd^2 - 2*xd*xe + xe^2 + yd^2 - 2*yd*ye + ye^2) + (xe*(xd^2*ye + xe^2*yd + yd^2*ydTube + ydTube*ye^2 + yd*(rTube^2*xd^2 - 2*rTube^2*xd*xe + rTube^2*xe^2 + rTube^2*yd^2 - 2*rTube^2*yd*ye + rTube^2*ye^2 - xd^2*ydTube^2 + 2*xd^2*ydTube*ye - xd^2*ye^2 + 2*xd*xdTube*yd*ydTube - 2*xd*xdTube*yd*ye - 2*xd*xdTube*ydTube*ye + 2*xd*xdTube*ye^2 - 2*xd*xe*yd*ydTube + 2*xd*xe*yd*ye + 2*xd*xe*ydTube^2 - 2*xd*xe*ydTube*ye - xdTube^2*yd^2 + 2*xdTube^2*yd*ye - xdTube^2*ye^2 + 2*xdTube*xe*yd^2 - 2*xdTube*xe*yd*ydTube - 2*xdTube*xe*yd*ye + 2*xdTube*xe*ydTube*ye - xe^2*yd^2 + 2*xe^2*yd*ydTube - xe^2*ydTube^2)^(1/2) - ye*(rTube^2*xd^2 - 2*rTube^2*xd*xe + rTube^2*xe^2 + rTube^2*yd^2 - 2*rTube^2*yd*ye + rTube^2*ye^2 - xd^2*ydTube^2 + 2*xd^2*ydTube*ye - xd^2*ye^2 + 2*xd*xdTube*yd*ydTube - 2*xd*xdTube*yd*ye - 2*xd*xdTube*ydTube*ye + 2*xd*xdTube*ye^2 - 2*xd*xe*yd*ydTube + 2*xd*xe*yd*ye + 2*xd*xe*ydTube^2 - 2*xd*xe*ydTube*ye - xdTube^2*yd^2 + 2*xdTube^2*yd*ye - xdTube^2*ye^2 + 2*xdTube*xe*yd^2 - 2*xdTube*xe*yd*ydTube - 2*xdTube*xe*yd*ye + 2*xdTube*xe*ydTube*ye - xe^2*yd^2 + 2*xe^2*yd*ydTube - xe^2*ydTube^2)^(1/2) + xd*xdTube*yd - xd*xe*yd - xd*xdTube*ye - xdTube*xe*yd - xd*xe*ye + xdTube*xe*ye - 2*yd*ydTube*ye))/(xd^2 - 2*xd*xe + xe^2 + yd^2 - 2*yd*ye + ye^2))/(yd - ye);
%     if isreal(xSolu)
%         cIneq(28) = 1;
%     end
% end


end