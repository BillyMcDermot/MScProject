%% Comparing Causal Emergence metrics using discrete and Gaussian CE calculations
%
% Billy McDermot, June 2022
rng(1)

%% 1) Test using random Gaussian example

% Initialise variables
T = 5000;                     % number of time steps
bin_sizes = [ 2:10 ];             % discretisation levels to apply to X and V

% generate random Gaussian data and a linear function of it as V
X = randn([T,5]);
V = mean(X, 2);

gauss_psi1 = EmergencePsi(X, V);
gauss_delta1 = EmergenceDelta(X, V);
gauss_gamma1 = EmergenceGamma(X, V);

% discretise X and V to different levels
discrete_Xs = zeros(T, length(X(1,:)), length(bin_sizes));
discrete_Vs = zeros(T, 1, length(bin_sizes));

for i = 1:length(bin_sizes)
    bins = bin_sizes(i);
    discrete_Xs(:,:,i) = discretize(X, bins);
    discrete_Vs(:,:,i) = discretize(V, bins);
end

% calculate CE metrics for all combinations of discretisations
disc_psi1 = zeros(length(bin_sizes));
disc_delta1 = zeros(length(bin_sizes));
disc_gamma1 = zeros(length(bin_sizes));

for i = 1:length(bin_sizes)
    disc_X = discrete_Xs(:,:,i);
    for j = 1:length(bin_sizes)
        disc_V = discrete_Vs(:,:,j);
        disc_psi1(i,j) = EmergencePsi(disc_X, disc_V);
        disc_delta1(i,j) = EmergenceDelta(disc_X, disc_V);
        disc_gamma1(i,j) = EmergenceGamma(disc_X, disc_V);
    end
end

%% 2) Test using discrete downward causation example

% Initialise variables
T = 50000;                     % number of time steps

% generate discrete data with downward causation
X = zeros([T,2]);
for t = 2:T
    X(t,1) = xor(X(t-1,1), X(t-1,2));
    X(t,2) = rand < 0.5;
end
V = xor(X(:,1), X(:,2));

disc_psi2 = EmergencePsi(X, V);
disc_delta2 = EmergenceDelta(X, V);
disc_gamma2 = EmergenceGamma(X, V);

gauss_psi2 = EmergencePsi(X, V, 'gaussian');
gauss_delta2 = EmergenceDelta(X, V, 'gaussian');
gauss_gamma2 = EmergenceGamma(X, V, 'gaussian');

%% 3) Test using discrete causal decoupling example

% Initialise variables
T = 50000;                     % number of time steps
gamma = 0.99;

% generate discrete data with causal decoupling
X = zeros([T, 2]);
for t = 2:T
    p = xor(xor(X(t-1,1), X(t-1,2)), rand > gamma);
    X(t,1) = rand < 0.5;
    X(t,2) = xor(p, X(t,1));
end
V = xor(X(:,1), X(:,2));

disc_psi3 = EmergencePsi(X, V);
disc_delta3 = EmergenceDelta(X, V);
disc_gamma3 = EmergenceGamma(X, V);

gauss_psi3 = EmergencePsi(X, V, 'gaussian');
gauss_delta3 = EmergenceDelta(X, V, 'gaussian');
gauss_gamma3 = EmergenceGamma(X, V, 'gaussian');