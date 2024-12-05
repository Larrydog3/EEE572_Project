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

% Labels and title
xlabel('Vin (V)');
ylabel('iout (A)');
zlabel('i_C_RMS (A)');
title('i_C RMS vs Vin and iout for Different \phi_{nom}');
colorbar;
legend(arrayfun(@(phi) sprintf('\\phi_{nom} = %.2f', phi), phi_nom_values, 'UniformOutput', false), ...
       'Location', 'best');
hold off;