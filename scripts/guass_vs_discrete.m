%% Comparing CE measures when using Gaussian approximation for MI and when discretising data and calculating exact MI
% 
%       We use the phases generated by a Kuramoto oscillator as the micro
%       variables and a RICA decomposition of the phase as the macro
%       variable.
%
% Billy McDermot, June 2022

rng(1)

clear all;
clear java;
close all;
clc;

% parameter specification
intra_comm_size =   12;				    	% intra-community size
n_communities =	    3;				   	% number of communities		
A =				    0.2;	                % A vector
beta =				0.1;                % noise correlation vector: use beta values only up to 0.4, as sigma met & 
										% sigma chi turn out to be zero for greater values of beta; in these cases 
										% sigma chi will be a non-varying zero macro variable, yielding erroneous 
										% values for emergence 

npoints =			5000;		    % number of data points in time-series to simulate

bins =            [2:9, 10:10:90, 100:100:1000];         % number of bins to group X and V data into

%% create Kuramoto coupling matrix

kuramoto_coupling_matrix = get_kuramoto_coupling_matrix(intra_comm_size, n_communities, A);

%% simulate Kuramoto oscillators

[phase, sigma_chi, synchrony] = sim_kuramoto_oscillators(intra_comm_size, n_communities, kuramoto_coupling_matrix, beta, npoints);

%% quadratically expand the phase time series and find weights for decent macro variable

phase2 = QuadraticExpand(phase);
weights = RicaWeights(phase2, 4); % use RICA to find decent guesses of macrovariables with emergence close to 0
V = sum(phase2.*weights); % 

%% calculate CE using Gaussian approximation

gauss_psi1 = EmergencePsi(phase.', sigma_chi);                  % V = chimera index
gauss_psi2 = EmergencePsi(phase.', V);                  % V = weighted sum of columns using best vector from RICA
gauss_psi3 = EmergencePsi(phase.', randn(1,npoints));               % V = random standard normal data

%% calculate CE using different levels of discretisation on X and V

disc_psi1 = ones(length(bins));
disc_psi2 = ones(length(bins));
disc_psi3 = ones(length(bins));

% loop through all combinations of bin sizes for X and V and calculate the
% CE metric psi using discretised sigma_chi and RICA
i = 1;
for X_bins = bins
    disc_phase2 = discretize(phase2, X_bins);
    disc_phase = disc_phase2(1:n_communities*intra_comm_size, :);
    j = 1;
    for V_bins = bins
        disc_sigma_chi = discretize(sigma_chi, V_bins);
        disc_V = discretize(V, V_bins);
        disc_psi1(i, j) = EmergencePsi(disc_phase.', disc_sigma_chi, 'Gaussian');
        disc_psi2(i, j) = EmergencePsi(disc_phase.', disc_V, 'Gaussian');
        disc_psi3(i, j) = EmergencePsi(disc_phase.', randi([1 V_bins], 1, npoints), 'Gaussian');
        j = j+1;
    end
    i = i+1;
end

%% plot results

% CE metrics using chimera index as macro
figure(1)
heatmap(bins, bins, disc_psi1)
caxis([-3.5,3.5])
colormap hot
xlabel('V levels')
ylabel('X levels')

% CE metrics using weighted sum as macro
figure(2)
heatmap(bins, bins, disc_psi2)
caxis([-5,1.5])
colormap hot
xlabel('V levels')
ylabel('X levels')

% CE metrics using random integers
figure(3)
heatmap(bins, bins, disc_psi3)
caxis([-5,1.5])
colormap hot
xlabel('V levels')
ylabel('X levels')

% 3 X levels appears to be best so compare these with CE found using
% Gaussian MI
figure(4)
semilogx(bins, diag(disc_psi1))
hold on
yline(gauss_psi1,'b','LineWidth',1.5)
ylim([-2 2])
hold off