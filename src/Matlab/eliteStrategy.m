function [P, F] = eliteStrategy(population, popFitness, newPopulation, newPopFitness, Mode)
% 精英策略
    if Mode == 0
        [P, F] = noneEliteSelect(population, popFitness, newPopulation, newPopFitness);
    elseif Mode == 1
        [P, F] = weakEliteSelect(population, popFitness, newPopulation, newPopFitness);
    else
        [P, F] = strongEliteSelect(population, popFitness, newPopulation, newPopFitness);
    end
end

function [P, F] = strongEliteSelect(population, popFitness, newPopulation, newPopFitness)
% 强精英选择:父代、子代合并选出全N个最优
    totalPopulation = [population; newPopulation];                          % 父代、子代合并
    totalFitness = [popFitness; newPopFitness];
    
    [totalFitness, index] = sort(totalFitness);                             % 根据适应度从小到大排序
    totalPopulation = totalPopulation(index,:);
    
    populationSize = size(totalPopulation, 1) / 2;
    P = totalPopulation(populationSize + 1:end, :);                         % 精英策略选择后的新种群
    F = totalFitness(populationSize + 1:end, :);                            % 新种群对应的适应度
end


function [P, F] = weakEliteSelect(population, popFitness, newPopulation, newPopFitness)
% 弱精英选择:父代、子代选择最优的一个放入新种群中
    totalPopulation = [population; newPopulation];                          % 父代、子代合并
    totalFitness = [popFitness; newPopFitness];
    
    [maxF, index] = max(totalFitness);
    P = newPopulation;
    F = newPopFitness;
    [~, I] = max(F);
    P(I, :) = totalPopulation(index, :);
    F(I) = maxF;

end


function [P, F] = noneEliteSelect(population, popFitness, newPopulation, newPopFitness)
% 无精英选择
    P = newPopulation;
    F = newPopFitness;
end




