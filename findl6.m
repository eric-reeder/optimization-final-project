function l6 = findl6(x,strutLen)

C = findC(x, strutLen);
l6 = sqrt(C(1).^2 + C(2).^2);

end