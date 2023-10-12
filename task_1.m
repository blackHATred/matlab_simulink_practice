clc;
modelname = 'model_1';
new_system(modelname);
open_system(modelname);

set_param(modelname, 'Solver', 'ode3');
set_param(modelname, 'StopTime', '15');
activeConfigSet = getActiveConfigSet(modelname);
set_param(activeConfigSet, 'SignalLogging', 'on');

% Добавляем блоки
add_block('simulink/Sources/Sine Wave', strcat(modelname, '/Sine_1'));
add_block('simulink/Continuous/Integrator', strcat(modelname, '/Integrator_1'));
add_block('simulink/Signal Routing/Mux', strcat(modelname, '/Mux_1'));
add_block('simulink/Sinks/Scope', strcat(modelname, '/Scope_1'));
add_block('simulink/Sinks/To File', strcat(modelname, '/File_1'));
% Настраиваем блок Sine Wave под условия
set_param(strcat(modelname, '/Sine_1'), 'Amplitude', '3');
set_param(strcat(modelname, '/Sine_1'), 'Phase', 'pi/2');
set_param(strcat(modelname, '/Sine_1'), 'Frequency', '2');
set_param(strcat(modelname, '/Sine_1'), 'Bias', '0.5');
% Настраиваем блок Integrator под условия
set_param(strcat(modelname, '/Integrator_1'), 'InitialCondition', '0.5');

% Соединяем блоки
add_line(modelname, 'Sine_1/1', 'Integrator_1/1');
add_line(modelname, 'Integrator_1/1', 'Mux_1/1');
add_line(modelname, 'Sine_1/1', 'Mux_1/2');
add_line(modelname, 'Mux_1/1', 'Scope_1/1');
add_line(modelname, 'Mux_1/1', 'File_1/1');

set_param(strcat(modelname, '/File_1'), 'FileName', 'Output.mat');
% Запуск моделирования
simOut = sim(modelname);


% Строим график. Так как Scope настроить нельзя, то используем
% экспортированные данные, чтобы построить график вручную
Data = load('Output.mat');
k = Data.ans.Data(:, 1);
% В задании не указано какой именно график делать синим, пускай это будет
% график интегратора
plot(Data.ans.Time, Data.ans.Data(:, 1), 'blue');
grid on;
hold on;
plot(Data.ans.Time, Data.ans.Data(:, 2), 'black');
set(gca, 'GridColor', 'black');
legend('Интегратор', 'Функция');
title('Графики функции и интегратора');


% Открытие Scope для просмотра результатов
open_system(strcat(modelname, '/Scope_1'));

% Сохраняем модель
save_system(modelname);
