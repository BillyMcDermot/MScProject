%% Test GA using randomly initialised data
%
%   Using the MEG data to find functions that produce causally emergent V
%   with different input data.
%
%   (1624 sec)
%
%   Billy McDermot, July 2022
rng(1)
close all;
clc;

%% Parameters
T = 10000;          % number of steps in time series to use

%% Find causally emergent V for one input time series

% load one time series in ketamine run
data = load('Data\Psychedelics\KET\021013_51_KET.mat');
X1 = cell2mat(data.dat);
% shorten data
X1 = {X1(:,1:T)};

% run GA
[bw1, bf1, mf1, sf1] = simulateGA(X1, 100, 5, 20000, 0.3, 0.8, 'mean');

%% Find causally emergent V for all ketamine time series

% load multiple time series in the ketamine runs
filenames = ["040806_1_KET.mat" "041213_1_KET.mat" "091013_51_KET.mat" "110913_51_KET.mat"];
X2 = {X1};
for i = 1:length(filenames)
    data = load(strcat('Data\Psychedelics\KET\', filenames(i)));
    X = cell2mat(data.dat);
    % shorten data
    X = X(:,1:T);
    % append to cell
    X2{end+1} = X;
end

% run GA
[bw2mean, bf2mean, mf2mean, sf2mean] = simulateGA(X2, 100, 5, 20000, 0.3, 0.8, 'mean');
[bw2min, bf2min, mf2min, sf2min] = simulateGA(X2, 100, 5, 20000, 0.3, 0.8, 'min');

%% Find causally emergent V for one participant in ketamine and placebo conditions

% load time series for one participant in ketamine and placebo runs
X3 = {X1};
data = load('Data\Psychedelics\KET\021013_51_PLA.mat');
X = cell2mat(data.dat);
X = X(:,1:T);
X3{end+1} = X;

% run GA
[bw3mean, bf3mean, mf3mean, sf3mean] = simulateGA(X3, 100, 5, 20000, 0.3, 0.8, 'mean');
[bw3min, bf3min, mf3min, sf3min] = simulateGA(X3, 100, 5, 20000, 0.3, 0.8, 'min');