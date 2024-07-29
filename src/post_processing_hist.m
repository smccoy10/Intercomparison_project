% Load data from .mat file
file = load('results/sampler_out.mat');
g = file.store_g;

% reverse the scaling we did for sampler
g(:,3) = g(:,3) * 1e-6;

% Expected values values
gt_mu = 0.6;
gt_K =  0.09;
gt_Q =  6.7e-10;
gt_N0 = NaN;  % Assuming no ground truth for N0

% Ground truth array and parameter names for plotting
gt_values = [gt_mu, gt_K, gt_Q, gt_N0];
param_names = {'\mu_{max}', 'K_s', 'Q_n', 'N_0'};

% Create figure for the 4x4 grid
figure;

% Loop to create the 4x4 grid of subplots
for i = 1:4
    for j = 1:4
        subplot(4, 4, (i-1)*4 + j);  % Select the subplot position
        
        if i == j
            % Diagonal elements: Histograms with ground truth lines
            hist(g(:,i));  % Plot histogram of samples
            hold on;
            if ~isnan(gt_values(i))
                xline(gt_values(i), 'Color', 'g', 'LineWidth', 2);  % Plot ground truth line
            end
            title(['Histogram of ', param_names{i}]);
            xlabel(param_names{i});
            ylabel('Frequency');
            hold off;
        else
            % Off-diagonal elements: Scatter plots of each pair of variables
            scatter(g(:,j), g(:,i), '.');
            xlabel(param_names{j});
            ylabel(param_names{i});
        end
    end
end

sgtitle('ODE parameters');


%% Save fig
fig =  gcf;
fig.Units = "inches";
fig.Position(3)  = 10;
fig.Position(4)  = 6;


exportgraphics(fig,"figures/param_hist.pdf");