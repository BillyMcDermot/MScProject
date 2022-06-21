%% SLOW FEATURE ANALYSIS ON KURAMOTO OSCILLATORS WITH DISCRETISED DATA

clear all;
clear java;
close all;
clc;

% parameter specification
intra_comm_size =   4;				    	% intra-community size
n_communities =	    2;				   	% number of communities		
A =				    0.2;	                % A vector
beta =				0.1;                % noise correlation vector: use beta values only up to 0.4, as sigma met & 
										% sigma chi turn out to be zero for greater values of beta; in these cases, 
										% sigma chi will be a non-varying zero macro variable, yielding erroneous 
										% values for emergence 

npoints =			1000;		    % number of data points in time-series

bins =            [2, 5, 10, 50, 100];         % number of bins to group data into

%% create coupling matriX

kuramoto_coupling_matrix = get_kuramoto_coupling_matrix(intra_comm_size, n_communities, A);

%% simulate Kuramoto oscillators

[phase, sigma_chi, synchrony] = sim_kuramoto_oscillators(intra_comm_size, n_communities, kuramoto_coupling_matrix, beta, npoints);

% convert phase to raw singal
raw_signal = cos(phase);

%% find linear and non-linear SFA for discrete data and calculate emergence

psi = zeros(length(bins), length(bins), 3);         % store psi measures from using Gaussian MI estimation and discrete MI for each bin size

% calculate Psi using Gaussian MI estimation
% lin_sfa = sfa1(raw_signal.');
% nonlin_sfa = sfa2(raw_signal.');

i = 1;                  % index for number of bins X is discretised into

for X_bins = bins

    discrete_signal = discretize(raw_signal, X_bins);               % group raw signal into bins
    
    j = 1;                  % index for number of bins V is discretised into
    for V_bins = bins
%         lin_sfa = discretize(real(sfa1(discrete_signal.')), V_bins);               % calculate the linear SFA
%         nonlin_sfa = discretize(real(sfa2(discrete_signal.')), V_bins);            % calculate the non-linear SFA

        discrete_sigma_chi = discretize(sigma_chi, V_bins);             % group sigma chi into bins
    
        % calculate Psi
%         [psi(i,j,1), ~, ~] = EmergencePsi(discrete_signal.', lin_sfa(:,end), 'discrete');
%         [psi(i,j,2), ~, ~] = EmergencePsi(discrete_signal.', nonlin_sfa(:,end), 'discrete');
        [psi(i,j,3), ~, ~] = EmergencePsi(discrete_signal.', discrete_sigma_chi.', 'discrete');

        j = j+1;            % increment index
    end

    i = i+1;            % increment index
end