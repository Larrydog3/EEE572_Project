clear all; 
close all; 
clc; 

Vin = 1000; 
Vout = 1000;
N = 1;
F_sw = 400e3;
NominalPower = 1000;

[L, phiRange] = calculateL(Vin, Vout, F_sw, NominalPower)

[i_pk,i_rms,isw_prim14_pk,isw_prim23_pk,isw_prim14_rms,isw_prim23_rms,...
    isw_sec14_pk,isw_sec23_pk,isw_sec14_rms,isw_sec23_rms]...
    = calc_i(F_sw,Vin,Vout,N,phiRange(2),L)