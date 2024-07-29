%% import data
[time, z] = importfile("in_silico_growth_curve.csv");

%% Load data from .mat file
file = load('sampler_out.mat');
LogP = file.store_LogP;
g = file.store_g;

ODE_time = linspace(min(time),max(time),1000);

%% Find the map
[val,ind] = max(LogP(:,1));
map_g = g(ind,:);

%% Plot
% Final Runs
hold on
for i = size(g,1)-40:size(g,1)
    x = get_x(g(i,:),ODE_time,min(time),max(time));
    trace = plot(ODE_time,x(:,2),"Color","c");
end
% data
data = scatter(time,z,"MarkerEdgeColor","r");

% MAP
x = get_x(map_g,ODE_time,min(time),max(time));
MAP = plot(ODE_time, x(:,2),"Color","b",DisplayName="MAP");

xlabel("Time (days)")
ylabel("Cell density (ml^{-1})")
legend([trace,data,MAP],{"Traces","Data","MAP"})
title("Phytoplanton cell growth")


%% Save fig
fig =  gcf;
fig.Units = "inches";
fig.Position(3)  = 10;
fig.Position(4)  = 6;

set(gca, 'YScale', 'log')
exportgraphics(fig,"Log_ODE.pdf");