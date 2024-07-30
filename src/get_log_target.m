function log_P = get_log_target(g,z,params)

% compute the log-posterior
log_P = NaN(6,1);

%% Likelihood (z's with a marginalized tau)
x = get_x(g,params.t,params.t_min,params.t_max);
log_P(2) = - (params.phi_tau + params.N *.5) * log( .5 * sum( log(z ./ x(:,2)) .* log(z ./ x(:,2)) ) ...
    + params.phi_tau / params.psi_tau );

%% Priors
% (mu)
log_P(3) = (params.phi_mu  - 1)* log(g(1)) - ...
    g(1) * params.phi_mu / params.psi_mu(1);
% (K)
log_P(4) = (params.phi_K  - 1)* log(g(2)) - ...
    g(2) * params.phi_K / params.psi_K;
% (Q)
log_P(5) = (params.phi_Q  - 1)* log(g(3)) - ...
    g(3) * params.phi_Q / params.psi_Q;
% (N0)
log_P(6) = (params.phi_N0  - 1)* log(g(4)) - ...
    g(4) * params.phi_N0 / params.psi_N0;

%% Posterior
log_P(1) = sum(log_P(2:end));

