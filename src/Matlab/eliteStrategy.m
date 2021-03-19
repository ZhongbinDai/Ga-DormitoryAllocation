function [P, F] = eliteStrategy(population, popFitness, newPopulation, newPopFitness, Mode)
% ��Ӣ����
    if Mode == 0
        [P, F] = noneEliteSelect(population, popFitness, newPopulation, newPopFitness);
    elseif Mode == 1
        [P, F] = weakEliteSelect(population, popFitness, newPopulation, newPopFitness);
    else
        [P, F] = strongEliteSelect(population, popFitness, newPopulation, newPopFitness);
    end
end

function [P, F] = strongEliteSelect(population, popFitness, newPopulation, newPopFitness)
% ǿ��Ӣѡ��:�������Ӵ��ϲ�ѡ��ȫN������
    totalPopulation = [population; newPopulation];                          % �������Ӵ��ϲ�
    totalFitness = [popFitness; newPopFitness];
    
    [totalFitness, index] = sort(totalFitness);                             % ������Ӧ�ȴ�С��������
    totalPopulation = totalPopulation(index,:);
    
    populationSize = size(totalPopulation, 1) / 2;
    P = totalPopulation(populationSize + 1:end, :);                         % ��Ӣ����ѡ��������Ⱥ
    F = totalFitness(populationSize + 1:end, :);                            % ����Ⱥ��Ӧ����Ӧ��
end


function [P, F] = weakEliteSelect(population, popFitness, newPopulation, newPopFitness)
% ����Ӣѡ��:�������Ӵ�ѡ�����ŵ�һ����������Ⱥ��
    totalPopulation = [population; newPopulation];                          % �������Ӵ��ϲ�
    totalFitness = [popFitness; newPopFitness];
    
    [maxF, index] = max(totalFitness);
    P = newPopulation;
    F = newPopFitness;
    [~, I] = max(F);
    P(I, :) = totalPopulation(index, :);
    F(I) = maxF;

end


function [P, F] = noneEliteSelect(population, popFitness, newPopulation, newPopFitness)
% �޾�Ӣѡ��
    P = newPopulation;
    F = newPopFitness;
end




