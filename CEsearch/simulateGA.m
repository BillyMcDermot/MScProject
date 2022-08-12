function [ best_weights, best_fitnesses, mean_fitnesses, std_fitnesses ] = simulateGA(data, pop_size, deme_size, steps, crossover_rate, mutation_rate)
%% SIMULATEGA Search for causally emergent macrovariable V_t for data X_t
%
%   data: an array of the >=1 datasets you want to find weights for. The
%         data must have the same number of variables but time dimension 
%         can vary.
%   pop_size: the number of sets of genes used in the GA.
%   deme_size: the distance from which two members of the population can be
%              compared in the competition stage.
%   steps: number of steps to run the simulation for.
%   crossover_rate: rate at which genes are transfered from the winner to
%                   the loser.
%   mutation_rate: rate at which genes are randomly altered by adding a
%                  value sampled from the standard normal distribution.
%   fitness_function: 'mean' or 'min' which decides whether the fitness of
%                     an individual is the mean or min fitness across all 
%                     data.
%   
%   Billy McDermot, July 2022

%% Initialisation
if length(data) == 1
    init_data = data{1};
else
    init_data = cell2mat(data(1));            % data to initialise the GA
end
no_genes = length(init_data(:,1));           % number of channels of data
genes = 10*randn(pop_size, no_genes);          % randomly initialise genes

best_fitnesses = zeros(steps, 1);
mean_fitnesses = zeros(steps, 1);
std_fitnesses = zeros(steps, 1);

% calculate initial fitnesses
fitnesses = zeros(pop_size, 1);
for i = 1:pop_size
    fitnesses(i) = GAEmergencePsi(data, genes(i,:));
end

best_fitness = max(fitnesses);

%% Simulating GA
for i = 1:steps
    ind1 = randi(pop_size);                         % randomly select first member of population
    ind2 = mod(ind1 + randi([0, deme_size]), pop_size) + 1;         % select next member within deme

    % find which individual has better fitness
    if fitnesses(ind1) > fitnesses(ind2)            
        winner = ind1;
        loser = ind2;
    else
        winner = ind2;
        loser = ind1;
    end
    % crossover and mutation on loser
    for gene = 1:no_genes               
        if rand < crossover_rate
            genes(loser, gene) = genes(winner, gene);
        end
        if rand < mutation_rate
            genes(loser, gene) = genes(loser, gene) + randn();
        end
    end
    % calculate new fitness and update best fitness
    fitness = GAEmergencePsi(data, genes(loser,:));
    fitnesses(loser) = fitness;
    if fitness > best_fitness
        best_fitness = fitness;
    end
   
    % update fitness info
    best_fitnesses(i) = best_fitness;
    mean_fitnesses(i) = mean(fitnesses);
    std_fitnesses(i) = std(fitnesses);
end

[~, max_ind] = max(fitnesses);
best_weights = genes(max_ind, :);

end