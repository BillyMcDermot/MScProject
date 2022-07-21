function fitness = GAEmergencePsi(Xs, genes, fitness_method)
%% EMERGENCEPSI Compute causal emergence criterion from data
%
%     Edited version of EmergencePsi() which computes the Psi value for
%     multiple data X_t with V_t calculated using the weighted sum of
%     columns. The weights are the genes generated in the GA.
%
% Billy McDermot, July 2022

%% Determine method to use on Psi results
if fitness_method == "mean"
    fit_meth = @mean;
else
    fit_meth = @min;
end

%% Compute Psis for each time series
% if there is only one time series
if length(Xs) == 1
    X = Xs{1};
    V = sum(genes.'.*X);
    fitness = EmergencePsi(X.', V);
% more than one time series
else
    fitnesses = zeros(length(Xs), 1);
    for i = length(Xs)
        X = cell2mat(Xs(i));
        V = sum(genes.'.*X);
        fitnesses(i) = EmergencePsi(X.', V);
    end
    fitness = fit_meth(fitnesses);
end

end