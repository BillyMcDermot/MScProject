function fitness = GAEmergencePsi(Xs, genes)
%% EMERGENCEPSI Compute causal emergence criterion from data
%
%     Edited version of EmergencePsi() which computes the Psi value for
%     multiple data X_t with V_t calculated using the weighted sum of
%     columns. The weights are the genes generated in the GA.
%
% Billy McDermot, July 2022

%% fitness is equal to the minimum fitness across each dataset
fit_meth = @min;

%% Compute Psis for each time series
% if there is only one time series
if length(Xs) == 1
    X = Xs{1};
    V = sum(genes.'.*X);
    fitness = EmergencePsi(X.', V);
% more than one time series
else
    fitnesses = zeros(length(Xs), 1);
    for i = 1:length(Xs)
        X = Xs{i};
        V = sum(genes.'.*X);
        fitnesses(i) = EmergencePsi(X.', V);
    end
    fitness = fit_meth(fitnesses);
end

end