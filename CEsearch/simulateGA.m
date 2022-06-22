function [ V, best_weights, best_fitnesses, mean_fitnesses, std_fitnesses ] = simulateGA(data, pop_size, deme_size, steps, crossover_rate, mutation_rate)
%UNTITLED Summary of this function goes here
%   [V2, bw, bf, mf, sf] = simulateGA(data2, 100, 5, 20000, 0.3, 0.8);
%   Psi = 0.5390/0.4577

no_genes = length(data(:,1));           % number of channels of data
genes = 10*randn(pop_size, no_genes);          % randomly initialise genes

best_fitnesses = zeros(steps, 1);
mean_fitnesses = zeros(steps, 1);
std_fitnesses = zeros(steps, 1);

% calculate initial fitnesses
fitnesses = zeros(pop_size, 1);
for i = 1:pop_size
    fitnesses(i) = EmergencePsi(data.', sum(genes(i,:).'.*data));
end

best_fitness = max(fitnesses);

% simulate GA
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
    fitness = EmergencePsi(data.', sum(genes(loser,:).'.*data));
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
V = sum(best_weights.'.*data);

best_fitness

end