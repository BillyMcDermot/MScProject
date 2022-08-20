%% 10 sample histograms of the Kuramoto Oscillator data
%
% Billy McDermot, August 2022
rng(1)
close all;
clc;

%% select participant and condition randomly and create QQ plot

% setup figure
figure(1)
tiledlayout(5,2)

data = load('8x32_10000.mat');  % load Kuramoto oscillator data
data = data.phase;      % convert from cell to array

% loop for each qq plot
for i = 1:10
    nexttile % next plot
    osc = randi(90);        % randomly select one oscillator
    histogram(data(osc,:), 30)     % generate histogram for that oscillator
    title('')
    xlabel('\theta')
    ylabel('frequency')
    xlim([-3.5, 3.5])
end