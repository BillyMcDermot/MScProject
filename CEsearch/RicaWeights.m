function [ weights ] = RicaWeights(data, q)
%% RICA applied to data to find weights to calculate a macro variable V
%     rica_data = RicaWeights(data, q) uses the MatLab rica function to 
%     perform reconstruction independent component analsysis (RICA) to 
%     generate a qxT array from the NxT input data. We test each component
%     by calculating the weighted sum of the data using each component from
%     RICA and calculating the CE.
%
% Billy McDermot, June 2022

%% compute RICA of input data
rica_data = rica(data.', q);

%% use weights from rica_data to find best CE
best_i = 0;
best_psi = -Inf;
for i = 1:q
    rica_weights = rica_data.TransformWeights(:,i);
    rica_series = sum( data.*rica_weights );
    psi = EmergencePsi(data.', rica_series);
    if psi > best_psi
        best_i = i;
    end
end

weights = rica_data.TransformWeights(:, best_i);

end