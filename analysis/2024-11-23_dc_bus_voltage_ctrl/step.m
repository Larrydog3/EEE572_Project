s = tf('s');
N=1;
L=100e-6;
f=400e3;
C=0.1e-6;
GpGl = 1/s^2 * 1000/(2*L*N*f*C);

PM_desired = 60;
wc_desired = 2*pi*1000;
[GpGl_mag, GpGl_phase] = bode(GpGl, wc_desired);
phi_boost = PM_desired - GpGl_phase - 90;
k = tand(phi_boost / 4 + 45);
w_z = wc_desired / k;
w_p = k * wc_desired;
Gc_unitygain = 1/s * (1 + s/w_z)^2 / (1 + s/w_p)^2;
GcGpGl_unitygain = Gc_unitygain * GpGl;
[GcGpGl_unitygain_mag, ~] = bode(GcGpGl_unitygain, wc_desired);
K_c = 1/abs(GcGpGl_unitygain_mag);
w_z
w_p
K_c

Gc = K_c * Gc_unitygain;
GcGpGl = Gc * GpGl;
figure;
% step the closed loop system from 1000 to 1200
Config = RespConfig('InputOffset', 1000, 'Amplitude', 200);
G_cl = feedback(GcGpGl, 1);
step(G_cl, Config);

% set the x limits to 0 to 0.1 ms
xlim([0 0.1e-3]);