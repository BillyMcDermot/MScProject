%% Repeating GA on same dataset 10 times with different initialisations
% 
%       We use the GA on one of the MEG datasets to find the weights used
%       when calculating V. We repeat this 10 times with different initial
%       weights/genes and compare the results.
%
%   Billy McDermot, July 2022
rng(1)
close all;
clc;

%% Parameters
T = 3600;          % number of steps in time series to use: 3600 steps = 6 seconds of data
C = 50000;          % number of competitions in GA

%% load data
data = load('Data\Psychedelics\KET\021013_51_KET.mat');     % participant in the ketamine condition
X = cell2mat(data.dat);
% shorten data
X = {X(:,1:T)};

%% run GA 10 times
bws = zeros(10, 90);    % best weights (final result of GA)
bfs = zeros(10, C);     % best fitness after each competition
mfs = zeros(10, C);     % mean fitness after each competition
sfs = zeros(10, C);     % standard deviation of fitness after each competition

% run the GA 10 times and store the results
for i = 1:10
    disp(i)
    [bw, bf, mf, sf] = simulateGA(X, 100, 5, C, 0.3, 0.8);
    bws(i,:) = bw;
    bfs(i,:) = bf.';
    mfs(i,:) = mf.';
    sfs(i,:) = sf.';
    disp(bf(end)) % final psi value 
end

%% rescale weights to compare between GA results better

% rescaling is allowed because psi(X, V) = psi(X, k*V)
% we make the first weights positive to make all them the same "parity"
for i = 1:10
    if bws(i,1) < 0
        bws(i,:) = -bws(i,:);
    end
end

% and make standard deviation 1
for i = 1:10
    sd = std(bws(i,:));
    bws(i,:) = bws(i,:)/sd;
end

%% calculate psi across entire time series

X = cell2mat(data.dat);     % convert data from cell to array
psis = zeros(10,1);     % array to store psi values

for i = 1:10
    V = sum(X.*bws(i,:).');
    psis(i) = EmergencePsi(X.', V);
end

%% plots

% show mean weights and the min and max for that weight
figure(1)
% find mean weight for each channel
mean_weight = mean(bws,1);
% find min and max weight for each channel
min_weight = min(bws);
max_weight = max(bws);
% plot errorbars
errorbar(1:90,mean_weight,mean_weight-min_weight,max_weight-mean_weight,'x')
xlim([1,91])
ylim([-4, 4])
xlabel('weight index')
ylabel('weight value')

% plot mean and standard deviation of weights (worse version of figure 1)
figure(2)
x = 1:90;
y = mean(bws(:,:), 1);
err = std(bws(:,:), 1);
plot(y,'k')
hold on
patch([x fliplr(x)], [y-err fliplr(y+err)], [0 0.4470 0.7410], 'LineStyle', 'none')
alpha(0.5)
hold off
xlabel('weight index')
ylabel('weight value')

% scatter plot final fitnesses and psi across entire time series
figure(3)
hold on
scatter(1:10,bfs(:,end),50,'x','LineWidth',2)
scatter(1:10,psis,50,'o','LineWidth',2)
hold off
xlim([0,11])
ylim([0.4, 0.75])
xlabel('GA ID')
ylabel('Final Fitness / Psi')
legend('Final Fitness','Psi','Location','southeast')

% fitness over time
figure(4)
for i = 1:10
    l = plot(bfs(i,:),'b');
    l.Color = [l.Color, 0.4];
    hold on
end
xlabel('GA Competitions')
ylabel('Fitness / Psi')