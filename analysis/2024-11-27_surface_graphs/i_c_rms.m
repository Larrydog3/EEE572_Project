
%inputs
f = 400e3;
Va = 800:10:1200;
Vb = 1e3;
N = 1; 
%phi = 0.4;
phi = -0.4:0.01:0.4;
L = 100e-6;
T = 1./f;

[Va_mesh, phi_mesh] = meshgrid(Va,phi);

iout = -1:0.01:1;
[Va_mesh2, iout_mesh] = meshgrid(Va,iout);
phi_nom = 0.2;
i_c_RMS = calc_i_c_rms(f, Va_mesh2, Vb, N, phi_nom, L, iout_mesh);

figure;
hold on;
surf(Va_mesh2, iout_mesh, i_c_RMS, 'FaceAlpha', 0.5);
xlabel('Va (V)');
ylabel('iout (A)');
zlabel('i_C_RMS (A)');
title('i_C_RMS vs Va and iout');
colorbar;