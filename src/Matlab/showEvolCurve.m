function showEvolCurve(startI, endI, bestFitnessSet, avgFitnessSet)
% չʾ��Ⱥ��������
    scope = startI: endI;
    plot(scope, bestFitnessSet(scope)', (scope), avgFitnessSet(scope)', 'LineWidth', 2);
    title('Population Evolution Curve', 'Fontsize', 20);
    legend('Maximum Fitness', 'Average Fitness');
    xlabel('The Number Of Generations', 'Fontsize', 15);
    ylabel('Distance', 'Fontsize', 15);
    grid on;
    drawnow;
end

