function [L, phiRange] = calculateL(Vin, Vout, F_sw, NominalPower)
% calculateL - Calculates the inductance (L) and the range of phase shift (phiRange) 
%              for a given power converter setup.
%
% Syntax:  [L, phiRange] = calculateL(vin, Vout, F_sw, NominalPower)
%
% Inputs:
%   vin          - Input voltage [scalar]
%   Vout         - Output voltage [scalar]
%   F_sw         - Switching frequency [scalar]
%   NominalPower - Nominal power rating [scalar]
%
% Outputs:
%   L           - Inductance value required [scalar]
%   phiRange    - Range of phase shift [scalar, scalar] (e.g., [phi_min, phi_max])
%
% Example:
%   [L, phiRange] = calculateL(48, 12, 100e3, 200)
%
%   This function calculates the inductance required for a given input voltage,
%   output voltage, switching frequency, and nominal power rating.
%
% Notes:
%   - Ensure input values are in appropriate units.
%   - Function currently only supports scalar inputs.

D_max = 0.4; % Maximum duty cycle
Io_max = NominalPower / Vout; % Maximum output current
N = 1; % turns ratio
L = Vin .* D_max .* (1-D_max) ./ (2 .* Io_max .* F_sw .* N);
phiRange = [0, D_max];

end