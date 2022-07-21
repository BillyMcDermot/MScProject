%% Test GA using randomly initialised data
%
%   Using randomly generated Gaussian data to test the GA function with one
%   or multiple input time series.
%
%    Billy McDermot, July 2022
rng(1)
close all;
clc;

%% Generate a random time series and use the GA to try and find causally emergent V

steps = 1000;           % length of time series
d = 10;             % number of variables of X

X = randn(d, steps);

Xs = [{X}];

% run GA
[best_weights1, best_fitness1, mean_fitness1, std_fitness1] = simulateGA(Xs, 25, 4, 1000, 0.3, 0.8, "mean");

%% Generate multiple random time series and use the GA to try and find causally emergent V for both datasets

steps = 1000;           % length of time series
d = 10;             % number of variables of X

X1 = randn(d, steps);
X2 = randn(d, steps);

Xs = [{X1, X2}];

% run GA
[best_weights2, best_fitness2, mean_fitness2, std_fitness2] = simulateGA(Xs, 25, 4, 1000, 0.3, 0.8, "mean");