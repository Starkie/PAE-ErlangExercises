%""" Dadas las variables
X = lists:seq(1,10).
Y = lists:seq(-5,5, 1).

%% Escribe listas intensionales para calcular los siguientes casos:
%% 1) Una lista con los números pares (puedes usar rem) mayores que 5 que hay en X.
PairNumbersGreaterThan5 = [N || N <- X, N rem 2 =:= 0, N > 5].

%% 2) Una lista con los números de X cuyo cuadrado vale lo mismo que el propio número (por ejemplo, 1).
NumberEqualToPower2 = [N || N <- X, N*N =:= N].

%% 3) Una lista con todas las posibles multiplicaciones de los elementos de X e Y, siempre que el resultado
%%    de la multiplicación sea mayor que 30 o menor que -30. Los elementos de la lista
%%    serán tuplas de la forma {NUMERO_DE_X, NUMERO_DE_Y, MULTIPLICACIÓN}

MultiplicationList = [{X1, Y1, X1 * Y1} || X1 <- X, Y1 <- Y, X1*Y1 < -30 orelse X1*Y1 > 30].

%% 4) Utilizar los elementos de X para generar esta lista (pista: podés usar list:seq/2):
%% [[1],
%%  [1,2],
%%  [1,2,3],
%%  [1,2,3,4],
%%  [1,2,3,4,5],
%%  [1,2,3,4,5,6],
%%  [1,2,3,4,5,6,7],
%%  [1,2,3,4,5,6,7,8],
%%  [1,2,3,4,5,6,7,8,9],
%%  [1,2,3,4,5,6,7,8,9,10]]

ListOfLists = [lists:seq(hd(X), X1) || X1 <- X].

%% 5) Como el anterior, pero solo con números pares:
%% [[],
%%  [2],
%%  [2],
%%  [2,4],
%%  [2,4],
%%  [2,4,6],
%%  [2,4,6],
%%  [2,4,6,8],
%%  [2,4,6,8],
%%  [2,4,6,8,10]]
ListOfListsPair = [[M || M <- lists:seq(1, N), M rem 2 =:= 0] || N <-X].