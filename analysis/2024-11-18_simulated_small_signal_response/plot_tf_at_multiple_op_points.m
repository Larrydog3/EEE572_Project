clear;
close all;
clc;

s = tf('s');
Vin=1000;
Phi=0.0:0.05:0.4;
f=400e3;
Lr=300e-6;
N=1;


figure;

% Create subplots and hold on for each
subplot(2,1,1);
hold on;
zoom on;
grid on;
title('Magnitude');
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');

subplot(2,1,2);
hold on;
zoom on;
grid on;
title('Phase');
xlabel('Frequency (Hz)');
ylabel('Phase (deg)');

legendInfo = cell(length(Phi),1);
for i = 1:length(Phi)
    G = ((1-2*Phi(i))*Vin)/(2*s*Lr*N*f);
    % bode
    [mag, phase, wout] = bode(G);
    % Plot results, with frequency expressed in Hz
    subplot(2,1,1);
    semilogx(wout(:,1)/(2*pi), 20*log10(squeeze(mag)));
    
    subplot(2,1,2);
    semilogx(wout(:,1)/(2*pi), squeeze(phase));
    
    legendInfo{i} = ['Phi = ' num2str(Phi(i))];
end

% Add legends to each subplot
subplot(2,1,1);
legend(legendInfo);

subplot(2,1,2);
legend(legendInfo);