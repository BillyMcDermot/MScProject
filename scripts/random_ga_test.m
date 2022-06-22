%% Generate a random time series with moving mean and use the GA to try and find causally emergent V
% Billy McDermot, June 2022

steps = 1000;           % length of time series
d = 10;             % number of variables of X

X = randn(d, steps);

% run GA
[V, best_weights, best_fitness, mean_fitness, std_fitness] = simulateGA(X, 25, 4, 10000, 0.3, 0.8);

% calculate emergence metrics
psi = EmergencePsi(X.', V);
delta = EmergenceDelta(X.', V);
gamma = EmergenceGamma(X.', V);