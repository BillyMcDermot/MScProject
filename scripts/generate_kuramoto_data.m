%% Generating Kuramoto Oscillator time series data
%
% Billy McDermot, July 2022
rng(1)
close all;
clc;

%% parameter specification
intra_comm_size =   12;				    	% intra-community size
n_communities =	    3;				   	% number of communities		
A =				    0.2;	                % A vector
beta =				0.1;                % noise correlation vector: use beta values only up to 0.4, as sigma met & 
										% sigma chi turn out to be zero for greater values of beta; in these cases 
										% sigma chi will be a non-varying zero macro variable, yielding erroneous 
										% values for emergence 

npoints =			10000;		    % number of data points in time-series to simulate

%% create Kuramoto coupling matrix

kuramoto_coupling_matrix = get_kuramoto_coupling_matrix(intra_comm_size, n_communities, A);

%% simulate Kuramoto oscillators

[phase, sigma_chi, synchrony] = sim_kuramoto_oscillators(intra_comm_size, n_communities, kuramoto_coupling_matrix, beta, npoints);