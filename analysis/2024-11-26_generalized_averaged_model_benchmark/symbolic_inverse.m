syms s D pi Co Rl L n Vo IL1R IL1I;

A = ...
[ 0                       0                     2*sin(D*pi)/(n*L*pi); 
  0                       0                     2*cos(D*pi)/(n*L*pi);
  -4*sin(D*pi)/(n*Co*pi) -4*cos(D*pi)/(n*Co*pi) -(1/(Co*Rl))];

f = [-2*Vo*pi*sin(D*pi)/(n*L); 
    2*Vo*pi*cos(D*pi)/(n*L);
    4*IL1R*pi*sin(D*pi)/(n*Co) + 4*IL1I*pi*cos(D*pi)/(n*Co);];
q = [0 0 1];

G_sl = q * inv(s * eye(3) - A) * f;

% factor G_sl into the form s^2 * N_2 + s*N_1 + N_0
[Num, Den] = numden(G_sl);

