-module(functions_exercise).
-export([ord/1, igual/1, foo/1, calc/1]).

%% 1) Escribid una función que devuelva el ordinal de un número en inglés (considera sólo números del 1 al 9).
%% Por ej.,
%% ord(1) -> "1st"
%% ord(2) -> "2nd"
%% ord(3) -> "3rd"
%% ord(4) -> "4th"
%%
%% PISTA: puedes usar integer_to_list(N) para transformar un entero en un string.

ord(Num) when Num > 0 ->
  case lastDigitOfNumber(Num) of
    1 -> integer_to_list(Num) ++ "st";
    2 -> integer_to_list(Num) ++ "nd";
    3 -> integer_to_list(Num) ++ "rd";
    _ -> integer_to_list(Num) ++ "th"
  end.

%% Returns the last digit of an integer.
lastDigitOfNumber(Num) -> list_to_integer([lists:last(integer_to_list(Num))]).

%% 2) Escribid  una función que, dada una tupla de dos elementos, diga si son iguales o no.
%% Por ej.,
%% igual({2,3}) -> false
%% igual({a,a}) -> true
igual({X, X}) -> true;
igual(_) -> false.

%%3) Escribid una función que tome una lista cuyo primer elemento es una tupla de dos elementos.
%%   Si los dos elementos son iguales, debe devolver una lista con el resto de elementos.
%%   En caso contratio, debe devolver la tupla pero intercambiando los elementos de posición.
%%
%% Por ej.,
%% foo([{4,4},a,b,c]) -> [a,b,c]
%% foo([{3,4},a,b,c]) -> {4,3}
foo([{X, X} | Tail]) -> Tail;
foo([{X, Y} | _]) -> {Y, X};
foo(X) -> X.

%% 4) Escribid una función que actúe como una calculadora: dada una tupla de la forma
%%         {OPERACIÓN, NUM1, NUM2}
%% debe devolver el resultado de evaluar la OPERACIÓN con los argumentos NUM1 y NUM2.
%%
%% Por ej.,
%%
%% calc({add,6,3}) -> 9
%% calc({sub,6,3}) -> 3
%% calc({mul,6,3}) -> 18
%% calc({coc,6,3}) -> 2  %% coc de cociente
%% calc({neg,6}) -> -6
calc({add, X, Y}) -> X + Y;
calc({sub, X, Y}) -> X - Y;
calc({mult, X, Y}) -> X * Y;
calc({coc, X, Y}) -> X / Y;
calc({neg, X}) -> -X.