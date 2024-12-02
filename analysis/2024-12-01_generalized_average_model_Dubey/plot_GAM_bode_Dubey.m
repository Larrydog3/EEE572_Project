close all;
dp = struct( ...
    'C_out', 1e-6, ... % Output Capacitance (F)
    'R_L', 1e4, ... % Load Resistance (Ohms)
    'L', 100e-6, ... % leakage inductance (H)
    'N', 1, ... % turns ratio
    'V_in_0', 1000, ... % initial condition of input voltage (V)
    'V_o_0', 1000, ... % initial condition of output voltage (V)
    'ILR_0', 0, ... % initial condition of real component of inductor current (A)
    'ILI_0', 0, ... % initial condition of imaginary component of inductor current (A)
    'fsw', 400e3, ... % switching frequency (Hz)
    'Phi', 0.1, ... % value of phi about which the model is linearized
    'R_eq', 0.000, ... % inductor ESR (Ohms)
    'unused', 0.0);

G_phi_to_vo_GAM = GAM_G_phi_to_vo_tf_Dubey(dp);

opts = bodeoptions;
opts.FreqUnits = 'Hz';
bode(G_phi_to_vo_GAM, opts);

h = findall(gcf, 'Type', 'axes');
mag_axis = h(3); % Magnitude plot
phase_axis = h(2); % Phase plot

axes(mag_axis);
semilogx(results.F, Magnitude_exp, "Color", "magenta", LineStyle="--", LineWidth=2);
axes(phase_axis); 
semilogx(results.F, Phase_exp, "Color", "magenta", LineStyle="--", LineWidth=2);

legend("Generalized Average Model (Dubey)");
title("$G_{v_o\phi}(s)=\frac{v_o(s)}{\phi(s)}$", "Interpreter", 'latex');