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
[i_pk,iRMS] = calc_i(f,Va_mesh,Vb,N,phi_mesh,L);

figure;
hold on;

surf(Va_mesh, phi_mesh, i_pk, 'FaceAlpha', 0.5);
surf(Va_mesh, phi_mesh, iRMS, 'FaceAlpha', 0.5, 'FaceColor', 'red');
xlabel('Va (V)');
ylabel('phi');
zlabel('ipk (A)');
title('ipk and iRMS vs Va and phi with load lines');

R_load_values = [500, 1e3, 5e3, 10e3];
for R_load = R_load_values
    phi_w_load = Vb * 2 * f * L ./ (R_load .* N .* Va);
    iout_rload = Vb / R_load;
    [i_pk_traj, iRMS_traj] = calc_i(f,Va,Vb,N,phi_w_load,L);
    % plot a line for the resistive load
    plot3(Va, phi_w_load, i_pk_traj, 'LineWidth', 2);
end
legend_labels = arrayfun(@(R) sprintf('R_L = %.0f', R), R_load_values, 'UniformOutput', false);
legend(["i_pk", "iRMS", legend_labels], 'Location', 'best');
colorbar;
