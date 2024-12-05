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

G_phi_to_vo_GAM_Dubey = GAM_G_phi_to_vo_tf_Dubey(dp)


w_c = 1e3 * 2*pi;
[~,phaseP] = bode(G_phi_to_vo_GAM_Dubey, w_c)
phi_boost = 60-90-(phaseP);

k = tand(phi_boost/2+45);

w_z = w_c/k;
w_p = k*w_c;
s = tf('s');
Gc_unityGain = 1/s*(1+s/w_z)/(1+s/w_p);

[magGcu,~] = bode(G_phi_to_vo_GAM_Dubey*Gc_unityGain, w_c);
Kc = 1/magGcu;

Gc = Kc*Gc_unityGain;

Gcl = G_phi_to_vo_GAM_Dubey*Gc/(1+G_phi_to_vo_GAM_Dubey*Gc);

dp.w_z = w_z
dp.w_p = w_p
dp.Kc = Kc;

results = GetPLECSSmallSigResp(dp);
Magnitude_exp = 20 * log10(sqrt(results.Gr.^2 + results.Gi.^2));
Phase_exp = atan2(results.Gi, results.Gr) * (180 / pi); % Phase in degrees
Phase_exp = Phase_exp -360;

opts = bodeoptions;
opts.FreqUnits = 'Hz';
bode(Gcl,opts)
hold on;
h = findall(gcf, 'Type', 'axes');
mag_axis = h(3); % Magnitude plot
phase_axis = h(2); % Phase plot

axes(mag_axis);
semilogx(results.F, Magnitude_exp, "Color", "magenta", LineStyle="--", LineWidth=2);
axes(phase_axis); 
semilogx(results.F, Phase_exp, "Color", "magenta", LineStyle="--", LineWidth=2);
