clear all; 
close all; 
clc;

%inputs
f = 400e3;
%Va = [800:10:1200];
Va = 800;
Vb = 1e3;
N = 1; 
phi = 0.4;
%phi = [0:0.01:0.4];
L = 100e-6;

T = 1./f;
phi = phi.*pi;
    
g = Vb./(N.*Va);
omega = 2.*pi.*f;

endtime1 = T.*phi./(2.*pi); % phi
endtime2 = T./2; % pi
endtime3 = endtime2+endtime1; %pi+phi
endtime4 = T;

M1 = Va./(2.*omega.*L);
M2 = pi.*(1-g);
M3 = 2.*g.*phi;

i0 = M1.*(2.*(1+g).*(omega.*0)-M2-M3);
i1 = M1.*(2.*(1+g).*(omega.*endtime1)-M2-M3); 
i2 = M1.*(2.*(1-g).*(omega.*endtime2)-M2+M3);

% Plot the trapezoid with (t,i) points as follows:
% (0,i0), (endtime1,i1), (endtime2,i2)
figure(1)
plot([0 endtime1 endtime2 endtime3 endtime4],[i0 i1 i2 -i1 -i2],'r')
% label the points as (0,i0), (phi,i1), (pi,i2)
text(0,i0,'(0,i0)')
text(endtime1,i1,'(\phi * T_s / 2,i1)')
text(endtime2,i2,'(T_s / 2,i2)')

xlabel('Time (s)')
ylabel('Current (A)')

