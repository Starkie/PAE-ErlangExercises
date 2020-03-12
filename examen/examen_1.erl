-module(examen_1).
-export([juego/2, rel/3, incremento/1, sumpar/1, sumpar_tr/1, joinmax/2, joinmax_tr/2,
         flip/1, flip_tr/1, noneg/1, minmax/1, sumlist/1]).

%% Tarea 1. List comprehension.
%%
%% Dada la variable
%%
%%    X = lists:seq(1,10).
%%
%% Escribe listas intensionales para calcular los siguientes casos:
%%
%% 1) Una lista con tuplas de la forma [{1,2},{2,3},{3,4},...,{9,10}].
%% SOLUTION:
%% 10> X = lists:seq(1, 10).
%% [1,2,3,4,5,6,7,8,9,10]
%% 11> SeqTuples = [{X1, X1 + 1} || X1 <- X, X1 < 10].
%% [{1,2},{2,3},{3,4},{4,5},{5,6},{6,7},{7,8},{8,9},{9,10}]

%% 2) La lista resultante de multiplicar por dos cada elemento de la lista X: [2,4,6,8,10,12,14,16,18,20]
%%
%% SOLUTION:
%% 12> DoubleElements = [2 * X1 || X1 <- X].
%% [2,4,6,8,10,12,14,16,18,20]

%% Tarea 2. Funciones y pattern-matching

%% 1) Escribe una función que nos indique el ganador en el conocido juego piedra-papel-tijera
%%   (piedra gana a papel, tijera gana a papel y piedra gana a tijera).
%% Por ej.,
%% > examen:juego(papel,tijera)
%% El ganador es: tijera
%%
%% > examen:juego(papel,papel)
%% Empate
%%
%% > examen:juego(papel,mano)
%% Error
juego(X, X) -> empate;

juego(X, Y) ->
  case is_valid_element(X) andalso is_valid_element(Y) of
    true -> winner(X,Y);
    false -> error
  end.

is_valid_element(X) ->
  case X of
    piedra -> true;
    papel -> true;
    tijera -> true;
    _ -> false
  end.

%% Piedra vs Tijera -> Piedra
winner(X, Y) when X =:= piedra andalso Y =:= tijera; Y =:= piedra andalso X =:= tijera -> piedra;
%% Piedra vs Papel -> Papel
winner(X, Y) when X =:= piedra andalso Y =:= papel; Y =:= piedra andalso X =:= papel -> papel;
%% Papel vs Tijera -> Tijera
winner(X, Y) when X =:= tijera andalso Y =:= papel; Y =:= tijera andalso X =:= papel -> tijera.

%% 2) Escribe una función rel/3 que tome un operador relacional (mayor, menor, igual) y dos valores numéricos y devuelva el resultado correspondiente. Por ej.,
%%
%% > examen:rel(mayor,4,1)
%% true
%%
%% > examen:rel(menor,4,1)
%% false
%%
rel(mayor,X,Y) -> X>Y;
rel(menor,X,Y) -> X<Y;
rel(igual,X,Y) -> X==Y.

%% 3) Escribe una función incremento/1 que tome un valor y haga lo siguiente: si es un entero o un real,
%%    le suma 1; si es un átomo, lo convierte en string y le añade "1" al final; si es una lista,
%%    devuelve el primer elemento; si es una tupla, devuelve el primer elemento;
%%    en cualquier otro caso, devuelve error.
%% Por ej.,
%%
%% > examen:incremento(3).
%% 4
%%
%% > examen:incremento(4.2).
%% 5.2
%%
%% > examen:incremento(hola).
%% "hola1"
%%
%% > examen:incremento([1,2,3]).
%% 1
%%
%% > examen:incremento({1,2}).
%% 1
%%
%% > examen:incremento(self()).
%% error
%%
%% PISTA: Puedes usar las siguientes funciones:
%%
%%     is_integer/1, is_float/1, is_atom/1 is_list/1, is_tuple/1 (en las guardas) y
%%     atom_to_list/1 (en el cuerpo).

incremento(X) when is_integer(X) orelse is_float(X) -> X + 1;
incremento(X) when is_atom(X) -> atom_to_list(X) ++ "1";

%% Implemented this way to treat the case of an empty list.
incremento([]) -> [];
incremento(X) when is_list(X) -> hd(X);

%% Treat the case of an empty tuple.
incremento({}) -> {};
incremento(X) when is_tuple(X) -> element(1, X);

%% Catch any other case.
incremento(_) -> error.

%% Tarea 3. Recursividad
%% 1) Escribid una función sumpar/1 que, dada una lista L, calcule la suma de todos los
%%    números enteros pares que aparezcan en L. Debéis hacerlo tanto con recursión normal
%%    (sumpar/1) como con recursión de cola (sumpar_tr/1).
%% Por ej.,
%% > examen:sumpar([2,8,[2,4],{1,6},3,1,0,5]).
%% 10
%%
%% > examen:sumpar([1,3,a,"hola",[2]]).
%% 0
%%
%% Pista: puedes usar N rem 2 == 0 para saber si N es par.

%% Normal.
sumpar([]) -> 0;
sumpar([N | T]) when N rem 2 == 0 -> sumpar(T) + N;
sumpar([_ | T]) -> sumpar(T).

%% Tail recursive.
sumpar_tr(List) -> sumpar_tr(List, 0).

sumpar_tr([], Sum) -> Sum;
sumpar_tr([N | T], Sum) when N rem 2 == 0 -> sumpar_tr(T, Sum + N);
sumpar_tr([_ | T], Sum) -> sumpar_tr(T, Sum).

%% 2) Escribid una función joinmax/2 que, dadas dos listas de enteros, las recorra en paralelo
%%    y devuelva una lista con los valores máximos de cada posición. Si una lista tiene más
%%    elementos que la otra, los elementos sobrantes se devolverán sin más. Se debe mantener
%%    el orden de los elementos en las listas originales. Debéis hacerlo tanto con recursión normal
%%    (joinmax/2) como con recursión de cola (joinmax_tr/2).
%%
%% Por ej.,
%%
%% > examen:joinmax([8,42,3],[1,2,6]).
%% [8,42,6]
%%
%% > examen:joinmax([8,42,3,1,2],[1,2,6]).
%% [8,42,6,1,2]
%%
%% Pista: puedes usar lists:reverse/1 para invertir los elementos de una lista.

%% Normal recursion.
joinmax([], []) -> [];
joinmax(XS, []) -> XS;
joinmax([], YS) -> YS;
joinmax([X|XS], [Y|YS]) -> [max(X, Y)] ++ joinmax(XS, YS).

%% Tail recursive.
joinmax_tr(XS, YS) -> joinmax_tr(XS, YS, []).

joinmax_tr([], [], Result) -> lists:reverse(Result);
joinmax_tr(XS, [], Result) -> lists:reverse(Result) ++ XS;
joinmax_tr([], YS, Result) -> lists:reverse(Result) ++ YS;
joinmax_tr([X | XS], [Y | YS], Result) -> joinmax_tr(XS, YS, [max(X,Y) | Result]).

%% 3) Escribe una función flip/1 que tome una lista de tuplas y devuelva una lista con los mismos
%%    elementos pero inviertiendo el orden de los elementos de las tuplas.
%%    Si un elemento no es una tupla, lo dejáis tal cual. Debéis hacerlo tanto con recursión normal
%%    (flip/1) como con recursión de cola (flip_tr/1).
%%
%% Por ej.,
%%
%% > examen_1:flip([{1,2,3},"hola",{},pepe,{a,b},{[],[1,2,3]}]).
%% [{3,2,1},"hola",{},pepe,{b,a},{[1,2,3],[]}]
%%
%% Pista: puedes usar tuple_to_list/1 para convertir las tuplas en listas y list_to_tuple/1 para lo contrario.

%% Normal recursion.
flip([]) -> [];

flip([X | XS]) when is_tuple(X) ->
  ReversedTuple = list_to_tuple(lists:reverse(tuple_to_list(X))),
  [ReversedTuple | flip(XS)];

flip([X | XS]) -> [X | flip(XS)].

%% Tail recursive.
flip_tr(List) -> flip_tr(List, []).

flip_tr([], Result) -> lists:reverse(Result);

flip_tr([X | XS], Result) when is_tuple(X) ->
  ReversedTuple = list_to_tuple(lists:reverse(tuple_to_list(X))),
  flip_tr(XS, [ReversedTuple | Result]);

flip_tr([X | XS], Result) -> flip_tr(XS, [X | Result]).


%% Tarea 4. Higher-order.
%%
%% Implementad las funciones de los siguientes ejercicios con la ayuda de
%%
%%     lists:map/3
%%     lists:foldl/3,
%%     lists:foldr/3
%%     lists:filter/2,
%%     ...
%%
%% Usad funciones anónimas siempre que sea posible.
%%
%% 1) Escribe una función noneg/1 que, dada una lista de enteros, reemplace todos los valores
%%    negativos por cero. Emplea una función anónima como argumento de map.
%%
%% Por ej.,
%% > examen:noneg([1,2,3]).
%% [1,2,3]
%%
%% > examen_1:noneg([1,-2,3,42,-8,5]).
%% [1,0,3,42,0,5]
noneg(List) -> lists:map(
  fun (Val) ->
    case Val >= 0 of
      true -> Val;
      false -> 0
    end
  end,
  List).

%% 2) Escribe una función minmax/1 que tome una lista de enteros y devuelva una tupla con el mínimo
%%    y el máximo de la lista. Puedes usar foldl o foldr. Como acumulador, te recomiendo {100,-100}.
%%
%% Por ej.,
%% > examen_1:minmax([1,8,-3,42,-10]).
%% {-10,42}

minmax(List) -> lists:foldl(
  fun(Val, {Min, Max}) ->
    {min(Val, Min), max(Val, Max)}
  end,
  {100, -100},
  List).

%% 3) Escribe una función sumlist/1 que tome una lista de listas y devuelva una lista de enteros
%%    que se obtienen reemplazando las listas originales por la suma de sus elementos de
%%    tipo entero. Debes usar foldl para recorrer la lista e ir reemplazando cada lista por
%%    la suma de sus enteros; puedes usar filter para quedarte con los elementos enteros
%%    (is_integer/1) de cada una de las listas, y lists:sum/1 para sumar los elementos de una lista
%%    de enteros.
%%
%%  Por ej.,
%%  > examen_1:sumlist([[40,1,1],[],[2,a,b,4],[5]]).
%%  [42,0,6,5]

sumlist(List) ->
  FoldedResult = lists:foldl(
    fun (InnerList, ResultList) ->
      FilteredList = lists:filter(fun erlang:is_integer/1, InnerList),
      Sum = lists:sum(FilteredList),
      [Sum | ResultList]
    end,
    [],
    List),

  lists:reverse(FoldedResult).