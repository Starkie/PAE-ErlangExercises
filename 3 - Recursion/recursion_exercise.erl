-module(recursion_exercise).
-export([search/2, unzip/1, calc/1]).

%% 1) Dado un término y una lista, escribid una función que devuelva true o false dependiendo
%%    de si el término está o no en la lista.
%%
%% Por ej.,
%% search(c,[a,b,c]) -> true
%% search(1,[a,b,c]) -> false
search(_, []) -> false;
search(Element, [Element|_]) -> true;
search(Element, [_|T]) -> search(Element, T).

%% 2) Dada una lista de tuplas de dos elementos, escribid una función que devuelva una tupla con dos listas: la primera lista con los elementos que ocupan la primera posición en las tuplas de la lista original y la segunda lista con los que ocupan la segunda posición.
%% Por ej.,
%% unzip([{1,3}, {4,3}, {5,6}]) -> {[1,4,5],[3,3,6]}
%%
%% Pista: la típica construcción
%% let X = foo(Y) in E de lenguajes como Haskell, se escribe en Erlang simplemente como
%% X = foo(Y), E
unzip(X) -> unzip(X, {[], []}).

%% Using a tail recursive implementation is cheaper that appending each element every
%% single time.
unzip([], {Xs, Ys}) -> {lists:reverse(Xs), lists:reverse(Ys)};
unzip([{X, Y} | T], {Xs, Ys}) -> unzip(T, {[X | Xs], [Y | Ys]}).


%% 3) Ampliad la calculadora de la tarea anterior para que acepte términos con
%%    funciones términos como éstos:
%%    {add, {sub, 4, {neg, 5}}, {coc, 3, 4}}

calc({add, X, Y}) -> calc(X) + calc(Y);
calc({sub, X, Y}) -> calc(X) - calc(Y);
calc({mul, X, Y}) -> calc(X) * calc(Y);
calc({coc, X, Y}) -> calc(X) / calc(Y);
calc({neg, X}) -> - calc(X);
calc(X) when is_integer(X); is_float(X) -> X.