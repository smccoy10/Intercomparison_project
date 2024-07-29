function [g_current,target_current,rec] = sampler_update(g_current,target_current,z,params,rec)

%% Setup
% copy incoming to internal parameter
samp_g = g_current;

%% Sample random collections of the parameters
for rep=1:5
scase = randi(5); % generate random case

switch scase 
    % N.B. sample gammas for the beta = G1 / (G1 + G2) speed up
    case {1,2,3,4} % sample selected entry
       if rand < .5
            samp_g(scase) = g_current(scase) / (1 + randg(1)/ randg(params.run_alpha(scase)));
       else
            samp_g(scase) = g_current(scase) * (1 + randg(1)/ randg(params.run_alpha(scase)));
       end
    otherwise % sample all
        if rand < .5
            samp_g(1)   = g_current(1) / (1 + randg(1)/ randg(params.run_alpha(1)));
        else
            samp_g(1)   = g_current(1) * (1 + randg(1)/ randg(params.run_alpha(1)));
        end
        if rand < .5
            samp_g(2)   = g_current(2) / (1 + randg(1)/ randg(params.run_alpha(2)));
        else
            samp_g(2)   = g_current(2) * (1 + randg(1)/ randg(params.run_alpha(2)));
        end
        if rand < .5
            samp_g(3)   = g_current(3) / (1 + randg(1)/ randg(params.run_alpha(3)));
        else
            samp_g(3)   = g_current(3) * (1 + randg(1)/ randg(params.run_alpha(3)));
        end
        if rand < .5
            samp_g(4)   = g_current(4) / (1 + randg(1)/ randg(params.run_alpha(4)));
        else
            samp_g(4)   = g_current(4) * (1 + randg(1)/ randg(params.run_alpha(4)));
        end

end % ends switch 

%% GET LOG ALPHA
target_new = get_log_target(samp_g,z,params); % eval proposal
log_alpha = target_new(1) - target_current(1) + sum(log(g_current ./ samp_g)); %log alpha

%% EVALUATE LOG ALPHA
if rand < exp(log_alpha)
    g_current = samp_g;
    target_current = target_new;
    rec(1,scase) = rec(1,scase) + 1 ; % record acceptance
end % ends if

rec(2,scase) = rec(2,scase) + 1; % record everything
end % ends for loop 


end