function [newPopulation] = crossoverOperationOfTsp(population, crossoverRate)
% 交叉操作
% 与传统遗传算法的交叉操作不同，
% 具体步骤：
% 染色体中随机选择一个基因点G1，如G1=5；
% 产生一个[0,1]间的随机小数p；
% 若p<crossoverRate，则第二个基因点G2来自同一个个体的任意一基因点，如G2=2；
% 然后基因点G1与基因点G2之间的部分被倒置（不包G1、G2）
% 若p>=crossoverRate，则从种群中任意再选择一个染色体，找出G1=5在该染色体中，下一个基因点G3的值（如果越界则取前一个）；
% 然后基因点G1与基因点G3之间的部分被倒置（不包G1、G3）
% 该交叉操作思路在于，它能尽量利用种群中获得的信息，来指引个体，使得遗传算子比较高效

    [populationSize, n] = size(population);                                % 种群规模、决策变量维度（染色体长度）
    
    newPopulation = zeros(size(population));
    for i = 1 : populationSize
        if rand() < crossoverRate
            j = round(rand() * (n-1) + 1);                                 % 产生一个1-n间的随机数
            k = round(rand() * (n-1) + 1);
            
            s = sort([j k]);                                               % 排序，使j<k
            j = s(1);
            k = s(2);
            individual = population(i, :);
            individual(j:k) = individual(k:-1:j);                          % j-k间元素倒序
            newPopulation(i, :) = individual;
        else
            j = round(rand() * (n-1) + 1);                                 % 产生一个1-n间的随机数
            individual = population(i, :);                                 % 种群中的第i个个体（待交叉个体）
            gene = individual(j);                                          % 从个体i中获取第j个基因位上的基因gene
            
            I = round(rand() * (populationSize-1) + 1);                    % 产生一个1-populationSize间的随机数
            individualI = population(I, :);                                % 从种群中随机选择一个个体I
            index = find(individualI == gene);                             % 从个体I中找到基因gene所在位置
            index = index(1);                                              % 如果gene=1,index为多个,只取第一个
            if index < n                                                   % 获取基因gene相邻位置
                index = index + 1;                                         % 右侧的位置
            else
                index = index - 1;                                         % 左侧的位置
            end
            
            gene = individualI(index);                                     % 与之前基因gene相邻的基因（注意此时的gene已被更新）
            index = find(individual == gene);                              % 在第i个个体（待交叉个体）中找到基因gene所在位置
            index = index(1);                                              % 如果gene=1,index为多个,只取第一个
            k = index;
            
            s = sort([j k]);                                               % 排序，使j<k
            j = s(1);
            k = s(2);
            individual = population(i, :);
            individual(j:k) = individual(k:-1:j);                          % j-k间元素倒序
            newPopulation(i, :) = individual;
        end   
    end
    
end

