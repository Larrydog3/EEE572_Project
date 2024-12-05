function [G_phi_to_vo] = GAM_G_phi_to_vo_tf_recreate_results_Dubey(dab_params)

%Dubey, Ashwini Kumar, and N. Lakshminarasamma. “Modeling of Series Resonant Dual Active Bridge Converter for DC Microgrid Application.”...
%In 2022 IEEE International Conference on Environment and Electrical Engineering and 2022 IEEE Industrial and Commercial Power Systems...
%Europe (EEEIC / I&CPS Europe), 1–6. Prague, Czech Republic: IEEE, 2022. https://doi.org/10.1109/EEEIC/ICPSEurope54979.2020.98546 

syms s C_2 C_r R_L L N ILR1 ILI1 fsw Phi R_eq V_2_0;
omega_s = 2 * pi * fsw;

A = ...
[           -R_eq/L                                 omega_s                         2*sin(Phi*pi)/(N*L*pi)             -1/L                     0       ; 
            -omega_s                                -R_eq/L                         2*cos(Phi*pi)/(N*L*pi)               0                    -1/L      ;
    -4*sin(Phi*pi)/(N*C_2*pi)                -4*cos(Phi*pi)/(N*C_2*pi)                   -1/(C_2*R_L)                    1                      0       ;
             1/C_r                                     0                                      0                          0                   omega_s    ;
               0                                     1/C_r                                    0                      -omega_s                   0       ];

B = [           (2*V_2_0*cos(Phi*pi))/(N*L)                             ; 
                (-2*V_2_0*sin(Phi*pi))/(N*L)                            ;
    ((-4*ILR1*cos(Phi*pi))/(N*C_2))+((4*ILI1*sin(Phi*pi))/(N*C_2))      ;
                                0                                       ;
                                0                                       ];
C = [0 0 1 0 0];

G_phi_to_vo_sym = C*(s*eye(5) - A)^-1 * B;

% Substitute numerical values into the symbolic transfer function
G_phi_to_vo_sub = subs(G_phi_to_vo_sym, ...
    [C_2 C_r R_L L N ILR1 ILI1 fsw Phi R_eq V_2_0], ...
    [dab_params.C_out, ...
    dab_params.C_r, ...
    dab_params.R_L, ...
    dab_params.L, ...
    dab_params.N, ...
    dab_params.ILR_0, ...
    dab_params.ILI_0 ...
    dab_params.fsw, ...
    dab_params.Phi, ...
    dab_params.R_eq, ...
    dab_params.V_o_0]);

% Get the numerator and denominator of the substituted symbolic transfer function
[Num_sym, Den_sym] = numden(G_phi_to_vo_sub);

% Convert symbolic expressions into numeric polynomial coefficients
Num_coeffs = double(fliplr(coeffs(Num_sym, s))); % Flip for descending powers
Den_coeffs = double(fliplr(coeffs(Den_sym, s)));

% Create the transfer function
G_phi_to_vo = tf(Num_coeffs, Den_coeffs);
end
