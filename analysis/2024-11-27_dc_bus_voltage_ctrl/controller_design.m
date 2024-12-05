clear;
close all;
clc;

dp = struct( ...
    'C_out', 0.1e-6, ... % Output Capacitance (F)
    'R_L', 1e4, ... % Load Resistance (Ohms)
    'L', 100e-6, ... % leakage inductance (H)
    'N', 1, ... % turns ratio
    'V_in_0', 1000, ... % initial condition of input voltage (V)
    'V_o_0', 1000, ... % initial condition of output voltage (V)
    'ILR_0', 0, ... % initial condition of real component of inductor current (A)
    'ILI_0', 0, ... % initial condition of imaginary component of inductor current (A)
    'fsw', 400e3, ... % switching frequency (Hz)
    'Phi', 0.0, ... % value of phi about which the model is linearized
    'R_eq', 0.000, ... % inductor ESR (Ohms)
    'unused', 0.0);

% reduced order model
G_phi_to_vo = dp.V_in_0 * dp.N * (1 - 4 * dp.Phi)/(dp.fsw * dp.L) * ...
tf([dp.R_L], [dp.R_L*dp.C_out, 1]);

% type II
k  = tand(80/2 + 45);
w_c = 4e3 * 2*pi;
w_z = w_c / k;
w_p = k * w_c;

mag_g = abs(evalfr(G_phi_to_vo, 1i*w_c));
K_c = w_c / (k * mag_g);