close all;
dp = struct( ...
    'C_out', 30e-6, ... % Output Capacitance (F)
    'C_r', 0.34196e-6, ... % Output Capacitance (F)
    'R_L', 128, ... % Load Resistance (Ohms)
    'L', 8.9636e-6, ... % leakage inductance (H)
    'N', 5, ... % turns ratio
    'V_in_0', 160, ... % initial condition of input voltage (V)
    'V_o_0', 800, ... % initial condition of output voltage (V)
    'ILR_0', 0, ... % initial condition of real component of inductor current (A)
    'ILI_0', 0, ... % initial condition of imaginary component of inductor current (A)
    'fsw', 100e3, ... % switching frequency (Hz)
    'Phi', 0.076, ... % value of phi about which the model is linearized
    'R_eq', 0.1, ... % inductor ESR (Ohms)
    'unused', 0.0);

G_phi_to_vo_GAM = GAM_G_phi_to_vo_tf_recreate_results_Dubey(dp);

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