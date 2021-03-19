function [individualHistoryBestSet, individualHistoryBestFitnessSet] = getIndividualHistoryBestSet(population, popFitness, newPopulation, newPopFitness);
    individualHistoryBestSet = population;
    individualHistoryBestFitnessSet = popFitness;
    [populationSize, ~] = size(population);
    for i = 1 : populationSize
        if individualHistoryBestFitnessSet(i) < newPopFitness(i)
            individualHistoryBestSet(i, :) = newPopulation(i, :);
            individualHistoryBestFitnessSet(i) = newPopFitness(i);
        end
        
    end
end

