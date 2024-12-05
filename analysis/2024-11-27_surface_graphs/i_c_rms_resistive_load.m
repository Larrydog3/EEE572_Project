close all;

% Inputs
f = 400e3;
Va = 800:10:1200;
Vb = 1e3;
N = 1; 
phi_nom_values = linspace(0.0, 0.5, 6); % Ten values for phi_nom
L = 100e-6;

% Create the meshes for Va and iout
iout = -1:0.01:1;
[Va_mesh2, iout_mesh] = meshgrid(Va, iout);

% Initialize the figure
figure;
hold on;
colormap(parula(length(phi_nom_values))); % Use a colormap with distinguishable colors
colors = lines(length(phi_nom_values)); % Generate distinct colors for each surface

for idx = 1:length(phi_nom_values)
    phi_nom = phi_nom_values(idx); % Current phi_nom
    % Compute i_c_RMS for the current phi_nom
    i_c_RMS = calc_i_c_rms(f, Va_mesh2, Vb, N, phi_nom, L, iout_mesh);
    
    % Plot the surface
    surf(Va_mesh2, iout_mesh, i_c_RMS, ...
        'FaceAlpha', 0.5, 'EdgeColor', 'none', 'FaceColor', colors(idx, :));
end


R_load_values = [500, 1e3, 5e3, 10e3];
% x = -b +/- sqrt(b^2 - 4 * a * c) / 2a
% a = 1;
% b = -1;
% c = Vb * 2 * f * L ./ (R_load .* N  .* Va);
% arg = sqrt(b.^2 - 4.* a .* c) ./ (2.*a);
for R_load = R_load_values
    % phi_w_load = -b - arg;
    phi_w_load = Vb * 2 * f * L ./ (R_load .* N .* Va);
    iout_rload = Vb / R_load;
    i_c_RMS_traj = calc_i_c_rms(f, Va, Vb, N, phi_w_load, L, iout_rload);
    
    % plot a line for the resistive load
    plot3(Va, iout_rload * ones(size(Va)), i_c_RMS_traj, 'LineWidth', 2);
end
% label the resistive load lines
legend_labels = arrayfun(@(R) sprintf('R_L = %.0f', R), R_load_values, 'UniformOutput', false);
       

% Labels and title
xlabel('Vin (V)');
ylabel('iout (A)');
zlabel('i_C_RMS (A)');
title('i_C RMS for different R_L superimposed on previous visualization');
colorbar;
legend([arrayfun(@(phi) sprintf('\\phi_{nom} = %.2f', phi), phi_nom_values, 'UniformOutput', false), ...
       legend_labels], 'Location', 'best');
hold off;