function x = genStartPoint(minLinkLen,maxLinkLen,minBellcrankLen,...
    maxBellcrankLen,minTabLen,maxTabLen,xdTube,ydTube,xfTube,yfTube,...
    minStrutLen,maxStrutLen)

x6 = (xdTube + minTabLen) + ((xdTube+maxTabLen) - (xdTube+minTabLen)).*rand(1,1);
x7 = (ydTube + minTabLen) + ((ydTube+maxTabLen) - (ydTube+minTabLen)).*rand(1,1);
x8 = (xfTube + minTabLen) + ((xfTube+maxTabLen) - (xfTube+minTabLen)).*rand(1,1);
x9 = (yfTube + minTabLen) + ((yfTube+maxTabLen) - (yfTube+minTabLen)).*rand(1,1);

l7 = sqrt((x8 - x6).^2 + (x9 - x7).^2);
x4max = l7 + minStrutLen;
x4min = max([abs(l7 - minStrutLen), abs(maxStrutLen - l7)]);
x4 = x4min + (x4max - x4min).*rand(1,1);

x5 = minBellcrankLen + (maxBellcrankLen - minBellcrankLen).*rand(1,1);

x3min = abs(x5 - x4);
x3max = x5 + x4;
x3 = x3min + (x3max - x3min).*rand(1,1);

x2 = minLinkLen + (maxLinkLen - minLinkLen).*rand(1,1);

xTemp = [0; x2; x3; x4; x5; x6; x7; x8; x9];
l6Len = @(strutLen) findl6(xTemp, strutLen);
[minls,l6min] = fminbnd(l6Len,minStrutLen,maxStrutLen);
[maxls,l6max] = fminbnd(@(strutLen)-l6Len(strutLen),minStrutLen,maxStrutLen);
l6max = -l6max;

x1min = max([abs(l6min - x2), abs(l6max - x2)]);
x1max = l6max + x2;
x1 = x1min + (x1max - x1min).*rand(1,1);

x = [x1; x2; x3; x4; x5; x6; x7; x8; x9];

end