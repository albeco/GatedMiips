function y = gaussian(x,sigma)
y = exp(-x.^2 / sigma^2);
end