clear
%% import data
[time, z] = importfile("../data/in_silico_growth_curve.csv");

%% initialize parameters
% mu
params.phi_mu = 900;     % shape
params.psi_mu = .6;      % scale (mean)
% K
params.phi_K  = 100/9;     % shape
params.psi_K  = .09;     % scale (mean)
% Q
params.phi_Q  = 900;     % shape
params.psi_Q  = 6.7e-4;  % scale (mean)
% N0
params.phi_N0 = 900;     % shape
params.psi_N0 = 600;     % scale (mean)
% tau
params.phi_tau  = 2;     % shape
params.psi_tau  = 1;     % scale (mean)

% Sampler options  (increase alpha --> dec pertubation size ; decrease alpha --> inc pertubation size)
params.run_alpha = [20;10;15;15]; % mu,K,Q,N0

% time considerations
params.t_min = min(time);
params.t_max = max(time);
params.t = time;
params.N = size(time,1);


%% Run sampler
num_samples = 50000; % Number of samples to run
rec = zeros(2,5); %Track acceptance of each sampler (each var, all)

store_g   = nan(num_samples,4); % mu, K, Q, N0
store_LogP= nan(num_samples,6); % posterior


%% initialize sampler
store_g(1,:) =  [params.psi_mu * randg(params.phi_mu) / params.phi_mu;
    params.psi_K  * randg(params.phi_K)  /   params.phi_K;
    params.psi_Q  * randg(params.phi_Q)  /   params.phi_Q;
    params.psi_N0 * randg(params.phi_N0) /   params.phi_N0]; % mu, K, Q, N0


% Our target and our posterior are one and the same
store_LogP(1,:)   = get_log_target(store_g(1,:),z,params);

for i = 2:num_samples
    % We pass the target back and forth 
    [store_g(i,:),store_LogP(i,:),rec] = sampler_update(store_g(i-1,:),store_LogP(i-1,:),z,params,rec);

    % Report 
    fprintf('Sample %d \n',i)
    fprintf('Accept rate mu: %f K: %f Q: %f N0: %f \n', ...
        rec(1,1)/rec(2,1) * 100,rec(1,2)/rec(2,2) * 100,rec(1,3)/rec(2,3) * 100,rec(1,4)/rec(2,4) * 100);
end


% Burn 50% of sample before saving
store_g = store_g((ceil(length(store_g)/2)+1:end),:);
store_LogP = store_LogP((ceil(length(store_LogP)/2)+1:end),:);
%% save data
save ../results/sampler_out.mat store_g store_LogP
