%% Test GA using randomly initialised data
%
%   Using the MEG data to find functions that produce causally emergent V
%   with different input data.
%
%   T = 10,000 (404 sec)
%   T = 20,000 (608 sec)
%   T = 30,000 (692 sec)
%   T = 40,000 (794 sec)
%
%   Billy McDermot, July 2022
rng(1)
close all;
clc;

%% Parameters
T = 4000;          % number of steps in time series to use
C = 200;          % number of competitions in GA

%% Find causally emergent V for one input time series

% load one time series in ketamine run
data = load('Data\Psychedelics\KET\021013_51_KET.mat');
X1 = cell2mat(data.dat);
% shorten data
X1 = {X1(:,1:T)};

% run GA
[bw1, bf1, mf1, sf1] = simulateGA(X1, 100, 5, C, 0.3, 0.8, 'mean');