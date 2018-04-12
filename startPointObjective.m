function f = startPointObjective(x,constraintFun)

c = constraintFun(x);
residuals = 0;

for i = 1:length(c)
    if c(i) > 0
        residuals = residuals + c(i).^2;
    end
end

f = residuals;

end