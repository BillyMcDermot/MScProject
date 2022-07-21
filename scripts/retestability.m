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
T = 3600;          % number of steps in time series to use: 36k steps = 1 minute of data
C = 20000;          % number of competitions in GA

%% load data
data = load('Data\Psychedelics\KET\021013_51_KET.mat');
X = cell2mat(data.dat);
% shorten data
X = {X(:,1:T)};

%% run GA 10 times
bws = zeros(10, 90);  % store the final weights of each GA
bfs = zeros(10, C);  % store the best fitnesses/psi of each GA
mfs = zeros(10, C);  % store the mean fitnesses/psi of each GA
sfs = zeros(10, C);  % store the standard deviation of fitness of each GA

for i = 1:10
    [bw, bf, mf, sf] = simulateGA(X, 100, 5, C, 0.3, 0.8, 'mean');
    bws(i,:) = bw;
    bfs(i,:) = bf.';
    mfs(i,:) = mf.';
    sfs(i,:) = sf.';
    disp(bf(end)) % final psi value 
end

%% rescale weights to between GA results better

% psi(X, V) = psi(X, k*V)
% so make first weights always positive
for i = 1:10
    if bws(i,1) < 0
        bws(i,:) = -bws(i,:);
    end
end

% and make maximum weight = 1
for i = 1:10
    max_weight = max(bws(i,:));
    bws(i,:) = bws(i,:)/max_weight;
end

%% display plots

% show weights from first 3 GAs
figure(1)
for i = 1:3
    scatter(1:90,bws(i,:),'x')
    hold on
end
xlabel('weight index')
ylabel('weight value')

% plot mean and standard deviation of weights
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
