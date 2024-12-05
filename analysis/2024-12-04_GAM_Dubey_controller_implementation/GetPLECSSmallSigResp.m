function [results] = GetPLECSSmallSigResp(dab_params)
%GETPLECSSMALLSIGRESP Summary of this function goes here
    % Run PLECS simulation
    proxy = jsonrpc('http://localhost:1080', 'Timeout', 10);
    % get the path the directory containing this function declaration, not the pwd
    path = fileparts(mfilename('fullpath'));
    model_name = 'dab_small_signal_Dubey';
    proxy.plecs.load([path '/' model_name '.plecs']);
    proxy.plecs.get(model_name);

    mdlVars = struct( ...
        'f', dab_params.fsw, ...
        'Va', dab_params.V_in_0, ...
        'Vb', dab_params.V_o_0, ...
        'phi', dab_params.Phi, ...
        'N', dab_params.N, ...
        'w_z', dab_params.w_z, ...
        'w_p', dab_params.w_p, ...
        'Kc', dab_params.Kc, ...
        'L', dab_params.L);


    solverOpts = struct();
    simStruct = struct('ModelVars', mdlVars, 'SolverOpts', solverOpts);
    results = proxy.plecs.analyze(model_name, 'Impulse Response Analysis', simStruct);


end


