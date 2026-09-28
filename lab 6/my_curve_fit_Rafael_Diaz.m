function [A,B,calculationTable] = my_curve_fit_Rafael_Diaz(x,y,mode,M)
% MY_CURVE_FIT_FIRSTNAME_LASTNAME  Ajuste por minimos cuadrados.
%
%   [A,B,calculationTable] = my_curve_fit_firstname_lastname(x,y,mode,M)
%
%   Entradas:
%     x,y  : vectores de datos, reales, finitos, de igual longitud.
%     mode : 'linear_fit'  -> ajusta y = A*x + B (metodo de las ecuaciones
%                              normales).
%            'power_Fit'   -> ajusta y = A*x^M (formula de minimos
%                              cuadrados para ajuste potencial). B = 0.
%     M    : exponente real y finito, usado solo en 'power_Fit'.
%            En 'linear_fit' debe pasarse [].
%
%   Salidas:
%     A,B  : coeficientes ajustados.
%     calculationTable : una fila por dato y una fila final con las sumas
%            de columnas.
%            'linear_fit' -> columnas [xk, yk, xk^2, xk*yk]
%            'power_Fit'  -> columnas [xk, yk, xk^M, xk^M*yk, xk^(2M)]

% ---------- Validaciones ----------
x = x(:);
y = y(:);

if isempty(x) || isempty(y)
    error('x e y no pueden estar vacios.');
end
if length(x) ~= length(y)
    error('x e y deben tener la misma longitud.');
end
if ~isreal(x) || ~isreal(y) || any(~isfinite(x)) || any(~isfinite(y))
    error('x e y deben ser reales y finitos.');
end

n = length(x);

switch mode
    case 'linear_fit'
        if n < 2 || length(unique(x)) < 2
            error('Para linear_fit se necesitan al menos dos valores distintos de x.');
        end

        xk  = x;
        yk  = y;
        xk2 = x.^2;
        xkyk = x.*y;

        sums = [sum(xk), sum(yk), sum(xk2), sum(xkyk)];
        calculationTable = [xk, yk, xk2, xkyk; sums];

        % Ecuaciones normales:
        % [ sum(x^2)  sum(x) ] [A]   [ sum(x*y) ]
        % [ sum(x)      n    ] [B] = [ sum(y)   ]
        Mat = [sums(3), sums(1);
            sums(1), n     ];
        rhs = [sums(4); sums(2)];

        coef = Mat \ rhs;   % backslash permitido
        A = coef(1);
        B = coef(2);

    case 'power_Fit'
        if isempty(M) || ~isreal(M) || ~isfinite(M)
            error('M debe ser un escalar real y finito para power_Fit.');
        end

        xk    = x;
        yk    = y;
        xkM   = x.^M;
        xkMyk = xkM.*y;
        xk2M  = x.^(2*M);

        if all(xkM == 0)
            error('Los valores x^M no pueden ser todos cero.');
        end

        sums = [sum(xk), sum(yk), sum(xkM), sum(xkMyk), sum(xk2M)];
        calculationTable = [xk, yk, xkM, xkMyk, xk2M; sums];

        % Formula de minimos cuadrados para ajuste potencial y = A*x^M:
        % A = sum(x^M * y) / sum(x^(2M))
        A = sums(4) / sums(5);
        B = 0;

    otherwise
        error('mode debe ser ''linear_fit'' o ''power_Fit''.');
end

end