clear all; 
close all; 
clc;

%inputs
f = 400e3;
Va = [800:100:1200];
Vb = 1e3;
N = 1; 
phi = pi/6;
%phi = [pi/12:pi/12:pi/3];
L = 100e-6;
T = 1./f;

[i_pk,i_rms,isw_prim14_pk,isw_prim23_pk,isw_prim14_rms,isw_prim23_rms,...
    isw_sec14_pk,isw_sec23_pk,isw_sec14_rms,isw_sec23_rms] = calc_i(f,Va,Vb,N,phi,L)
