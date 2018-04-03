function l6 = findl6(x,strutLen)

[A, B, C, D, E, F] = calculateGeometry(x, strutLen);
l6 = sqrt((C(1) - A(1)).^2 + (C(2) - A(2)).^2);

end