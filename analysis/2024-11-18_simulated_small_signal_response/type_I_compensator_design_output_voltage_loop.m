clear;
close all;
clc;

s = tf('s');
Vin=1000;
Phi=0.0;
f=400e3;
Lr=300e-6;
N=1;
Zout = 10e3;

G = Zout * ((1-2*Phi)*Vin)/(2*s*Lr*N*f);

k  = tand(60/2 + 45);
w_c = 1e4 * 2*pi;
w_z = w_c / k;
w_p = k * w_c;
mag_g = abs(evalfr(G, 1i*w_c));
K_c = w_c / (k * mag_g);

