function [disMat] = LpNorm(vector1, vector2, p)
% Lp�����������ϵľ���
% p=1ʱ��Ϊ�����پ��룻p=2ʱ��ŷ�Ͼ��룻
% ����vector1 = [0 0]; vector2 = [3 4]; p = 2;              �����disMat = [5];
%     vector1 = [0 0; 2 2]; vector2 = [3 4; 1 1]; p = 1;	�����disMat = [7;2];
    N = size(vector1, 1);
    disMat = zeros(N, 1);
    for i = 1 : N
        v1 = vector1(i, :);
        v2 = vector2(i, :);
        disMat(i) = sum(abs(v1 - v2).^p).^(1./p);    
    end
end

