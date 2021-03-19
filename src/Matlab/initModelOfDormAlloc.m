function [model] = initModelOfDormAlloc(dataSetName)

    dataSetPath = '.\';                                 % �������ݼ�����·��
    model.studentData = load([dataSetPath dataSetName]);                                        % ��������
    model.numOfDormPeople = 6;                                                    % ÿ����������
    model.numOfDecVariables = length(model.studentData);
    model.numOfDorm = model.numOfDecVariables / model.numOfDormPeople;                        % ��������
   
    
    model.initIndividual = @initIndividual;                                 % ��ʼ������
	model.getIndividualFitness = @getIndividualFitness;                     % ���������Ӧ��
end

%% ��ʼ������
function [individual] = initIndividual(model)
	numOfDecVariables = model.numOfDecVariables;                            % ���߱���ά��
	individual = randperm(numOfDecVariables);                               % ����1Ϊ��㣬��ʡ��
end

%% ���������Ӧ��
function [individualFitness] = getIndividualFitness(individual, model)
    numOfDorm = model.numOfDorm;
    sumDis = 0;

    for i = 1 : numOfDorm
        [studentDatasOfDorm] = getStudentDatasOfDorm(i, individual, model);
        [dormDis] = getDormDis(studentDatasOfDorm, model);
        sumDis = sumDis + dormDis;
    end
    individualFitness = -sumDis * 2;                                     % ��Ӧ��Խ��Խ��
end

function [dormDis] = getDormDis(studentDatasOfDorm, model)
    numOfDormPeople = model.numOfDormPeople;
    dormDis = 0;
    for i = 1 : numOfDormPeople
        studentI = studentDatasOfDorm(i, :);
        for j = i+1 : numOfDormPeople
            studentJ = studentDatasOfDorm(j, :);
            dis = LpNorm(studentI, studentJ, 2);
            dormDis = dormDis + dis;
        end
    end
end

function [studentDatasOfDorm] = getStudentDatasOfDorm(i, individual, model)
    studentData = model.studentData;
    numOfDormPeople = model.numOfDormPeople;
    dormI = numOfDormPeople*i-(numOfDormPeople-1) : numOfDormPeople*i;
    studentIdsOfDorm = individual(dormI);
    
    studentDatasOfDorm = zeros(numOfDormPeople, size(studentData, 2));
    for j = 1 : numOfDormPeople
        id = studentIdsOfDorm(j);
        studentDatasOfDorm(j, :) = studentData(id, :);
    end
end





