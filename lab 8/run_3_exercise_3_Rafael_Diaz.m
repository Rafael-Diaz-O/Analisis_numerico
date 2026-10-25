clc; clear; close all;
% Ejercicio 3 - Crecimiento poblacional (logistico)
% P' = r P (1 - P/K), P(0) = P0, r = 0.5, K = 1000, P0 = 100, t en [0,10]

r = 0.5; K = 1000; P0 = 100; a = 0; b = 10;

%% a) Solucion analitica (separacion de variables)
% dP / [P(1-P/K)] = r dt.  Fracciones parciales: 1/[P(1-P/K)] = 1/P + (1/K)/(1-P/K)
% => ln|P| - ln|1 - P/K| = r t + C  =>  P/(1-P/K) = C1 e^{rt}
% Con P(0)=P0:  C1 = P0/(1-P0/K) = K P0/(K-P0)
% Despejando:   P(t) = K / (1 + ((K-P0)/P0) e^{-r t})
% Con los datos: P(t) = 1000 / (1 + 9 e^{-0.5 t})
disp('a) Solucion exacta:');
disp('   P(t) = K / (1 + ((K-P0)/P0)*exp(-r*t))');
fprintf('   P(t) = %g / (1 + %g*exp(-%g*t))\n\n', K, (K-P0)/P0, r);
Pex = @(t) K ./ (1 + ((K-P0)/P0)*exp(-r*t));

%% b) Derivadas y comparacion con h = 0.5
% P'    = r P (1 - P/K)
% P''   = r P' (1 - 2P/K)
% P'''  = r [ P'' (1 - 2P/K) - (2/K) (P')^2 ]
% P(4)  = r [ P''' (1 - 2P/K) - (6/K) P' P'' ]
disp('b) Derivadas obtenidas a partir del modelo:');
disp('   P''    = r*P*(1 - P/K)');
disp('   P''''   = r*P''*(1 - 2*P/K)');
disp('   P''''''  = r*( P''''*(1 - 2*P/K) - (2/K)*(P'')^2 )');
disp('   P^(4)  = r*( P''''''*(1 - 2*P/K) - (6/K)*P''*P'''' )');
fprintf('\n');

f = @(t,P) r*P*(1 - P/K);
p1 = @(P) r*P.*(1 - P/K);                                   % P'
p2 = @(P) r*p1(P).*(1 - 2*P/K);                             % P''
p3 = @(P) r*(p2(P).*(1 - 2*P/K) - (2/K)*p1(P).^2);          % P'''
p4 = @(P) r*(p3(P).*(1 - 2*P/K) - (6/K)*p1(P).*p2(P));      % P(4)
derivs = @(t,P) [p2(P), p3(P), p4(P)];

h = 0.5;
[t,PE]  = my_euler_heun_Rafael_Diaz(f,a,b,P0,h,'euler');
[~,PH]  = my_euler_heun_Rafael_Diaz(f,a,b,P0,h,'heun');
[~,PT]  = my_taylor_rk4_Rafael_Diaz(f,derivs,a,b,P0,h,'taylor4');
[~,PR]  = my_taylor_rk4_Rafael_Diaz(f,[],a,b,P0,h,'rk4');
Pe = Pex(t);

T = table(t,Pe,PE,PH,PT,PR, ...
    'VariableNames',{'t','Exacta','Euler','Heun','Taylor4','RK4'});
disp('Tabla (h = 0.5 meses, 21 puntos):');
disp(T);

tf = linspace(a,b,400);
figure;
plot(tf,Pex(tf),'k-','LineWidth',1.6); hold on;
plot(t,PE,'ro--','MarkerSize',4);
plot(t,PH,'bs--','MarkerSize',4);
plot(t,PT,'g^--','MarkerSize',4);
plot(t,PR,'mx--','MarkerSize',6);
grid on; xlabel('t (meses)'); ylabel('P(t) (peces)');
title('Poblacion de peces, h = 0.5');
legend('Exacta','Euler','Heun','Taylor orden 4','RK4','Location','best');

%% c) Estudio de convergencia
den = [2 4 6 8 10 12 14 16 18 20];
hs  = 1./den;
nh  = numel(hs);
err = zeros(nh,4);       % columnas: Euler, Heun, Taylor4, RK4
Pfin = Pex(b);
for i = 1:nh
    hi = hs(i);
    [~,y1] = my_euler_heun_Rafael_Diaz(f,a,b,P0,hi,'euler');
    [~,y2] = my_euler_heun_Rafael_Diaz(f,a,b,P0,hi,'heun');
    [~,y3] = my_taylor_rk4_Rafael_Diaz(f,derivs,a,b,P0,hi,'taylor4');
    [~,y4] = my_taylor_rk4_Rafael_Diaz(f,[],a,b,P0,hi,'rk4');
    err(i,:) = abs(Pfin - [y1(end) y2(end) y3(end) y4(end)]);
end

T2 = table(hs(:),err(:,1),err(:,2),err(:,3),err(:,4), ...
    'VariableNames',{'h','Error_Euler','Error_Heun','Error_Taylor4','Error_RK4'});
disp('Error absoluto en P(10) = |P(10) - P_M|:');
disp(T2);

figure;
loglog(hs,err(:,1),'ro-','LineWidth',1.3); hold on;
loglog(hs,err(:,2),'bs-','LineWidth',1.3);
loglog(hs,err(:,3),'g^-','LineWidth',1.3);
loglog(hs,err(:,4),'mx-','LineWidth',1.3);
grid on; xlabel('h (meses)'); ylabel('|P(10) - P_M|');
title('Error en el tiempo final vs. h');
legend('Euler','Heun','Taylor orden 4','RK4','Location','best');

nombres = {'Euler','Heun','Taylor de orden 4','RK4'};
[~,imin] = min(err(1,:));
fprintf('\nCon h = 0.5 meses, el metodo con menor error es: %s (%.4e).\n', ...
    nombres{imin}, err(1,imin));
fprintf('Las h estan ordenadas de mayor a menor (h = 1/2, ..., 1/20).\n');
for j = 1:4
    if all(diff(err(:,j)) < 0)
        fprintf('  %-18s: el error DISMINUYE al reducir h en todos los valores probados.\n',nombres{j});
    else
        fprintf('  %-18s: el error NO disminuye de forma monotona al reducir h.\n',nombres{j});
    end
end