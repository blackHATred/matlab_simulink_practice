clc;
modelname = 'model_2';
new_system(modelname);
open_system(modelname);

set_param(modelname, 'Solver', 'ode45');

% Добавляем блоки
add_block('simulink/Sources/Sine Wave', strcat(modelname, '/Sine_1'));
add_block('simulink/Continuous/Integrator', strcat(modelname, '/Integrator_1'));
add_block('simulink/Math Operations/Sum', strcat(modelname, '/Sum_1'));
add_block('simulink/Math Operations/Gain', strcat(modelname, '/Gain_1'));
add_block('simulink/Sinks/Scope', strcat(modelname, '/Scope_1'));

set_param(strcat(modelname, '/Sum_1'), 'Inputs', '|+-');
set_param(strcat(modelname, '/Gain_1'), 'Gain', '2');

% Настраиваем блок Integrator под начальное условие x(0) = 0.4
set_param(strcat(modelname, '/Integrator_1'), 'InitialCondition', '0.4');

% Соединяем блоки
add_line(modelname, 'Sine_1/1', 'Sum_1/1');
add_line(modelname, 'Sum_1/1', 'Integrator_1/1');
add_line(modelname, 'Integrator_1/1', 'Scope_1/1');
add_line(modelname, 'Integrator_1/1', 'Gain_1/1');
add_line(modelname, 'Gain_1/1', 'Sum_1/2');

% Запускаем модель
sim(modelname);