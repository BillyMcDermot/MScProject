%% Using Kuramoto Oscillator data to compare Gaussian vs discrete CE values
% 
%       We use the GA on the MEG data X to find causally emergent V. We
%       then discretise this into 2-5 levels and compute Psi using discrete
%       MI.
%
%   Billy McDermot, July 2022
rng(1)
close all;
clc;

%% Load MEG data

data = load('Data\Psychedelics\KET\021013_51_KET.mat');    % phases generated by gauss_vs_discrete.m with 1000 points
data = cell2mat(data.dat);
% only use the first 6000 steps (10 seconds of data)
X = data(:,1:6000);

% find shape of data
D = length(data(:,1));
T = length(data);

%% use GA to find causally emergent V

C = 10000;      % number of competitions in GA
[bw, bf, mf, sf] = simulateGA({X}, 100, 5, 10000, 0.3, 0.8, 'min');

%% calculate V for entire time series and calculate psi, gamma

V = sum(data.*bw.');
gauss_psi = EmergencePsi(data.', V);
gauss_gamma = EmergenceGamma(data.', V);

%% discretise X and V and calculate psi, gamma, delta

% discretise X and V
bins = [2:5];
disc_Xs = zeros(length(bins), T, D);
disc_Vs = zeros(length(bins), 1, T);

for i = 1:length(bins)
    disp(i)
    disc_Xs(i,:,:) = discretise(data.', bins(i));
    disc_Vs(i,:,:) = discretise(V, bins(i));
end

%% calculate discrete psi, gamma (delta takes too long to calculate for entire time series)
disc_psi = zeros(length(bins));
disc_gamma = zeros(length(bins));

for i = 1:length(bins)
    for j = 1:length(bins)
        disp(i)
        disp(j)
        disc_psi(i, j) = EmergencePsi(reshape(disc_Xs(i,:,:),T,D), reshape(disc_Vs(j,:,:),1,T));
        disc_gamma(i, j) = EmergenceGamma(reshape(disc_Xs(i,:,:),T,D), reshape(disc_Vs(j,:,:),1,T));
    end
end

%% calculate gaussian and discrete delta (using only 6000 time steps)

T = 6000;
v = sum(X.*bw.');       % find V using only 6000 timesteps

disc_Xs2 = zeros(length(bins), T, D);
disc_Vs2 = zeros(length(bins), 1, T);

for i = 1:length(bins)      % discretise X and V to different levels
    disp(i)
    disc_Xs2(i,:,:) = discretise(X.', bins(i));
    disc_Vs2(i,:,:) = discretise(v, bins(i));
end

disc_delta = zeros(length(bins));       % initialies discrete delta values in array
gauss_delta = EmergenceDelta(X.', v);   % calculate gaussian delta

for i = 1:length(bins)
    for j = 1:length(bins)
        disp(i)
        disp(j)
        disc_delta(i, j) = EmergenceDelta(reshape(disc_Xs2(i,:,:),T,D), reshape(disc_Vs2(j,:,:),1,T));
    end
end

%% plot
figure(1)
plot(bf)

figure(2)
plot(bw)

% create custom colormap
map1 = [linspace(0,1,64)', linspace(0,1,64)', linspace(1,1,64)'];
map2 = [linspace(1,0,64)', linspace(1,1,64)', linspace(1,0,64)'];
map = vertcat(map1,map2);

% discrete psis
figure(3)
heatmap(bins, bins, disc_psi)
caxis([gauss_psi - 0.5, gauss_psi + 0.5])
colormap(map)
xlabel('V levels')
ylabel('X levels')

% discrete gammas
figure(4)
heatmap(bins, bins, disc_gamma)
caxis([gauss_gamma - 0.1, gauss_gamma + 0.1])
colormap(map)
xlabel('V levels')
ylabel('X levels')

% discrete deltas
figure(5)
heatmap(bins, bins, disc_delta)
caxis([gauss_delta - 0.7, gauss_delta + 0.7])
colormap(map)
xlabel('V levels')
ylabel('X levels')