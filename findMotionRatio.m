function m = findMotionRatio(x, strutLen, maxStrutLen)

[A, B, C, D, E, F] = calculateGeometry(x, strutLen);
[maxA, maxB, maxC, maxD, maxE, maxF] = calculateGeometry(x, maxStrutLen);

wheelTravel = B(2) - maxB(2);
m = (maxStrutLen - strutLen)./(wheelTravel);

end