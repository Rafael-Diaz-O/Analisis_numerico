clc; clear; close all;
% Ejercicio 2 - Taylor de orden 4 y RK4
% y' = y^2, y(0) = 1/2, 0 <= t <= 1, h = 0.1. Exacta: y = 1/(2 - t)
%
% Derivadas obtenidas a mano (regla de la cadena con y' = y^2):
%   y''   = 2 y y'        = 2 y^3
%   y'''  = 6 y^2 y'      = 6 y^4
%   y(4)  = 24 y^3 y'     = 24 y^5

disp('Expresiones de las derivadas (a partir de y'' = y^2):');
disp('  y''  = y^2');
disp('  y''''  = 2*y*y'' = 2*y^3');
disp('  y''''''  = 6*y^2*y'' = 6*y^4');
disp('  y^(4) = 24*y^3*y'' = 24*y^5');
fprintf('\n');

f      = @(t,y) y.^2;
derivs = @(t,y) [2*y^3, 6*y^4, 24*y^5];   % [y'', y''', y(4)]
yex    = @(t) 1./(2 - t);
a = 0; b = 1; y0 = 1/2; h = 0.1;

[t,yT] = my_taylor_rk4_Rafael_Diaz(f,derivs,a,b,y0,h,'taylor4');
[~,yR] = my_taylor_rk4_Rafael_Diaz(f,[],a,b,y0,h,'rk4');
ye = yex(t);
errT = abs(ye - yT);
errR = abs(ye - yR);

T = table(t, ye, yT, yR, errT, errR, ...
    'VariableNames',{'t','Exacta','Taylor4','RK4','Error_Taylor4','Error_RK4'});
disp('Ejercicio 2: Taylor de orden 4 y RK4 (h = 0.1)');
disp(T);
fprintf('Error maximo Taylor4: %.4e\n', max(errT));
fprintf('Error maximo RK4    : %.4e\n', max(errR));

tf = linspace(a,b,400);
figure;
plot(tf,yex(tf),'k-','LineWidth',1.5); hold on;
plot(t,yT,'ro--','LineWidth',1.2,'MarkerSize',5);
plot(t,yR,'bs--','LineWidth',1.2,'MarkerSize',5);
grid on; xlabel('t'); ylabel('y(t)');
title('Ejercicio 2: y'' = y^2, y(0)=1/2, h = 0.1');
legend('Exacta','Taylor orden 4','RK4','Location','best');