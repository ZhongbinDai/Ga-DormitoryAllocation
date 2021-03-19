% -------------------------------------------------------------------------
% 粒子群算法（PSO）求解学生宿舍分配问题
% @作者：冰中呆
% @邮箱：1209805090@qq.com
% @时间：2021.03.13
% -------------------------------------------------------------------------
%% 清空
clear;                                                                      % 清除所有变量
close all;                                                                  % 清图
clc;                                                                        % 清屏
%% 参数配置
addpath(genpath('.\'));                                                     % 将当前文件夹下的所有文件夹都包括进调用函数的目录
populationSize = 50;                                                        % 种群规模
maxGeneration = 10000;                                                       % 最大进化代数

dataSetName = 'random_data.txt';                                                  % 数据集
[model] = initModelOfDormAlloc(dataSetName);                                     	% 问题定义


%% 初始化uu
population = initialPopulation(populationSize, model);                      % 初始化种群
popFitness = getFitness(population, model);                                 % 计算种群适应度
numOfDecVariables = size(population, 2);                                    % 决策变量维度

bestIndividualSet = zeros(maxGeneration, numOfDecVariables);                % 每代最优个体集合（群体极值）
bestFitnessSet = zeros(maxGeneration, 1);                                   % 每代最高适应度集合
avgFitnessSet = zeros(maxGeneration, 1);                                    % 每代平均适应度集合

individualHistoryBestSet = population;                                      % 个体极值
individualHistoryBestFitnessSet = popFitness;

%% 进化
for i = 1 : maxGeneration
    
    [bestIndividual, bestFitness, avgFitness] = getBestIndividualAndFitness(population, popFitness);
    bestIndividualSet(i, :) = bestIndividual;                               % 第i代最优个体
    bestFitnessSet(i) = bestFitness;                                        % 第i代最高适应度
    avgFitnessSet(i) = avgFitness;                                          % 第i代种群平均适应度
    fprintf('第%i代种群的最优值：%.3f\n', i, -bestFitness);
    
    if mod(i, 50) == 0                                                     % 每隔100代绘制一幅图，因为绘图代价较大
        showEvolCurve(1, i, -bestFitnessSet, -avgFitnessSet);                 % 显示进化曲线
    end
    
    
    newPopulation = particleSwarmMove(population, individualHistoryBestSet, bestIndividual);
    newPopFitness = getFitness(newPopulation, model);                       % 子代种群适应度
    [newIndividualHistoryBestSet, newIndividualHistoryBestFitnessSet] = getIndividualHistoryBestSet(individualHistoryBestSet, individualHistoryBestFitnessSet, newPopulation, newPopFitness);
    
    [population, popFitness, individualHistoryBestSet,individualHistoryBestFitnessSet] = strongEliteSelect(population, popFitness, individualHistoryBestSet,individualHistoryBestFitnessSet,  newPopulation, newPopFitness,newIndividualHistoryBestSet, newIndividualHistoryBestFitnessSet); % 精英策略
end


function [P, F, iHBS, iHBFS] = strongEliteSelect(population, popFitness, individualHistoryBestSet,individualHistoryBestFitnessSet,  newPopulation, newPopFitness,newIndividualHistoryBestSet, newIndividualHistoryBestFitnessSet)
% 强精英选择:父代、子代合并选出全N个最优
    totalPopulation = [population; newPopulation];                          % 父代、子代合并
    totalFitness = [popFitness; newPopFitness];
    totalindividualHistoryBestSet = [individualHistoryBestSet; newIndividualHistoryBestSet];
    totalindividualHistoryBestFitnessSet = [individualHistoryBestFitnessSet; newIndividualHistoryBestFitnessSet];
    
    
    [totalFitness, index] = sort(totalFitness);                             % 根据适应度从小到大排序
    totalPopulation = totalPopulation(index,:);
    totalindividualHistoryBestSet = totalindividualHistoryBestSet(index,:);
    totalindividualHistoryBestFitnessSet = totalindividualHistoryBestFitnessSet(index,:);
    
    populationSize = size(totalPopulation, 1) / 2;
    P = totalPopulation(populationSize + 1:end, :);                         % 精英策略选择后的新种群
    F = totalFitness(populationSize + 1:end, :);                            % 新种群对应的适应度
    iHBS = totalindividualHistoryBestSet(populationSize + 1:end, :);
    iHBFS = totalindividualHistoryBestFitnessSet(populationSize + 1:end, :);
end
