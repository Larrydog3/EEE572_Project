function iprim_sliders()
    fig = figure('Name', 'i_prim Waveform Slider', 'NumberTitle', 'off');
    
    fSlider = uicontrol('Style', 'slider', 'Min', 100e3, 'Max', 1e6, 'Value', 400e3, 'Position', [150, 50, 300, 20]);
    VaSlider = uicontrol('Style', 'slider', 'Min', 500, 'Max', 1500, 'Value', 1000, 'Position', [150, 80, 300, 20]);
    VbSlider = uicontrol('Style', 'slider', 'Min', 500, 'Max', 1500, 'Value', 1000, 'Position', [150, 110, 300, 20]);
    NSlider = uicontrol('Style', 'slider', 'Min', 0.5, 'Max', 2, 'Value', 1, 'Position', [150, 140, 300, 20]);
    phiSlider = uicontrol('Style', 'slider', 'Min', -0.5, 'Max', 0.5, 'Value', 0.1, 'Position', [150, 170, 300, 20]);
    LSlider = uicontrol('Style', 'slider', 'Min', 50e-6, 'Max', 300e-6, 'Value', 100e-6, 'Position', [150, 200, 300, 20]);
    
    fLabel = uicontrol('Style', 'text', 'Position', [50, 50, 100, 20], 'String', 'Frequency (Hz)');
    VaLabel = uicontrol('Style', 'text', 'Position', [50, 80, 100, 20], 'String', 'Va (V)');
    VbLabel = uicontrol('Style', 'text', 'Position', [50, 110, 100, 20], 'String', 'Vb (V)');
    NLabel = uicontrol('Style', 'text', 'Position', [50, 140, 100, 20], 'String', 'Turns Ratio');
    phiLabel = uicontrol('Style', 'text', 'Position', [50, 170, 100, 20], 'String', 'Phase Shift');
    LLabel = uicontrol('Style', 'text', 'Position', [50, 200, 100, 20], 'String', 'Inductance (uH)');
    
    fValue = uicontrol('Style', 'text', 'Position', [460, 50, 100, 20], 'String', num2str(get(fSlider, 'Value')));
    VaValue = uicontrol('Style', 'text', 'Position', [460, 80, 100, 20], 'String', num2str(get(VaSlider, 'Value')));
    VbValue = uicontrol('Style', 'text', 'Position', [460, 110, 100, 20], 'String', num2str(get(VbSlider, 'Value')));
    NValue = uicontrol('Style', 'text', 'Position', [460, 140, 100, 20], 'String', num2str(get(NSlider, 'Value')));
    phiValue = uicontrol('Style', 'text', 'Position', [460, 170, 100, 20], 'String', num2str(get(phiSlider, 'Value')));
    LValue = uicontrol('Style', 'text', 'Position', [460, 200, 100, 20], 'String', num2str(get(LSlider, 'Value') * 1e6));
    powerValue = uicontrol('Style', 'text', 'Position', [460, 230, 100, 20], 'String', 'Power (kW)');
    
    ax = axes('Position', [0.1, 0.4, 0.8, 0.5]);
    
    addlistener(fSlider, 'Value', 'PostSet', @(src, event) updatePlot());
    addlistener(VaSlider, 'Value', 'PostSet', @(src, event) updatePlot());
    addlistener(VbSlider, 'Value', 'PostSet', @(src, event) updatePlot());
    addlistener(NSlider, 'Value', 'PostSet', @(src, event) updatePlot());
    addlistener(phiSlider, 'Value', 'PostSet', @(src, event) updatePlot());
    addlistener(LSlider, 'Value', 'PostSet', @(src, event) updatePlot());
    
    updatePlot();
    
    function updatePlot()
        f = get(fSlider, 'Value');
        Va = get(VaSlider, 'Value');
        Vb = get(VbSlider, 'Value');
        N = get(NSlider, 'Value');
        phi = get(phiSlider, 'Value');
        L = get(LSlider, 'Value');
        
        set(fValue, 'String', num2str(f));
        set(VaValue, 'String', num2str(Va));
        set(VbValue, 'String', num2str(Vb));
        set(NValue, 'String', num2str(N));
        set(phiValue, 'String', num2str(phi));
        set(LValue, 'String', num2str(L * 1e6));
        
        [times, current_vec] = calc_iprim_wfm(f, Va, Vb, N, phi, L);
        
        % note the abs(phi) to make the power calculation correct
        % for both positive and negative values of phi
        pout = Va*Vb*phi*(1 - abs(phi)) / (2 * f * L * N);
        set(powerValue, 'String', ['Power: ', num2str(pout / 1e3), ' kW']);
        
        plot(ax, times, current_vec);
        title(ax, 'i_{prim} Waveform');
        xlabel(ax, 'Time (s)');
        ylabel(ax, 'Current (A)');
        grid(ax, 'on');
        
        % Label the points with their enumeration
        for i = 1:length(times)
            text(ax, times(i), current_vec(i), ['(', num2str(i), '), ', num2str(times(i)), ',', num2str(current_vec(i))]);
        end
    end
end
