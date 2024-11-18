clear;
close all;
clc;

s = tf('s');
Vin=1000;
Phi=0.0:0.1:0.01;
f=400e3;
Lr=300e-6;
N=1;

G = ((1-2*Phi)*Vin)/(2*s*Lr*N*f);

% bode
[mag,phase,wout] = bode(G);
%plot results, with frequency expressed at Hz
figure;
subplot(2,1,1);
semilogx(wout(:,1)/(2*pi), 20*log10(squeeze(mag)), '-b'); zoom on; grid on; 
title('magnitude'); xlabel('Frequency (Hz)'); ylabel('Magnitude (dB)');
subplot(2,1,2);
semilogx(wout(:,1)/(2*pi), squeeze(phase), '-r'); zoom on; grid on; 
title('Phase'); xlabel('Frequecy (Hz)'); ylabel('Phase (deg)');