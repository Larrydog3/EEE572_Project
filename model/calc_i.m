function [ipk,iRMS] = calc_i(f,Va,Vb,N,phi,L)
%CALC_I Calculate peak, RMS, and specific current values of interest for 
% a single-phase-shifted trapezoidal current waveform.
%   
% Inputs:
%   f   - Frequency (Hz)
%   Va  - Input voltage (V)
%   Vb  - Output voltage (V)
%   N   - Turns ratio
%   phi - Phase shift (fraction of period) valid values are -0.5 to 0.5
%   L   - Inductance (H)
%
% Outputs:
%   ipk - Peak current (A)
%   iRMS - RMS current (A)
%   i1 - current at time phi
%   i2 - current at time pi

    T = 1./f;
    phi_rad = phi.*pi;
        
    g = Vb./(N.*Va);
    omega = 2.*pi.*f;

    endtime1 = T.*phi_rad./(2.*pi); % phi
    endtime2 = T./2; % pi
    endtime3 = endtime2+endtime1; %pi+phi
    endtime4 = T;

    M1 = Va./(2.*omega.*L);
    M2 = pi.*(1-g);
    M3 = 2.*g.*phi_rad;

    i1 = M1.*(2.*(1+g).*(omega.*endtime1)-M2-M3); 
    i2 = M1.*(2.*(1-g).*(omega.*endtime2)-M2+M3);
    
    ipk = max(abs(i1),abs(i2));
    
    B = 2.*(1+g); 
    C = -pi.*(1-g);
    D = -2.*g.*phi_rad;
    E = 2.*(1-g); 
    F = -pi.*(1-g); 
    H = 2.*g.*phi_rad; 

    blue = ((1/3).*(phi_rad).^3.*B.^2)+((1/2).*(phi_rad).^2.*(2.*B.*C+2.*B.*D))+(phi_rad).*(C.^2+D.^2+2.*C.*D);

    rust = ((1/3).*pi.^3.*E.^2+(1/2).*pi.^2.*(2.*E.*F+2.*E.*H)+pi.*(F.^2+H.^2+2.*F.*H))-...
        ((1/3).*(phi_rad).^3.*E.^2+(1/2).*(phi_rad).^2.*(2.*E.*F+2.*E.*H)+(phi_rad).*(F.^2+H.^2+2.*F.*H)); 

    X = sqrt((1/pi).*(blue+rust));

    iRMS = (Va./(2.*omega.*L)).*X;
end


