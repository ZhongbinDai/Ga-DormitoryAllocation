function [newPopulation] = crossoverOperationOfTsp(population, crossoverRate)
% �������
% �봫ͳ�Ŵ��㷨�Ľ��������ͬ��
% ���岽�裺
% Ⱦɫ�������ѡ��һ�������G1����G1=5��
% ����һ��[0,1]������С��p��
% ��p<crossoverRate����ڶ��������G2����ͬһ�����������һ����㣬��G2=2��
% Ȼ������G1������G2֮��Ĳ��ֱ����ã�����G1��G2��
% ��p>=crossoverRate�������Ⱥ��������ѡ��һ��Ⱦɫ�壬�ҳ�G1=5�ڸ�Ⱦɫ���У���һ�������G3��ֵ�����Խ����ȡǰһ������
% Ȼ������G1������G3֮��Ĳ��ֱ����ã�����G1��G3��
% �ý������˼·���ڣ����ܾ���������Ⱥ�л�õ���Ϣ����ָ�����壬ʹ���Ŵ����ӱȽϸ�Ч

    [populationSize, n] = size(population);                                % ��Ⱥ��ģ�����߱���ά�ȣ�Ⱦɫ�峤�ȣ�
    
    newPopulation = zeros(size(population));
    for i = 1 : populationSize
        if rand() < crossoverRate
            j = round(rand() * (n-1) + 1);                                 % ����һ��1-n��������
            k = round(rand() * (n-1) + 1);
            
            s = sort([j k]);                                               % ����ʹj<k
            j = s(1);
            k = s(2);
            individual = population(i, :);
            individual(j:k) = individual(k:-1:j);                          % j-k��Ԫ�ص���
            newPopulation(i, :) = individual;
        else
            j = round(rand() * (n-1) + 1);                                 % ����һ��1-n��������
            individual = population(i, :);                                 % ��Ⱥ�еĵ�i�����壨��������壩
            gene = individual(j);                                          % �Ӹ���i�л�ȡ��j������λ�ϵĻ���gene
            
            I = round(rand() * (populationSize-1) + 1);                    % ����һ��1-populationSize��������
            individualI = population(I, :);                                % ����Ⱥ�����ѡ��һ������I
            index = find(individualI == gene);                             % �Ӹ���I���ҵ�����gene����λ��
            index = index(1);                                              % ���gene=1,indexΪ���,ֻȡ��һ��
            if index < n                                                   % ��ȡ����gene����λ��
                index = index + 1;                                         % �Ҳ��λ��
            else
                index = index - 1;                                         % ����λ��
            end
            
            gene = individualI(index);                                     % ��֮ǰ����gene���ڵĻ���ע���ʱ��gene�ѱ����£�
            index = find(individual == gene);                              % �ڵ�i�����壨��������壩���ҵ�����gene����λ��
            index = index(1);                                              % ���gene=1,indexΪ���,ֻȡ��һ��
            k = index;
            
            s = sort([j k]);                                               % ����ʹj<k
            j = s(1);
            k = s(2);
            individual = population(i, :);
            individual(j:k) = individual(k:-1:j);                          % j-k��Ԫ�ص���
            newPopulation(i, :) = individual;
        end   
    end
    
end

