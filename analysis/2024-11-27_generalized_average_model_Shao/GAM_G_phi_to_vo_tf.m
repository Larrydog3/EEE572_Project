function [G_phi_to_vo] = GAM_G_phi_to_vo_tf(dab_params)
%GAM_G_PHI_TO_VO_TF Implements the Generalized Average Model description on
% p. 4 of Shao.
% S. Shao et al., "Modeling and Advanced Control of Dual-Active-Bridge DC–DC Converters: A Review," IEEE Trans. Power Electron., vol. 37, no. 2, pp. 1524–1547, Feb. 2022, doi: 10.1109/TPEL.2021.3108157.

syms s C_2 R_L L N ILR1 ILI1 fsw Phi R_eq V_2_0;
omega_s = 2 * pi * fsw;

A = ...
[ -2/(R_L*C_2)       -8*N*sin(2*pi*Phi)/(pi*C_2)    -8*N*cos(2*pi*Phi)/(pi*C_2); 
  4*N*sin(2*pi*Phi)/(pi*L)  -2*R_eq/L               2*omega_s;
  4*N*cos(2*pi*Phi)/(pi*L)  -2*omega_s              -2*R_eq/L];

B = [8*(ILI1*sin(2*pi*Phi)-ILR1*cos(2*pi*Phi))/C_2; 
    4*V_2_0*sin(2*pi*Phi)/L;
    -4*V_2_0*sin(2*pi*Phi)/L;];
C = [1 0 0];

G_phi_to_vo_sym = C*(s*eye(3) - A)^-1 * B;

% Substitute numerical values into the symbolic transfer function
G_phi_to_vo_sub = subs(G_phi_to_vo_sym, ...
    [C_2 R_L L N ILR1 ILI1 fsw Phi R_eq V_2_0], ...
    [dab_params.C_out, ...
    dab_params.R_L, ...
    dab_params.L, ...
    dab_params.N, ...
    dab_params.ILR_0, ...
    dab_params.ILI_0 ...
    dab_params.fsw, ...
    dab_params.Phi, ...
    dab_params.R_eq ...
    dab_params.V_o_0]);

% Get the numerator and denominator of the substituted symbolic transfer function
[Num_sym, Den_sym] = numden(G_phi_to_vo_sub);

% Convert symbolic expressions into numeric polynomial coefficients
Num_coeffs = double(fliplr(coeffs(Num_sym, s))); % Flip for descending powers
Den_coeffs = double(fliplr(coeffs(Den_sym, s)));

% Create the transfer function
G_phi_to_vo = tf(Num_coeffs, Den_coeffs);
end

