classdef test_calc_i < matlab.unittest.TestCase
    properties (TestParameter)
        f = {400e3, 400e3, 400e3};
        Va = {1000, 1000, 1000};
        Vb = {1000, 1000, 800};
        N = {1, 1, 1};
        phi = {0.1, -0.1, 0.1};
        L = {100e-6, 100e-6, 100e-6};
    end

    methods (Test, ParameterCombination='sequential')
        function testConsistency(testCase, f, Va, Vb, N, phi, L)
            runSimulation(testCase, f, Va, Vb, N, phi, L);
        end
    end

    methods
        function runSimulation(testCase, f, Va, Vb, N, phi, L)
            import matlab.unittest.constraints.IsEqualTo;
            import matlab.unittest.constraints.RelativeTolerance;

            % Calculate expected values using calc_i.m
            [ipk, iRMS] = calc_i(f, Va, Vb, N, phi, L);

            % Run PLECS simulation
            proxy = jsonrpc('http://localhost:1080', 'Timeout', 0.5);
            path = pwd;
            model_name = 'test_calc_i_1';
            proxy.plecs.load([path '/' model_name '.plecs']);
            proxy.plecs.get(model_name);
            mdlVars = struct( ...
                'f', f, ...
                'Va', Va, ...
                'Vb', Vb, ...
                'phi', phi, ...
                'L', L);
            solverOpts = struct('TimeSpan', 1/f);
            simStruct = struct('ModelVars', mdlVars, 'SolverOpts', solverOpts);
            results = proxy.plecs.simulate(model_name, simStruct);

            % Extract results
            time_sim = results.Time;
            iL_sim = results.Values(1, :);
            
            % Normalize to have zero average to avoid the chicken-and-egg
            % problem of setting an iL initial condition in PLECS.
            iL_sim = iL_sim - mean(iL_sim);

            ipk_sim = max(iL_sim);
            % use the trapezoidal rule to calculate the RMS value
            irms_sim = sqrt(trapz(time_sim, iL_sim.^2)/(time_sim(end)-time_sim(1)));

            diagnostic = @()plotDiag(testCase,results);
            % Verify results
            testCase.verifyThat(ipk, IsEqualTo(ipk_sim, "Within", RelativeTolerance(0.01)), diagnostic);

            % irms is failing. I tried using the following eqn from the
            % homework solutions.
            % iRMS = (Va./(omega.*L)).*sqrt((phi_rad.^3./(3*pi) + (phi_rad.^2.*(pi - phi_rad))./pi ));
            testCase.verifyThat(iRMS, IsEqualTo(irms_sim, "Within", RelativeTolerance(0.01)))
        end
        function plotDiag(testCase, results)
            figure;
            plot(results.Time, results.Values(1,:));
            xlabel('Time');
            ylabel('Value');
            saveas(gcf, "fail");
            testCase.addTeardown(@close, gcf);
        end
    end
end

