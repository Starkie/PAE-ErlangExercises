-module(recursion_exercise).
-export([search/2, unzip/1]).

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

unzip([], {Xs, Ys}) -> {Xs, Ys};
unzip([{X, Y} | T], {Xs, Ys}) -> unzip(T, {Xs ++ [X], Ys ++ [Y]}).