classdef test_calc_iprim_wfm < matlab.unittest.TestCase
    methods (Test)
        function testCase1(testCase)
            [times1, current_vec1] = calc_iprim_wfm(400e3, 1000, 1000, 1, 0.1, 100e-6);
            testCase.verifyWaveform(times1, current_vec1, 'Test Case 1', 'test_case_1.png');
        end

        function testCase2(testCase)
            [times1, current_vec1] = calc_iprim_wfm(400e3, 1000, 800, 1, 0.1, 100e-6);
            testCase.verifyWaveform(times1, current_vec1, 'Test Case 2', 'test_case_2.png');
        end

        function testCase3(testCase)
            [times1, current_vec1] = calc_iprim_wfm(400e3, 1000, 1000, 1, -0.1, 100e-6);
            testCase.verifyWaveform(times1, current_vec1, 'Test Case 3', 'test_case_3.png');
        end
    end

    methods
        function verifyWaveform(testCase, times, current_vec, titleStr, fileName)
            figure;
            plot(times, current_vec);
            title(titleStr);
            xlabel('Time');
            ylabel('Current');
            % label the points with their enumeration
            for i = 1:length(times)
                text(times(i), current_vec(i), ['(', num2str(i), '), ', num2str(times(i)), ',', num2str(current_vec(i))]);
            end
            saveas(gcf, fileName);

            integral_current = trapz(times, current_vec);
            testCase.verifyLessThanOrEqual(abs(integral_current), 1e-6, 'Integral of current_vec is not close to zero');
            testCase.verifyTrue(issorted(times), 'Time vector is not monotonically increasing');

            testCase.addTeardown(@close, gcf);
        end
    end
end
