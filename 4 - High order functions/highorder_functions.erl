-module(highorder_functions).
-export([in_rank/3, unzip/1, unzip_fold/1, keys/2, first/1]).

%% 1) Dados dos enteros, Start y End, y una lista List, escribid una función que devuelva una lista de booleanos indicando, para cada elemento de List, si está o no dentro del intervalo.
%%  Por ej.,
%% in_rank(3, 5, lists:seq(1, 10)) -> [false,false,true,true,true,false,false,false,false,false]
%% Pista: usad la función map con una función anónima de un argumento que use los valores Start y End.
in_rank(Start, End, List) -> lists:map(fun(X) -> X >= Start andalso X =< End end, List).

%% 2) Escribid una versión de la función unzip del ejercicio anterior empleando la función map.
%% unzip([{A, B} | T]) ->
%% {AT, BT} = unzip(T),
%% {[A | AT], [B | BT]};

%% unzip([]) -> %% {[], []}.
unzip(List) -> {lists:map(fun({X, _}) -> X end, List),
                lists:map(fun({_, Y}) -> Y end, List)}.

%% 3) Volved a implementar unzip pero ahora usando foldr o foldl con un acumulador inicializado a {[],[]}.
unzip_fold(List) ->
  {A,B} = lists:foldl(fun ({X, Y}, {XS, YS}) -> {[X | XS], [Y | YS]} end, {[], []}, List),
  {lists:reverse(A), lists:reverse(B)}.

%% 4) Escribid una función que tome una lista de claves y una lista de pares {clave,valor}
%%    y devuelva los valores correspondientes a las claves.
%%    Por ej.,
%%    keys([a,c],[{a,ok},{b,23},{c,"hi"}]) -> [ok,"hi"]
%% Podéis emplear la siguiente función auxiliar para buscar el valor de una clave:
%%
%% lk(_Key,[]) -> not_found;
%% lk(Key,[{Key,Val}|_]) -> Val;
%% lk(Key,[_|R]) -> lk(Key,R).

keys(Keys, KeyValuePairs) ->
  lists:foldl(
    fun({K,V}, Acc) ->
      FoundValue = lk(K, KeyValuePairs),
      if FoundValue =/= not_found -> [V | Acc];
        true -> Acc
      end
    end,
    [],
    Keys).

lk(_Key,[]) -> not_found;
lk(Key,[{Key,Val}|_]) -> Val;
lk(Key,[_|R]) -> lk(Key,R).


%% 5) Escribid una función que, dada una lista de términos, devuelva los primeros elementos de las tuplas
%%    y listas que contenga. Para el resto de términos, incluyendo tuplas o listas vacías,
%%    no incluyáis nada en la lista resultante.
%%
%% Por ej.,
%%
%% first([1,a,{1,2},{2},[{3},4],"ba", []]) -> [1,2,{3},98]
%%
%% (98 es el ASCII de la letra ‘b’)
%%
%% Pista: podéis usar filter para quedaros con los elementos que sean listas de longitud
%% mayor que 0 (length(E)>0) o tuplas con al menos un elemento ().
%% En el caso de las tuplas, podéis obtener el primer elemento con la función element/2.
first(List) ->
  Elements = lists:filter(
    fun(X) ->
      is_list(X) andalso length(X) > 0
      orelse is_tuple(X) andalso size(X) > 0
    end,
    List),
  lists:map(fun([H | _]) -> H; (E) when is_tuple(E) -> element(1, E) end, Elements).