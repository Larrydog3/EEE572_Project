
Vin = [800 1200];
Vout = 1000;
f_sw = 400e3;
N = 1; % turns ratio
Phi_max = 0.2;
NominalPower = 1000; % W

Io_max = NominalPower / Vout;
L = Vin .* Phi_max .* (1-Phi_max) ./ (2 .* Io_max .* f_sw .* N);

L_choice = min(L)