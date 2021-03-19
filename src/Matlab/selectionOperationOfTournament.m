function [newPopulation] = selectionOperationOfTournament(population, popFitness)
% ������ѡ��,��Ӧ��Խ��ѡ��ĸ���Խ��
% ���������population��Ⱥ��population��Ӧ��ֵ(��Ӧ��ҪΪ�Ǹ���)
% ���������newPopulationѡ���Ժ����Ⱥ
    K = 2;                                                                  % K-tournament
    populationSize= size(population, 1);                                    % ��Ⱥ��ģ
    newPopulation = zeros(size(population));
    for i = 1: populationSize
        rs = unidrnd(populationSize, K, 1);
        tempFitness = popFitness(rs);
        [~, index] = sort(tempFitness);
        newPopulation(i, :) = population(rs(index(K)), :);
    end
end

