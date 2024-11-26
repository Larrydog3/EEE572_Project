classdef test_myPlotDiagnostic < matlab.unittest.TestCase

methods(Test)
    function firstTest(testCase)
        import matlab.unittest.constraints.IsEqualTo;

        % Test should pass!
        actualValue = 1:10;
        expectedValue = 1:10;

        diagnostic = @()myPlotDiagnostic(actualValue, expectedValue);

        testCase.verifyThat(actualValue, IsEqualTo(expectedValue), diagnostic);
    end

    function secondTest(testCase)
        import matlab.unittest.constraints.IsEqualTo;

        % Test should fail with a diagnostic!
        actualValue = [1 2 3 4 12 6 7 8 9 10];
        expectedValue = 1:10;

        diagnostic = @()myPlotDiagnostic(actualValue, expectedValue);

        testCase.verifyThat(actualValue, IsEqualTo(expectedValue), diagnostic);
    end

    function thirdTest(testCase)
        import matlab.unittest.constraints.IsEqualTo;

        % Test should also fail with a diagnostic!
        actualValue = [1 2 3 4 -12 6 7 8 9 10];
        expectedValue = 1:10;

        diagnostic = @()myPlotDiagnostic(actualValue, expectedValue);

        testCase.verifyThat(actualValue, IsEqualTo(expectedValue), diagnostic);
    end
end

end

function myPlotDiagnostic(actualValue, expectedValue)
temporaryFile = tempname;
save(temporaryFile, 'actualValue', 'expectedValue');
fprintf('<a href="matlab:plot([%s], [%s], ''*r'')">Plot Data</a>\n', num2str(expectedValue), num2str(actualValue));
fprintf('<a href="matlab:load(''%s'')">Load data into workspace</a>\n', temporaryFile);
end
