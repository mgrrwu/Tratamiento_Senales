function J=flip(I, str)

%funcion que efectúa un flip horizontal o vertical según el parametro str
%sea 'h' o 'v'


if strcmp(str, 'v')
    J=I(end:-1:1, :);
elseif strcmp(str, 'h')
    J=I(:, end:-1:1);
else
    error('la entrada str contiene un parametro incorrecto')
end