clc; clear; close all;

%% EJERCICIO 2: Integración numérica
% I = integral de 0 a 12 de e^(-x) dx = 1 - e^(-12)

exacto = 1 - exp(-12);

denom  = [2 4 6 8 10 12 14 16 18 20];   % h = 1/denom
hs     = 1./denom;
nh     = numel(hs);

reglas = {'trapezoidal', 'simpson13', 'simpson38', 'boole'};
nombres = {'Trapecio', 'Simpson 1/3', 'Simpson 3/8', 'Boole'};

Q   = zeros(nh, 4);
Err = zeros(nh, 4);

for k = 1:nh
    N = 12*denom(k);                 % N = 12/h subintervalos
    x = (0:N)/denom(k);              % x_i = i*h
    y = exp(-x);
    for r = 1:4
        Q(k,r)   = my_integral_Rafael_Diaz(x, y, reglas{r});
        Err(k,r) = abs(Q(k,r) - exacto);
    end
end

%% Tabla 1: estimaciones de la integral
fprintf('Valor exacto I = %.14f\n\n', exacto);
fprintf('TABLA 1: Estimaciones de la integral\n');
fprintf('%-8s %-18s %-18s %-18s %-18s\n', 'h', nombres{:});
fprintf('%s\n', repmat('-', 1, 84));
for k = 1:nh
    fprintf('1/%-6d %-18.12f %-18.12f %-18.12f %-18.12f\n', denom(k), Q(k,:));
end

%% Tabla 2: errores absolutos
fprintf('\nTABLA 2: Errores absolutos\n');
fprintf('%-8s %-18s %-18s %-18s %-18s\n', 'h', nombres{:});
fprintf('%s\n', repmat('-', 1, 84));
for k = 1:nh
    fprintf('1/%-6d %-18.4e %-18.4e %-18.4e %-18.4e\n', denom(k), Err(k,:));
end

%% Gráfica de errores (ejes logarítmicos)
% Se reemplazan errores nulos por eps solo para poder graficarlos en escala log.
ErrPlot = max(Err, eps);

figure;
marcadores = {'-o', '-s', '-^', '-d'};
for r = 1:4
    loglog(hs, ErrPlot(:,r), marcadores{r}, 'LineWidth', 1.5); hold on;
end
grid on;
xlabel('Tamaño de paso h');
ylabel('Error absoluto');
title('Error absoluto de la integración de e^{-x} en [0, 12]');
legend(nombres, 'Location', 'southeast');
hold off;

%% ====================== FUNCIONES LOCALES ======================

function Q = my_integral_Rafael_Diaz(x, y, mode)
% Estima la integral desde el primer hasta el último punto de una tabla
% (x, y) con puntos igualmente espaciados, usando reglas compuestas.
%   mode: 'trapezoidal', 'simpson13', 'simpson38' o 'boole'

    % ---- Validación de entradas ----
    if ~(isnumeric(x) && isnumeric(y) && isvector(x) && isvector(y))
        error('x e y deben ser vectores numericos.');
    end
    if ~(isreal(x) && isreal(y) && all(isfinite(x)) && all(isfinite(y)))
        error('x e y deben ser reales y finitos.');
    end
    if numel(x) ~= numel(y)
        error('x e y deben tener la misma longitud.');
    end
    if numel(x) < 2
        error('Se requieren al menos 2 puntos.');
    end
    if ~((ischar(mode) && isrow(mode)) || (isstring(mode) && isscalar(mode)))
        error('mode debe ser una cadena de texto.');
    end
    mode = char(mode);

    x = x(:); y = y(:);
    dx = diff(x);                      % solo para validar (no se integra con esto)
    if any(dx <= 0)
        error('Los puntos de x deben ser estrictamente crecientes.');
    end
    h = (x(end) - x(1)) / (numel(x) - 1);
    if any(abs(dx - h) > 1e-8*max(1, abs(h)))
        error('Los puntos de x deben estar igualmente espaciados.');
    end

    N = numel(x) - 1;                  % numero de subintervalos
    i = (0:N).';                       % indices 0-based

    % ---- Reglas compuestas ----
    switch lower(mode)
        case 'trapezoidal'
            % N >= 1
            w = 2*ones(N+1,1);
            w([1 end]) = 1;
            Q = (h/2) * sum(w .* y);

        case 'simpson13'
            if mod(N,2) ~= 0
                error('Simpson 1/3 requiere N multiplo positivo de 2.');
            end
            w = zeros(N+1,1);
            w(mod(i,2) == 1) = 4;
            w(mod(i,2) == 0) = 2;
            w([1 end]) = 1;
            Q = (h/3) * sum(w .* y);

        case 'simpson38'
            if mod(N,3) ~= 0
                error('Simpson 3/8 requiere N multiplo positivo de 3.');
            end
            w = 3*ones(N+1,1);
            w(mod(i,3) == 0) = 2;
            w([1 end]) = 1;
            Q = (3*h/8) * sum(w .* y);

        case 'boole'
            if mod(N,4) ~= 0
                error('Boole requiere N multiplo positivo de 4.');
            end
            w = zeros(N+1,1);
            w(mod(i,2) == 1) = 32;
            w(mod(i,4) == 2) = 12;
            w(mod(i,4) == 0) = 14;
            w([1 end]) = 7;
            Q = (2*h/45) * sum(w .* y);

        otherwise
            error('Modo no valido. Use ''trapezoidal'', ''simpson13'', ''simpson38'' o ''boole''.');
    end
end