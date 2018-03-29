function f = objectiveFun(x, minStrutLen, maxStrutLen, N)

motionRatio = zeros(N,1);
strutLen = linspace(minStrutLen, maxStrutLen, N);

for i = 1:N
   motionRatio(i) = findMotionRatio(x, strutLen(i), maxStrutLen);
end

meanMotionRatio = mean(motionRatio);
residualSum = sum((motionRatio - meanMotionRatio).^2);
f = sqrt(residualSum./(N-1));

end