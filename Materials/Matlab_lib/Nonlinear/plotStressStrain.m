% function plotStressStrain(stress_data, strain_data)
%     % stress_data: 应力数据集（矩阵或向量）
%     % strain_data: 应变数据集（矩阵或向量）
% 
%     % 检查输入数据的维度是否匹配
%     if size(stress_data) ~= size(strain_data)
%         error('Stress and strain data dimensions do not match.');
%     end
% 
%     % 绘制应力应变图
%     figure;
%     plot(strain_data, stress_data, 'LineWidth', 2);
%     xlabel('Strain');
%     ylabel('Stress');
%     title('Stress-Strain Curve');
% 
%     % 可以添加其他绘图设置或者修饰图表
%     % 如添加网格、图例、调整线条样式等
%     grid on;
%     legend('Stress-Strain Curve');
% end

function plotStressStrain(stress_data, strain_data)
    % stress_data: 应力数据集（矩阵或向量）
    % strain_data: 应变数据集（矩阵或向量）

    % 检查输入数据的维度是否匹配
    if size(stress_data) ~= size(strain_data)
        error('Stress and strain data dimensions do not match.');
    end

    % 绘制应力应变图
    figure;
    plot(strain_data, stress_data, 'LineWidth', 2);
    xlabel('Strain');
    ylabel('Stress');
    title('Stress-Strain Curve');

    % 标记数据点
    hold on;
    scatter(strain_data, stress_data, 'filled', 'Marker', 'o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'b');

    % 可以添加其他绘图设置或者修饰图表
    % 如添加网格、图例、调整线条样式等
    grid on;
    legend('Stress-Strain Curve', 'Data Points');
end
