%% Use GA on all datasets in KET folder
%
%   Using the MEG data to find functions that produce causally emergent V.
%
%   Billy McDermot, July 2022
rng(1)
close all;
clc;

%% load filenames
directory = 'C:\Users\Billy\OneDrive - University of Sussex\Masters\Thesis\Data\Psychedelics\KET';
files = dir(fullfile(directory, '*.mat'));

%% GA Parameters
T = 3600;          % number of steps in time series to use: 3600 steps = 6 seconds of data
C = 100000;          % number of competitions in GA

%% loop through each file and use GA

% initialise results
bws = zeros(length(files), 90);
bfs = zeros(length(files), C);
mfs = zeros(length(files), C);
sfs = zeros(length(files), C);
psis = zeros(length(files), 1);

for i = 1:length(files)
    disp(files(i).name)
    data = load(files(i).name);
    X = cell2mat(data.dat);
    % shorten data
    X1 = {X(:,1:T)};

    % run GA
    [bw, bf, mf, sf] = simulateGA(X1, 100, 5, C, 0.3, 0.8);

    % calculate Psi across whole time series
    V = sum(X.*bw.');
    Psi = EmergencePsi(X.', V);

    % store data
    bws(i,:) = bw;
    bfs(i,:) = bf;
    mfs(i,:) = mf;
    sfs(i,:) = sf;
    psis(i,1) = Psi;
end

%% plots

% plot each participants' placebo and ketamine psi
figure(1)
hold on
for i = 1:10
    % final fitness i.e., psi over the 3600 time steps trained on
    scatter((1:10)-0.1,bfs(1:2:20,end),60,'x','blue','LineWidth',1.5) % placebo
    scatter((1:10)-0.1,bfs(2:2:20,end),60,'x','red','LineWidth',1.5) % ketamine
    % Psi across all time steps
    scatter((1:10)+0.1,psis(1:2:20),'o','blue','LineWidth',1.5) % placebo
    scatter((1:10)+0.1,psis(2:2:20),'o','red','LineWidth',1.5) % ketamine
end
hold off
xlim([0,11])
ylim([0,1])
xlabel('Particpant Number')
ylabel('Psi')
legend('final fitness (placebo)','final fitness (ketamine)','Psi (placebo)','Psi (ketamine)', 'Location', 'southeast')

% training fitnesses of each participant and condition (to show they are converging)
figure(2)
hold on
for i = 1:10
    % fitnesses of placebo conditions
    line_pla = plot(bfs(2*i-1,:),'blue');
    line_pla.Color = [line_pla.Color, 0.4];
    % fitnesses of ketamine conditions
    line_ket = plot(bfs(2*i,:),'red');
    line_ket.Color = [line_ket.Color, 0.4];
end
hold off
xlabel('GA Competitions')
ylabel('Fitness / Psi')
legend('Placebo','Ketamine','Location','east')