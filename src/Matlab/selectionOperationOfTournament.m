function [newPopulation] = selectionOperationOfTournament(population, popFitness)
% 锦标赛选择,适应度越大被选择的概率越高
% 输入变量：population种群，population适应度值(适应度要为非负数)
% 输出变量：newPopulation选择以后的种群
    K = 2;                                                                  % K-tournament
    populationSize= size(population, 1);                                    % 种群规模
    newPopulation = zeros(size(population));
    for i = 1: populationSize
        rs = unidrnd(populationSize, K, 1);
        tempFitness = popFitness(rs);
        [~, index] = sort(tempFitness);
        newPopulation(i, :) = population(rs(index(K)), :);
    end
end

