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

rlocus(G);