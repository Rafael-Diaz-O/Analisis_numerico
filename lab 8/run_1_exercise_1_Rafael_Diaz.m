clc; clear; close all;
% Ejercicio 1 - Euler y Heun
% y' = (t - y)/2, y(0) = 1, 0 <= t <= 3, h = 0.25
% Solucion exacta: y(t) = t - 2 + 3 exp(-t/2)
%
% Verificacion a mano de la solucion exacta:
%   y' = 1 - (3/2) exp(-t/2)   y   (t - y)/2 = (2 - 3exp(-t/2))/2 = 1 - (3/2)exp(-t/2)  OK
%   y(0) = 0 - 2 + 3 = 1  OK

f     = @(t,y) (t - y)/2;
yex   = @(t) t - 2 + 3*exp(-t/2);
a = 0; b = 3; y0 = 1; h = 0.25;

[t,yE] = my_euler_heun_Rafael_Diaz(f,a,b,y0,h,'euler');
[~,yH] = my_euler_heun_Rafael_Diaz(f,a,b,y0,h,'heun');
ye  = yex(t);
errE = abs(ye - yE);
errH = abs(ye - yH);

T = table(t, ye, yE, yH, errE, errH, ...
    'VariableNames',{'t','Exacta','Euler','Heun','Error_Euler','Error_Heun'});
disp('Ejercicio 1: comparacion de Euler y Heun (h = 0.25)');
disp(T);
fprintf('Error maximo Euler: %.4e\n', max(errE));
fprintf('Error maximo Heun : %.4e\n', max(errH));

tf = linspace(a,b,400);
figure;
plot(tf,yex(tf),'k-','LineWidth',1.5); hold on;
plot(t,yE,'ro--','LineWidth',1.2,'MarkerSize',5);
plot(t,yH,'bs--','LineWidth',1.2,'MarkerSize',5);
grid on; xlabel('t'); ylabel('y(t)');
title('Ejercicio 1: y'' = (t-y)/2, y(0)=1, h = 0.25');
legend('Exacta','Euler','Heun','Location','best');