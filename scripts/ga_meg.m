%% Test GA using randomly initialised data
%
%   Using the MEG data to find functions that produce causally emergent V
%   with different input data. We use:
%       - one sample from one individual in the ketamine condition
%       - two samples from one individual in the ketamine condition
%       - one sample from five individuals in the ketamine condition
%       - one sample from one individual in the ketamine and placebo
%       conditions
%   We also use the resulting weights from the five participants in the
%   ketamine condition to test whether they create causally emergent
%   macro-variables for five unseen participants also in the ketamine
%   condition.
%
%   Billy McDermot, July 2022
rng(1)
close all;
clc;

%% Parameters
T = 3600;          % number of steps in time series to use; 3600 timesteps = 6 seconds
C = 50000;          % number of competitions in GA to perform

%% Find causally emergent V for one participant in the ketamine condition

% load one time series in ketamine run
data = load('Data\Psychedelics\KET\021013_51_KET.mat');
X = cell2mat(data.dat);
% shorten data
X1 = {X(:,1:T)};

% run GA
[bw1, bf1, mf1, sf1] = simulateGA(X1, 100, 5, C, 0.3, 0.8);

%% Find causally emergent V for same participant, same condition but with two samples from the data

% load two parts of the same time series
X2 = {};
X2(end+1) = X1;
X2{end+1} = X(:,30001:30000+T);

% run GA
[bw2, bf2, mf2, sf2] = simulateGA(X2, 100, 5, C, 0.3, 0.8);

%% Find causally emergent V for five participants in the ketamine condition

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

% apply the weights found above on five test participants in the ketamine condition
test_psis3 = zeros(1,5);

test_filenames = ["161013_51_KET.mat" "171212_1_KET.mat" "181113_1_KET.mat" "210813_51_KET.mat" "310713_51_KET.mat"];
for i = 1:length(test_filenames)
    data = load(test_filenames(i));
    X = cell2mat(data.dat);
    % shorten data
    X = X(:,1:T);
    % calculate V
    V = sum(X.*bw3.');
    % calculate psi
    test_psis3(i) = EmergencePsi(X.', V);
end

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