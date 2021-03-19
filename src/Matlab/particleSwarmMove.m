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
% ���� ���弫ֵ Ⱥ�弫ֵ
    crossoverRate = 0.6;                                                    % �������
    mutationRate = 0.01;                                                    % �������
    [newIndividual] = crossoverOperation(individual, individualHistoryBest, crossoverRate);
    [newIndividual] = crossoverOperation(newIndividual, bestIndividual, crossoverRate);
%     newIndividual = mutationOperationOfTsp(newIndividual, mutationRate);    % �������
    
end


function [newIndividual] = crossoverOperation(individualI, individualJ, crossoverRate)
    [~, n] = size(individualI);
    if rand() < crossoverRate
        j = round(rand() * (n-1) + 1);                                 % ����һ��1-n��������
        k = round(rand() * (n-1) + 1);
        s = sort([j k]);                                               % ����ʹj<k
        j = s(1);
        k = s(2);
        individualI(j:k) = individualI(k:-1:j);                          % j-k��Ԫ�ص���
        newIndividual = individualI;
    else
        j = round(rand() * (n-1) + 1);                                 % ����һ��1-n��������
        gene = individualI(j);                                          % �Ӹ���i�л�ȡ��j������λ�ϵĻ���gene
        index = find(individualJ == gene);                             % �Ӹ���I���ҵ�����gene����λ��
        index = index(1);                                              % ���gene=1,indexΪ���,ֻȡ��һ��
        if index < n                                                   % ��ȡ����gene����λ��
            index = index + 1;                                         % �Ҳ��λ��
        else
            index = index - 1;                                         % ����λ��
        end
        gene = individualJ(index);                                     % ��֮ǰ����gene���ڵĻ���ע���ʱ��gene�ѱ����£�
        index = find(individualI == gene);                              % �ڵ�i�����壨��������壩���ҵ�����gene����λ��
        index = index(1);                                              % ���gene=1,indexΪ���,ֻȡ��һ��
        k = index;
        s = sort([j k]);                                               % ����ʹj<k
        j = s(1);
        k = s(2);
        individualI(j:k) = individualI(k:-1:j);                          % j-k��Ԫ�ص���
        newIndividual = individualI;
    end


end

