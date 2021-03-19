function [population] = initialPopulation(populationSize, model)
% ��ʼ����Ⱥ
    numOfDecVariables = model.numOfDecVariables;
    population = zeros(populationSize, numOfDecVariables);
    for i = 1 : populationSize
        population(i, :) = model.initIndividual(model);
    end
end
