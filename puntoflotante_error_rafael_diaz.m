function [E_abs, E_rel] = puntoflotante_error_rafael_diaz(N, N_resultado)

% 1. Cálculo del Error Absoluto
E_abs = abs(N - N_resultado);

% 2. Cálculo del Error Relativo
if N == 0
    E_rel = 0; % Para evitar la división por cero si N es 0
else
    E_rel = E_abs / abs(N);
end
end