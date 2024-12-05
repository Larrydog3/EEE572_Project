clear;
close all;
phi = -0.5:0.01:0.5;
y = 4.*phi.*(1-abs(phi));
figure;
plot(phi,y)
title("Normalized P vs \phi")
xlabel("\phi")
ylabel("Normalized P")
