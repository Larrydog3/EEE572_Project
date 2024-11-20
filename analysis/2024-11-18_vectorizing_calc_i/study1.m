clear;
close all;

x = -1.5:0.1:1.5;
y = -1.5:0.1:1.5;
phi = 0:0.1:2*pi;
phi_nom = 0.1;

[x_mesh, y_mesh] = meshgrid(x,y);

% study 1: evaluate z2 for some fixed phi
[~, z2] = simplefunc(x_mesh, y_mesh, phi_nom);

figure;
surf(x_mesh, y_mesh, z2);
xlabel('x');
ylabel('y');
zlabel('z2');
title('z2 vs x and y');
colorbar;

