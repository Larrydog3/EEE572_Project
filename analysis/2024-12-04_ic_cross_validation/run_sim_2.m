close all;
dp = struct( ...
    'C_out', 0.1e-6, ... % Output Capacitance (F)
    'C_out_ESR', (1 / (2*pi*400e3*0.1e-6)) * 15e-4, ...
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

proxy = jsonrpc('http://localhost:1080', 'Timeout', 60);
path = fileparts(mfilename('fullpath'));
model_name = 'dab_curious_sudden_dc_on_inductor_does_a_blocking_cap_help';
proxy.plecs.load([path '/' model_name '.plecs']);
proxy.plecs.get(model_name);

mdlVars = struct( ...
    'f', dp.fsw, ...
    'Vin', dp.V_in_0, ...
    'Vb', dp.V_o_0, ...
    'Vo_ref', dp.V_o_0, ...
    'phi', dp.Phi, ...
    'N', dp.N, ...
    'L', dp.L, ...
    'R_L', dp.R_L, ...
    'unused', 0);

solverOpts = struct( ...
    'TimeSpan', 10e-3 ...
);

Va_range = 800:100:1200;
Rload_range = 500:100:1500;

% create a list of simStruct where each element contains a unique combination of Va and Rload
% substitute the values of Va and Rload in the mdlVars struct
optStructs = cell(length(Va_range) * length(Rload_range), 1);
for i = 1:length(Va_range)
    for j = 1:length(Rload_range)
        mdlVars.Vin = Va_range(i);
        mdlVars.R_L = Rload_range(j);
        optStructs{(i-1)*length(Rload_range) + j} = struct('ModelVars', mdlVars, 'SolverOpts', solverOpts);
    end
end

results = proxy.plecs.simulate(model_name, optStructs);

% save the results as a .mat file
save('results.mat', 'results');

% post-process the results.
% extract the last two cycles of the simulation (2/fsw seconds)
% next, calculate the pk-pk value of values(1) and the rms value of values(2)
% store the results as a meshgrid in terms of Va and Rload and plot a surface plot for
% the pk-pk and rms values

pkpk = zeros(length(results), 1);
rms = zeros(length(results), 1);

for i = 1:length(results)
    time = results(i).Time(results(i).Time > (results(i).Time(end) - 10/dp.fsw));
    values = results(i).Values(:, results(i).Time > (results(i).Time(end) - 10/dp.fsw));
    
    % extract the pk-pk of values(1)
    pkpk(i) = max(values(1, :)) - min(values(1, :));
    rms(i) = sqrt(mean(values(2, :).^2));
end

% reshape the pkpk and rms values into a meshgrid
pkpk = reshape(pkpk, length(Rload_range), length(Va_range));
rms = reshape(rms, length(Rload_range), length(Va_range));

figure;
subplot(1, 2, 1);
surf(Va_range, Rload_range, pkpk);
xlabel('Va (V)');
ylabel('Rload (Ohms)');
zlabel('Pk-Pk voltage');
title('Pk-Pk capacitor voltage');

subplot(1, 2, 2);
surf(Va_range, Rload_range, rms);
xlabel('Va (V)');
ylabel('Rload (Ohms)');
zlabel('RMS (A)');
title('RMS capacitor current');


