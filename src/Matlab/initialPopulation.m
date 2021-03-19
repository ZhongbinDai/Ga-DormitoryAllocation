function [population] = initialPopulation(populationSize, model)
% 初始化种群
    numOfDecVariables = model.numOfDecVariables;
    population = zeros(populationSize, numOfDecVariables);
    for i = 1 : populationSize
        population(i, :) = model.initIndividual(model);
    end
end
