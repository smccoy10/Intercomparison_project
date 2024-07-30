function x = get_x(g,t,t_min,t_max)
% here use the values in g to solve the IVP and return the solution at
% times t

mu = g(1);
K  = g(2);
Q  = g(3);
N0 = g(4);

tspan = [t_min,t_max];
x0    = [N0,8677]; % Nutrients (sampled) , Cells (from data)

sol = ode15s(@(t,x) x(2) * mu * x(1) / (x(1) + K) * [-Q;1],...
              tspan,...
              x0,...
              odeset('NonNegative',1:2));
x = deval(sol,t)';

end