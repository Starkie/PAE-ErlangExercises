-module(functions_exercise).
-export([ord/1]).

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