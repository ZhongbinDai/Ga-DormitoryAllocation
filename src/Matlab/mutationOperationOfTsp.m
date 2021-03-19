function [newPopulation] = mutationOperationOfTsp(population, mutationRate)
% ��Ⱥ�������
    populationSize= size(population, 1);
    newPopulation = zeros(size(population));
    for i = 1 : populationSize
        individual = population(i, :);
        newPopulation(i, :) = mutateIndividual(individual, mutationRate);
    end

end

%% ������죬ÿ������λ��mutationRate�������������λ����
function [individual] = mutateIndividual(individual, mutationRate)
    n = length(individual);
    for i = 1: n
        if rand() < mutationRate
            j = round(rand() * (n-1) + 1);                                 % ����һ��1-n��������
            t = individual(i);                                             % ��i,jλ����
            individual(i) = individual(j);
            individual(j) = t;
        end
    end
end

