clear all; 
close all; 
clc;

%inputs
f = 400e3;
Va = [800:10:1200];
Vb = 1e3;
N = 1; 
%phi = 0.4;
phi = [0:0.01:0.4];
L = 100e-6;
T = 1./f;

[Va_mesh, phi_mesh] = meshgrid(Va,phi);

% study 1: evaluate z2 for some fixed phi
[i_pk,iRMS] = calc_i(f,Va_mesh,Vb,N,phi_mesh,L);

figure;
hold on;
surf(Va_mesh, phi_mesh, i_pk, 'FaceAlpha', 0.5);
surf(Va_mesh, phi_mesh, iRMS, 'FaceAlpha', 0.5, 'FaceColor', 'red');
xlabel('Va (V)');
ylabel('phi');
zlabel('ipk (A)');
title('ipk and iRMS vs Va and phi');
legend('ipk', 'iRMS');
colorbar;
