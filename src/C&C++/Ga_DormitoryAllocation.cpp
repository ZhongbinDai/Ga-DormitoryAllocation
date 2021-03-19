// -----------------------------------------
// 遗传算法（GA）求学生宿舍分问题 
// @作者：冰中呆
// @邮箱：1209805090@qq.com
// @时间：2021.03.18
// @注意：存在内存泄漏问题 
// -----------------------------------------
#include <cstdio> 
#include <cstring> 
#include <iostream>
#include <algorithm>
#include <cstdlib>
#include <ctime>
#include <cmath>
using namespace std;

struct ProblemData
{
	char* dataSetPath; 												//数据存放路径 
	char* dataSetName;												//数据文件名 
	int numOfDormPeople;											//每个宿舍学生人数 
	int numOfDecVariables;											//决策变量维度（学生数）
	int lengthOfData;												//每个学生数据数量 
	int numOfDorm;													//宿舍数 
	int** studentData;												//学生数据 
}; 
void showArray(double *array, int n);
void showArray(int *array, int n);
void showMat(int** matData, int n, int m);							//显示二维数组 
void showProblem(ProblemData proData);								//打印问题基本信息
ProblemData initModelOfProblem();									//初始化问题 
int** load(char *path, int n, int m);								//读取学生数据 
int* randperm(int n);												//随机置乱函数
int** initialPopulation(int populationSize, ProblemData model);		//初始化种群 
int** create2DIntMat(int n, int m);									//创建一个二维数组 
int** getStudentDatasOfDorm(int i, int* individual, ProblemData model);
double getDormDis(int** studentDatasOfDorm, ProblemData model);		//计算一个宿舍内同学的距离 
double LpNorm(int* vector1, int* vector2, int n);					//欧氏距离 
double getIndividualFitness(int* individual, ProblemData model);	//计算个体适应度
double getIndividualFitness2(int* individual, ProblemData model);	//计算个体适应度
double* getPopulationFitness(int**, int, ProblemData);				//计算种群适应度
double* getPopulationFitness2(int**, int, ProblemData);				//计算种群适应度
int** selectionOperationOfTournament(int**, double*, int);			//选择操作 
double getRand();													//获取0-1之间的随机数
int getRand(int min, int max);										//随机获取[min,max]之间的整数 
int find(int* array, int n, int x);									//从array[]中找到x的位置 
int** crossoverOperationOfTsp(int**, double, int, int);				//种群交叉操作 
int* mutateIndividual(int*, double, int);							//个体变异操作 
int** mutationOperation(int**, double, int, int);		 			//种群变异操作
void strongEliteSelect(int**, double*, int**, double*, int);		//精英策略 
void sortPF(double* F, int** P, int n); 
void copyArray(int* a, int *b, int n);
double getAvg(double *b, int n);
void deleteIntMat(int** intMat, int n);


int main()
{
	srand(time(NULL));
	int populationSize = 50;                     												//种群规模
	int maxGeneration = 1000;                   												//最大进化代数
	double crossoverRate = 0.6;                  												//叉概率
	double mutationRate = 0.01;                  												//变异概率
	ProblemData model = initModelOfProblem();													//初始化问题 
	
	int** population = initialPopulation(populationSize, model);	
	
	double* popFitness = getPopulationFitness(population, populationSize, model);
	int numOfDecVariables = model.numOfDecVariables;										    //决策变量维度
	int** bestIndividualSet = create2DIntMat(maxGeneration, numOfDecVariables);                 //每代最优个体集合
	double* bestFitnessSet = new double[maxGeneration];											//每代最高适应度集合
	double* avgFitnessSet = new double[maxGeneration];											//每代平均适应度集合
	int** newPopulation;
	double* newPopFitness;
	
	double f = getIndividualFitness2(population[0], model);
	printf("第0代种群:%.3lf %.3lf\n", -popFitness[0], -f);
	for(int i = 0; i < maxGeneration; i++)
	{
		newPopulation = selectionOperationOfTournament(population, popFitness, populationSize);						//选择操作
		newPopulation = crossoverOperationOfTsp(newPopulation, crossoverRate, populationSize, numOfDecVariables);	//交叉操作
		newPopulation = mutationOperation(newPopulation, mutationRate, populationSize, numOfDecVariables);			//变异操作 
		newPopFitness = getPopulationFitness(newPopulation, populationSize, model);                       			//子代种群适应度
		strongEliteSelect(population, popFitness, newPopulation, newPopFitness, populationSize);					//精英策略 
		
		copyArray(bestIndividualSet[i], population[0], numOfDecVariables);											//第i代最优个体
		bestFitnessSet[i] =-popFitness[0];																			//第i代最高适应度
		avgFitnessSet[i] = -getAvg(popFitness, populationSize);
		
		f = getIndividualFitness2(bestIndividualSet[i], model);
		
		
		printf("第%d代种群:\t%.3lf %.3lf\n", i+1, bestFitnessSet[i], -f);

		
	}

	showArray(population[0], numOfDecVariables);
	delete bestFitnessSet;
	delete avgFitnessSet;
	return 0;
}


void showArray(int *array, int n)
{
	for(int i = 0; i < n; i++)
		printf("%-4d", array[i]);
	printf("\n");
}
void showArray(double *array, int n)
{
	for(int i = 0; i < n; i++)
		printf("%-.3lf\n", array[i]);
	printf("\n");
}
void showMat(int** matData, int n, int m)
{
	for(int i = 0; i < n; i++)
	{
		for(int j = 0; j < m; j++)
			printf("%-5d", matData[i][j]);
		printf("\n");
	}
}
void showProblem(ProblemData proData)
{
	printf("%-20s%s\n","数据存放路径:", proData.dataSetPath);
	printf("%-20s%s\n","数据文件名:", proData.dataSetName);
	printf("%-20s%d\n","学生数:", proData.numOfDecVariables);
	printf("%-20s%d\n","每个学生数据数量:", proData.lengthOfData);
	printf("%-20s%d\n","每个宿舍学生人数:", proData.numOfDormPeople);
	printf("%-20s%d\n","宿舍数:", proData.numOfDorm);
	int n = 10; 
	printf("前%d条学生数据:\n",n);
	showMat(proData.studentData, n, proData.lengthOfData);
}
ProblemData initModelOfProblem()
{
	ProblemData proData;
	proData.dataSetPath = new char[100];
	proData.dataSetName = new char[100];
	strcpy(proData.dataSetPath, "C:\\Users\\12098\\Desktop\\改进遗传算法组合优化问题（学生宿舍分配）\\Data\\");
	strcpy(proData.dataSetName, "random_data.txt");
	proData.numOfDormPeople = 6;
	proData.numOfDecVariables = 300;
	proData.lengthOfData = 8; 
	proData.numOfDorm = proData.numOfDecVariables / proData.numOfDormPeople;
	char *path = strcat(proData.dataSetPath, proData.dataSetName);
	proData.studentData = load(path, proData.numOfDecVariables, proData.lengthOfData);
	return proData;
}
int** load(char *path, int n, int m)
{
	int** studentData = create2DIntMat(n, m);
	FILE *fp = fopen(path, "r");
	for(int i = 0; i < n; i++)
		for(int j = 0; j < m; j++)
			fscanf(fp, "%d", &studentData[i][j]);
	fclose(fp);
	return studentData;
}
double getRand()
{
	return rand()/(RAND_MAX+1.0);
}
int getRand(int min, int max)
{
	int n = max - min + 1;
	return rand() % n + min;
}
int find(int* array, int n, int x)
{
	for(int i=0;i<n;i++)
		if(array[i]==x)
			return i;
	return 0;
}
int* randperm(int n)
{
	int* array = new int[n];
	for(int i = 0; i < n; i++)
		array[i] = i + 1;
	random_shuffle(array, array + n);
	return array;
}
double LpNorm(int* vector1, int* vector2, int n)
{
	double sum = 0;
	for(int i = 0; i < n; i++)
		sum += (vector1[i] - vector2[i]) * (vector1[i] - vector2[i]);
	return sqrt(sum);
}
void copyArray(int* a, int *b, int n)
{
	for(int i = 0; i < n; i++)
		a[i] = b[i];
}
double getAvg(double *b, int n)
{
	double sum = 0;
	for(int i = 0; i < n; i++)
		sum += b[i];
	return sum / n;
}
double getMax(double *b, int n)
{
	double x = b[0];
	for(int i = 0; i < n; i++)
		if(x < b[i])
			x = b[i];
	return x;
}
void sortPF(double* F, int** P, int n)
{
	for(int i=0; i<n; i++)
	{
		int k = i;
		for(int j=i+1;j<n;j++)
			if(F[k]<F[j])
				k=j;
		double t = F[k];
		F[k] = F[i];
		F[i] = t;
		
		int* x = P[k];
		P[k] = P[i];
		P[i] = x;
	}
}
void strongEliteSelect(int** population, double* popFitness, int** newPopulation, double* newPopFitness, int populationSize)
{
	int n = populationSize;
	int** P = new int *[n * 2];
	double* F = new double[n * 2];
	for(int i = 0; i < n; i++)
	{
		P[i] = population[i];
		P[n + i] = newPopulation[i];
		F[i] = popFitness[i];
		F[n + i] = newPopFitness[i];
	}
	sortPF(F, P, n*2);
	for(int i = 0; i < n; i++)
	{
		population[i] = P[i];
		popFitness[i] = F[i];
	}
	delete P;
	delete F;
}
int** create2DIntMat(int n, int m)
{
	int** mat2D = new int *[n];
	for(int i = 0; i < n; i++)
		mat2D[i] = new int[m];
	return mat2D;
} 
void deleteIntMat(int** intMat, int n)
{
	for(int i = 0; i < n; i++)
		delete intMat[i];
	delete intMat;
}
double getIndividualFitness(int* individual, ProblemData model)		//计算个体适应度
{
	int numOfDecVariables = model.numOfDecVariables;
	int numOfDorm = model.numOfDorm;
	double sumDis = 0;
	for(int i = 1; i <= numOfDorm; i++)
	{
		int** studentDatasOfDorm = getStudentDatasOfDorm(i, individual, model);
		double dormDis = getDormDis(studentDatasOfDorm, model);
		sumDis = sumDis + dormDis;
		deleteIntMat(studentDatasOfDorm, model.numOfDormPeople);
	}
	double individualFitness = -sumDis * 2;                        //适应度越大越好
	return individualFitness / numOfDecVariables;
} 
double getIndividualFitness2(int* individual, ProblemData model)
{
	int numOfDecVariables = model.numOfDecVariables;		//300
	int numOfDormPeople = model.numOfDormPeople;			//6
	int numOfDorm = model.numOfDorm;						//50
	int lengthOfData = model.lengthOfData;					//8
	
	double* dis = new double[numOfDecVariables];
	double sumDis = 0;
	for(int i = 1; i <= numOfDorm; i++)
	{
		int** studentDatasOfDorm = getStudentDatasOfDorm(i, individual, model);
		
		for(int j = 0; j < numOfDormPeople; j++)
		{
			double sum = 0;
			for(int k = 0; k < numOfDormPeople; k++)
				sum += LpNorm(studentDatasOfDorm[j], studentDatasOfDorm[k], lengthOfData);
			dis[(i-1)*numOfDormPeople + j] = sum;
		}
		deleteIntMat(studentDatasOfDorm, model.numOfDormPeople);
	}
	delete dis;
	double individualFitness = -getMax(dis, numOfDecVariables);                 //适应度越大越好
	return individualFitness;
} 

int** getStudentDatasOfDorm(int i, int* individual, ProblemData model)
{
	int** studentData = model.studentData;
	int numOfDormPeople = model.numOfDormPeople;
	int* dormI = new int[numOfDormPeople];
	int start = numOfDormPeople * i - numOfDormPeople;
	for(int j = 0; j < numOfDormPeople; j++)
		dormI[j] = start + j;
	int* studentIdsOfDorm = new int[numOfDormPeople];
	for(int j = 0; j < numOfDormPeople; j++)
		studentIdsOfDorm[j] = individual[dormI[j]]-1;
	delete dormI;
	
	int m = model.lengthOfData;
	int** studentDatasOfDorm = create2DIntMat(numOfDormPeople, m);
	
	for(int j = 0; j < numOfDormPeople; j++)
	{
		int id = studentIdsOfDorm[j];
		for(int k = 0; k < m; k++)
			studentDatasOfDorm[j][k] = studentData[id][k];
	}
	delete studentIdsOfDorm;
	return studentDatasOfDorm;
}

double getDormDis(int** studentDatasOfDorm, ProblemData model)
{
	int numOfDormPeople = model.numOfDormPeople;		//行 
	int lengthOfData = model.lengthOfData;				//列 
	double dormDis = 0;
	for(int i = 0; i < numOfDormPeople; i++) 
	{
		int* studentI = studentDatasOfDorm[i];
		for(int j = i + 1; j < numOfDormPeople; j++)
		{
			int* studentJ = studentDatasOfDorm[j];
            double dis = LpNorm(studentI, studentJ, lengthOfData);
            dormDis = dormDis + dis;
		}
	}
	return dormDis;
}

int** mutationOperation(int** population, double mutationRate, int populationSize, int numOfDecVariables)
{
	for(int i = 0; i < populationSize; i++)
		population[i] = mutateIndividual(population[i], mutationRate, numOfDecVariables);
	return population;
}
int* mutateIndividual(int* individual, double mutationRate, int numOfDecVariables)
{
	for(int i = 0; i < numOfDecVariables; i++)
		if(getRand() < mutationRate)
		{
			int j = getRand(0, numOfDecVariables - 1);			// 产生一个0 ~ n-1间的随机数
			int t = individual[i];
			individual[i] = individual[j];
            individual[j] = t;
		}
	return individual;
}



//========================================================================================= 

int** initialPopulation(int populationSize, ProblemData model)
{
	int numOfDecVariables = model.numOfDecVariables;
	int** population = new int *[populationSize];
	for(int i = 0; i < populationSize; i++)
		population[i] = randperm(numOfDecVariables);
	return population;
}

double* getPopulationFitness(int** population, int populationSize, ProblemData model)
{
	double* popFitness = new double[populationSize];
	for(int i = 0; i < populationSize; i++)
		popFitness[i] = getIndividualFitness(population[i], model);
	return popFitness;
}
double* getPopulationFitness2(int** population, int populationSize, ProblemData model)
{
	double* popFitness = new double[populationSize];
	for(int i = 0; i < populationSize; i++)
		popFitness[i] = getIndividualFitness2(population[i], model);
	return popFitness;
}

int** selectionOperationOfTournament(int** population, double* popFitness, int populationSize)
{
	int K = 2;				//K-tournament
	int** newPopulation = new int *[populationSize];
	for(int i = 0; i < populationSize; i++)
	{
		int r0 = rand() % populationSize;
		int r1 = rand() % populationSize;
		if(popFitness[r0] > popFitness[r1])
			newPopulation[i] = population[r0];
		else
			newPopulation[i] = population[r1];
	}
	return newPopulation;
}

int** crossoverOperationOfTsp(int** population, double crossoverRate, int populationSize, int numOfDecVariables)
{
	int** newPopulation = create2DIntMat(populationSize, numOfDecVariables);
	int n = numOfDecVariables;
	for(int i = 0; i < populationSize; i++)
	{
		int r0, r1;
		if(getRand() < crossoverRate)
		{
			r0 = getRand(0, n - 1);					// 产生一个0 ~ n-1间的随机数
			r1 = getRand(0, n - 1);
		}
		else
		{
			r0 = getRand(0, n - 1);	
			int* individual = population[i];                                //种群中的第i个个体（待交叉个体）
			int gene = individual[r0];                                       //从个体i中获取第j个基因位上的基因gene
			int I = getRand(0, populationSize - 1);
			int* individualI = population[I];                                 	//从种群中随机选择一个个体I
			int index = find(individualI, n, gene);
			if(index < n)													//获取基因gene相邻位置
				index++;													//右侧的位置
			else
				index--;													//左侧的位置
			gene = individualI[index]; 										//与之前基因gene相邻的基因（注意此时的gene已被更新）
			r1 = find(individualI, n, gene);								//在第i个个体（待交叉个体）中找到基因gene所在位置
		} 
		if(r0 > r1)
		{
			int t = r0;
			r0 = r1;
			r1 = t;
		}
		
		for(int j = 0; j < r0; j++)
			newPopulation[i][j] = population[i][j];
		for(int j = 0; j <= r1 - r0; j++)
			newPopulation[i][r0 + j] = population[i][r1 - j];				//r0-r1间元素倒序
		for(int j = r1 + 1; j < n; j++)
			newPopulation[i][j] = population[i][j];	
	}
	return newPopulation;
}











