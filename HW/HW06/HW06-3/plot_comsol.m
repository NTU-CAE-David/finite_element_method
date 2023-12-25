% 讀取文本文件
fileID = fopen('HW06-3_c/hw6-3_c_curve.txt', 'r');
data = textscan(fileID, '%f %f', 'HeaderLines', 8); % 從第10行開始讀取數據
fclose(fileID);

% 從讀取的數據中提取應力和應變數據
strain_data = data{1};
stress_data = data{2};

% 使用提供的函數繪製應力-應變曲線
plotStressStrain(stress_data, strain_data);
