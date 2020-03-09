-module(recursion_exercise).
-export([search/2]).

%% 1) Dado un término y una lista, escribid una función que devuelva true o false dependiendo
%%    de si el término está o no en la lista.
%%
%% Por ej.,
%% search(c,[a,b,c]) -> true
%% search(1,[a,b,c]) -> false
search(_, []) -> false;
search(Element, [Element|_]) -> true;
search(Element, [_|T]) -> search(Element, T).