function [bestIndividual, bestFitness, avgFitness] = getBestIndividualAndFitness(population, popFitness)
    populationSize = length(popFitness);
    avgFitness = sum(popFitness) ./ populationSize;
    [bestFitness, index] = max(popFitness);
    bestIndividual = population(index, :);
end

