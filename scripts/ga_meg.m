%% Test GA using randomly initialised data
%
%   Using the MEG data to find functions that produce causally emergent V
%   with different input data.
%
%   (T=3600, C=100,000, 4569 sec)
%
%   Billy McDermot, July 2022
rng(1)
close all;
clc;

%% Parameters
T = 3600;          % number of steps in time series to use; 3600 timesteps = 6 seconds
C = 50000;          % number of competitions in GA to perform

%% Find causally emergent V for one input time series

% load one time series in ketamine run
data = load('Data\Psychedelics\KET\021013_51_KET.mat');
X = cell2mat(data.dat);
% shorten data
X1 = {X(:,1:T)};

% run GA
[bw1, bf1, mf1, sf1] = simulateGA(X1, 100, 5, C, 0.3, 0.8);

%% Find causally emergent V for same participant, same condition but different times as two input time series

% load two parts of the same time series
X2 = {};
X2(end+1) = X1;
X2{end+1} = X(:,30001:30000+T);

% run GA
[bw2, bf2, mf2, sf2] = simulateGA(X2, 100, 5, C, 0.3, 0.8);

%% Find causally emergent V for all ketamine time series

% load multiple time series in the ketamine runs
filenames = ["040806_1_KET.mat" "041213_1_KET.mat" "091013_51_KET.mat" "110913_51_KET.mat"];
X3 = {};
X3(end+1) = X1;
for i = 1:length(filenames)
    data = load(strcat('Data\Psychedelics\KET\', filenames(i)));
    X = cell2mat(data.dat);
    % shorten data
    X = X(:,1:T);
    % append to cell
    X3{end+1} = X;
end

% run GA
[bw3, bf3, mf3, sf3] = simulateGA(X3, 100, 5, C, 0.3, 0.8);

%% Find causally emergent V for one participant in ketamine and placebo conditions

% load time series for one participant in ketamine and placebo runs
X4 = {};
X4(end+1) = X1;
data = load('Data\Psychedelics\KET\021013_51_PLA.mat');
X = cell2mat(data.dat);
X = X(:,1:T);
X4{end+1} = X;

% run GA
[bw4, bf4, mf4, sf4] = simulateGA(X4, 100, 5, C, 0.3, 0.8);

%% plot results
figure(1)
plot(bf1,'LineWidth',2)
hold on
plot(bf2,'LineWidth',2)
plot(bf3,'LineWidth',2)
plot(bf4,'LineWidth',2)
plot([0, C], [0 0], 'black')
hold off
legend('One Participant in Ketamine Condition', 'One Participant in Ketamine Condition (2 time series)', 'Five Participants in Ketamine Codition', 'One Participant in Ketamine and Placebo Conditions', 'Location', 'southeast')
xlabel('GA Competitions')
ylabel('Fitness / Psi')