function [model] = initModelOfDormAlloc(dataSetName)

    dataSetPath = '.\';                                 % 测试数据集所在路径
    model.studentData = load([dataSetPath dataSetName]);                                        % 载入数据
    model.numOfDormPeople = 6;                                                    % 每个宿舍人数
    model.numOfDecVariables = length(model.studentData);
    model.numOfDorm = model.numOfDecVariables / model.numOfDormPeople;                        % 宿舍数量
   
    
    model.initIndividual = @initIndividual;                                 % 初始化个体
	model.getIndividualFitness = @getIndividualFitness;                     % 计算个体适应度
end

%% 初始化个体
function [individual] = initIndividual(model)
	numOfDecVariables = model.numOfDecVariables;                            % 决策变量维度
	individual = randperm(numOfDecVariables);                               % 其中1为起点，可省略
end

%% 计算个体适应度
function [individualFitness] = getIndividualFitness(individual, model)
    numOfDorm = model.numOfDorm;
    sumDis = 0;

    for i = 1 : numOfDorm
        [studentDatasOfDorm] = getStudentDatasOfDorm(i, individual, model);
        [dormDis] = getDormDis(studentDatasOfDorm, model);
        sumDis = sumDis + dormDis;
    end
    individualFitness = -sumDis * 2;                                     % 适应度越大越好
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





