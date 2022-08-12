%% 10 sample QQ plots of the MEG data
% 
%
% Billy McDermot, August 2022
rng(1)
close all;
clc;

%% select participant and condition randomly and create QQ plot

% setup figure
figure(1)
tiledlayout(5,2)

meg_data = {'021013_51_KET.mat' '021013_51_PLA.mat' '040806_1_KET.mat' '040806_1_PLA.mat' '041213_1_KET.mat' '041213_1_PLA.mat' '091013_51_KET.mat' '091013_51_PLA.mat' '110913_51_KET.mat' '110913_51_PLA.mat' '161013_51_KET.mat' '161013_51_PLA.mat' '171212_1_KET.mat' '171212_1_PLA.mat' '181113_1_KET.mat' '181113_1_PLA.mat' '210813_51_KET.mat' '210813_51_PLA.mat' '310713_51_KET.mat' '310713_51_PLA.mat'};

% loop for each qq plot
for i = 1:10
    nexttile % next plot
    data_file = meg_data{randi(length(meg_data))};     % randomly select file
    data = load(data_file);     % load file
    data = cell2mat(data.dat);      % convert from cell to array
    channel = randi(90);        % randomly select channel of MEG data
    qqplot(data(channel,:))     % generate QQ plot
    title('')
end