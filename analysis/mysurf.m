clear;
close all;

f = 400e3;
Va = 800:100:1200;
Vb = 1e3;
N = 1; 
phi_nom = pi/6;
phi = pi/12:pi/12:pi/3;
L = 100e-6;
T = 1./f;

[Va_mesh, phi_mesh] = meshgrid(Va, phi);

[i_pk, i_rms, ~, ~, ~, ~, ~, ~, ~, ~] = calc_i(f, Va_mesh, Vb, N, phi_mesh, L);

% Visualize the results
figure;
surf(Va_mesh, phi_mesh, i_pk);
xlabel('Va (Input Voltage)');
ylabel('\phi (Phase)');
zlabel('i_{pk} (Peak Current)');
title('Peak Current vs Input Voltage and Phase');
colorbar;
