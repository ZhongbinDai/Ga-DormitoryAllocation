function [newPopulation] = mutationOperationOfTsp(population, mutationRate)
% 种群变异操作
    populationSize= size(population, 1);
    newPopulation = zeros(size(population));
    for i = 1 : populationSize
        individual = population(i, :);
        newPopulation(i, :) = mutateIndividual(individual, mutationRate);
    end

end

%% 个体变异，每个基因位有mutationRate概率与任意基因位互换
function [individual] = mutateIndividual(individual, mutationRate)
    n = length(individual);
    for i = 1: n
        if rand() < mutationRate
            j = round(rand() * (n-1) + 1);                                 % 产生一个1-n间的随机数
            t = individual(i);                                             % 第i,j位互换
            individual(i) = individual(j);
            individual(j) = t;
        end
    end
end

