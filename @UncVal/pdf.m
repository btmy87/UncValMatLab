function y = pdf(obj, x)
%PDF Return probability distribution evaluated at x

s = std(obj);
z = (x - obj.val)./s;
y = 1.0./(s.*sqrt(2.*pi)).*exp(-0.5.*z.^2);

end

