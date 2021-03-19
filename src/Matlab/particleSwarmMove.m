function [newPopulation] = particleSwarmMove(population, individualHistoryBestSet, bestIndividual)
    [populationSize, numOfDecVariables] = size(population);
    newPopulation = zeros(populationSize, numOfDecVariables);
    for i = 1 : populationSize
        individualI = population(i, :);
        individualIHistoryBest = individualHistoryBestSet(i, :);
        newPopulation(i, :) = particleMove(individualI, individualIHistoryBest, bestIndividual);
    end
end

function [newIndividual] = particleMove(individual, individualHistoryBest, bestIndividual)
% 个体 个体极值 群体极值
    crossoverRate = 0.6;                                                    % 交叉概率
    mutationRate = 0.01;                                                    % 变异概率
    [newIndividual] = crossoverOperation(individual, individualHistoryBest, crossoverRate);
    [newIndividual] = crossoverOperation(newIndividual, bestIndividual, crossoverRate);
%     newIndividual = mutationOperationOfTsp(newIndividual, mutationRate);    % 变异操作
    
end


function [newIndividual] = crossoverOperation(individualI, individualJ, crossoverRate)
    [~, n] = size(individualI);
    if rand() < crossoverRate
        j = round(rand() * (n-1) + 1);                                 % 产生一个1-n间的随机数
        k = round(rand() * (n-1) + 1);
        s = sort([j k]);                                               % 排序，使j<k
        j = s(1);
        k = s(2);
        individualI(j:k) = individualI(k:-1:j);                          % j-k间元素倒序
        newIndividual = individualI;
    else
        j = round(rand() * (n-1) + 1);                                 % 产生一个1-n间的随机数
        gene = individualI(j);                                          % 从个体i中获取第j个基因位上的基因gene
        index = find(individualJ == gene);                             % 从个体I中找到基因gene所在位置
        index = index(1);                                              % 如果gene=1,index为多个,只取第一个
        if index < n                                                   % 获取基因gene相邻位置
            index = index + 1;                                         % 右侧的位置
        else
            index = index - 1;                                         % 左侧的位置
        end
        gene = individualJ(index);                                     % 与之前基因gene相邻的基因（注意此时的gene已被更新）
        index = find(individualI == gene);                              % 在第i个个体（待交叉个体）中找到基因gene所在位置
        index = index(1);                                              % 如果gene=1,index为多个,只取第一个
        k = index;
        s = sort([j k]);                                               % 排序，使j<k
        j = s(1);
        k = s(2);
        individualI(j:k) = individualI(k:-1:j);                          % j-k间元素倒序
        newIndividual = individualI;
    end


end

