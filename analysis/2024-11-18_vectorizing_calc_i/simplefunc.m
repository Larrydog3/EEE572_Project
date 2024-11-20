function [z1, z2] = simplefunc(x,y,phi)
z1 = x.^2 + y.^2;
z2 = sin(x) .* y.^2 * sqrt(phi);
end