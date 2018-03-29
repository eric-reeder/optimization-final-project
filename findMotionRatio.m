function m = findMotionRatio(x, strutLen, maxStrutLen)

wheelTravel = calculateGeometry(x, strutLen)(2)(2) - calculateGeometry(x, maxStrutLen)(2)(2);
m = (maxStrutLen - strutLen)./(wheelTravel);

end