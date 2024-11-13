function tests = test_calculateL
    tests = functiontests(localfunctions);
end

function test1(testCase)
    [L, phiRange] = calculateL(1000, 1000, 400e3, 1000);
    verifyEqual(testCase, L, 300e-6, 'AbsTol', 1e-6);
    verifyEqual(testCase, phiRange, [0, 0.4], 'AbsTol', 1e-6);
end
