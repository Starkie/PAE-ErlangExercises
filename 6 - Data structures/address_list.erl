-module(address_list).
-export([new/0, insert/3, insert_list/2, delete/2, get_name/2, get_phone/2,
        get_email/2, get_address/2, set_name/3, set_phone/3, set_address/3,
        set_email/3, duplicate_names/1, bd_test/0]).

-record(contact, {name, phone, email, address}).

%% Escribid un módulo que implemente una base de datos de personas utilizando para ellos una
%% estructura clave-valor (un dict).
%% La clave de cada persona en la BD será su DNI, y el valor será un record con los siguientes campos:
%%     name
%%     phone
%%     email
%%     address
%% Las funciones a implementar son las siguientes:

%% 1) new(): Creación de una nueva BD vacía (un diccionario).
new() -> dict:new().

%% 2) insert(DNI, Person, BD): Inserción (o modificación, si existe) de una nueva persona en la BD.
insert(DNI, Person, Dict) -> dict:store(DNI, Person, Dict).

%% 3) insert_list(List = [{K1,V1},...],BD): Inserción de una lista de personas.
%% Pista: podéis usar foldl.
%% Example Input:
%%    [{"123454S", #contact{name= "Juan", phone = "123456778", email="asdsadasd@asda.com", address="Calle Falsa 1234"}},
%%     {"245124M", #contact{name= "Pepito", phone = "313521512", email= "pepito@home.com", address="Calle Malta 123"}}].
insert_list(List, Dict) -> lists:foldl(fun({DNI, Person}, DictIn) -> insert(DNI, Person, DictIn) end, Dict, List).

%% 4) delete(DNI, BD): Borrar una persona de la BD.
delete(DNI, Dict) -> dict:erase(DNI, Dict).

%% 5) Funciones para acceder al valor de los diferentes campos de una persona determinada:
%%    get_name(DNI,BD), get_phone(DNI,BD), get_email(DNI,BD) y get_address(DNI,BD).
%%
%% Nota: podéis usar dict:find/2 para localizar la información. Esta función devuelve error
%%        cuando la clave no existe. En ese caso, podéis devolver undefined.
get_name(DNI, Dict) ->
    case dict:find(DNI, Dict) of
        {ok, Contact} -> Contact#contact.name;
        error -> undefined
    end.

get_phone(DNI, Dict) ->
    case dict:find(DNI, Dict) of
        {ok, Contact} -> Contact#contact.phone;
        error -> undefined
    end.

get_email(DNI, Dict) ->
    case dict:find(DNI, Dict) of
        {ok, Contact} -> Contact#contact.email;
        error -> undefined
    end.

get_address(DNI, Dict) ->
    case dict:find(DNI, Dict) of
        {ok, Contact} -> Contact#contact.address;
        error -> undefined
    end.

%%
%% 6) Funciones para actualizar al valor de los diferentes campos de una persona determinada: set_name(DNI,Name,BD), set_phone(DNI,Phone,BD), set_email(DNI,Email,BD) y set_address(DNI,Address,BD).
%% Nota: podéis usar primero la función booleana dict:is_key/2 para comprobar si la clave existe (si no existe, devolvemos la BD tal cual). Si existe, podéis entonces actualizar su valor con dict:update/3 (ojo que el segundo argumento es una función, no un valor).
set_name(DNI, Name, Dict) ->
    case dict:is_key(DNI, Dict) of
      true -> dict:update(DNI, fun (Value) -> Value#contact{name=Name} end, Dict);
      false -> Dict
    end.

set_phone(DNI, Phone, Dict) ->
  case dict:is_key(DNI, Dict) of
    true -> dict:update(DNI, fun (Value) -> Value#contact{phone = Phone} end, Dict);
    false -> Dict
  end.

set_email(DNI, Email, Dict) ->
  case dict:is_key(DNI, Dict) of
    true -> dict:update(DNI, fun (Value) -> Value#contact{email = Email} end, Dict);
    false -> Dict
  end.

set_address(DNI, Address, Dict) ->
  case dict:is_key(DNI, Dict) of
    true -> dict:update(DNI, fun (Value) -> Value#contact{address = Address} end, Dict);
    false -> Dict
  end.

%% 7) Escribid una función que tome una BD y calcule los nombres repetidos. Por ejemplo, para
%%    la BD del ejemplo de bajo, tendríamos este resultado:
%%    > BD = tarea6:bd_test().
%%    > tarea6: name_warnings(BD).
%%
%%    Nombres repetidos: ["Estefania Perez"]

%% Para implementar esta función, puedes usar dict:fold/3. Como "acumulador", os sugiero una
%% tupla con dos listas, {TotalNombres,Repetidos} inicializada a {[],[]}. Para cada nuevo elemento,
%% comprobamos si aparece en la lista (usando lists:member/2): si es así, lo añadimos a las dos listas;
%% si no, solo a la primera.

%%Para imprimir el resultado, puedes usar donde R es la lista con los nombres repetidos.
%%io:format("Nombres repetidos: ~p~n",[R])

duplicate_names(Dict) ->
  {_, Repetidos} = dict:fold(
    fun get_duplicates/3,
    {[], []},
    Dict),
  io:format("Nombres repetidos: ~p~n",[lists:reverse(Repetidos)]).

%% Aux function to check if a contact name is duplicated.
get_duplicates(_, Value, {VisitedNames, Repeated}) ->
  ContactName = Value#contact.name,
  case lists:member(ContactName, VisitedNames) of
    true -> {VisitedNames, [ContactName | Repeated]};
    false -> {[ContactName | VisitedNames], Repeated}
  end.

bd_test() ->
  P1 =
    {
      15678923,
      #contact
      {
        name= "Ramon Garcia",
        phone = 691234123,
        email = "rgar@gmail.com",
        address = "Calle Genova 13, Madrid"
      }
    },
  P2 =
    {
      25678923,
      #contact
      {
        name= "Estefania Perez",
        phone = 691234124,
        email = "rgar@gmail.com",
        address = "Calle Genova 23, Madrid"
      }
    },
  P3 =
    {
      35678923,
      #contact
      {
        name= "Estefania Perez",
        phone = 691234123,
        email = "eper@gmail.com",
        address = "Calle Genova 13, Madrid"
      }
    },
  P4 =
    {
      35678923,
      #contact
      {
        name= "Estefania Perez",
        phone = 691234123,
        email = "eper@gmail.com",
        address = "Calle Genova 13, Madrid"
      }
    },
  insert_list([P1, P2, P3, P4], new()).