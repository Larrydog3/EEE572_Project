proxy = jsonrpc('http://localhost:1080', 'Timeout', 0.5);
path = pwd;
model_name = 'dab';
proxy.plecs.load([path '/' model_name '.plecs']);
proxy.plecs.get(model_name);
mdlVars = struct( ...
    'Vin', 1000, ...
    'f', 400e3 ...
);
solverOpts = struct('TimeSpan', 1e-4);
simStruct = struct('ModelVars', mdlVars, 'SolverOpts', solverOpts);
results = proxy.plecs.simulate(model_name, simStruct);

time = results.Time;
vLlk = results.Values(1, :);
iLlk = results.Values(2, :);
vin_meas = results.Values(3, :);
iin_meas = results.Values(4, :);

plot(time, iLlk);
xlabel('Time (s)');
ylabel('Current (A)');
title('Inductor Current');
grid on;