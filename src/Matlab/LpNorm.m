function [disMat] = LpNorm(vector1, vector2, p)
% Lp范数，广义上的距离
% p=1时，为曼哈顿距离；p=2时，欧氏距离；
% 例：vector1 = [0 0]; vector2 = [3 4]; p = 2;              输出：disMat = [5];
%     vector1 = [0 0; 2 2]; vector2 = [3 4; 1 1]; p = 1;	输出：disMat = [7;2];
    N = size(vector1, 1);
    disMat = zeros(N, 1);
    for i = 1 : N
        v1 = vector1(i, :);
        v2 = vector2(i, :);
        disMat(i) = sum(abs(v1 - v2).^p).^(1./p);    
    end
end

