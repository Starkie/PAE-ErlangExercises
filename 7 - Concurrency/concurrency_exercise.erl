-module(concurrency_exercise).
-export([start/0, add_phone/3, get_phone/2, del_phone/2, terminate/1]).

%% Escribid un módulo que implemente una pequeña agenda telefónica. La agenda se basa en una estructura
%% clave-valor (un dict). La agenda tendrá elementos de la forma: {Name, [phone1, phone2, ...]
%%
%% Hay que implementar las siguientes funciones:
%%
%% 1) start/0: crea un nuevo proceso (con spawn_link) que ejecute la función agenda/1 con
%%    un diccionario vacío como argumento. Este proceso actuará como un servidor encargado
%%    de gestionar las peticiones sobre la agenda.
start() -> spawn_link(fun() -> agenda(dict:new()) end).

%% 2) add_phone(PidAgenda,Name,Phone): manda un mensaje de la forma {From, {add, Name, Phone}}
%%    al servidor PidAgenda, donde From es el pid del cliente.
add_phone(PidAgenda, Name, Phone) ->
  PidAgenda ! {self(), {add, Name, Phone}},
  receive
    {PidAgenda, Msg} -> Msg
  after 3000 ->
    timeout
  end.
%% 3) del_phone (PidAgenda,Name): manda un mensaje de la forma {From, {del, Name}} al
%%    servidor PidAgenda, donde From es el pid del cliente.
del_phone(PidAgenda, Name) ->
  PidAgenda ! {self(), {del, Name}},
  receive
    {PidAgenda, Msg} -> Msg
  after 3000 ->
    timeout
  end.

%% 4) get_phone(PidAgenda,Name): manda un mensaje de la forma {From, {get,Name}} al servidor
%%    PidAgenda, donde From es el pid del cliente.
get_phone(PidAgenda, Name) ->
  PidAgenda ! {self(), {get, Name}},
  receive
    {PidAgenda, Msg} -> Msg
  after 3000 ->
    timeout
  end.

%% 5) terminate(PidAgenda): manda un mensaje de la forma {From, terminate} al servidor PidAgenda.
%% En las cuatro funciones anteriores, los mensajes serán síncronos. Es decir, que una vez enviado el mensaje, las funciones deberán esperar una respuesta (y devolverla como resultado).
terminate(PidAgenda) ->
  PidAgenda ! {self(), terminate},
  receive
    {PidAgenda, Msg} -> Msg
  after 3000 ->
    timeout
  end.

%% 6) Por último, será necesario implementar la función agenda/1 que toma como argumento el estado actual de la agenda y cuyo cuerpo será un "receive" que maneja las diferentes peticiones:
%% - {From, {add, Name, Phone}}: usaremos dict:append/3 para añadir el nuevo teléfono a la agenda. Como respuesta, mandaremos el átomo added.
%% - {From, {del, Name}}: realiza el borrado de los teléfonos de Name (dict:erase/2) y responde con el átomo erased.
%% - {From, {get, Name}}: si existe una entrada para Name, devuelve la lista con sus teléfonos. En otro caso, responde con el átomo not_found. Puedes usar dict:find/2.
%% - {From, terminate}: simplemente responde con el átomo bye.
agenda(Dict) ->
  receive
    %% Append a new phone to the list.
    {From, {add, Name, Phone}} ->
      NewDict = dict:append(Name, Phone, Dict),
      From ! {self(), added},
      agenda(NewDict);

    %% Get the phone from the list.
    {From, {get, Name}} ->
      case dict:find(Name, Dict) of
        {ok, Value} -> From ! {self(), Value} ;
        error -> From ! {self(), not_found}
      end,
      agenda(Dict);

    %% Delete phone from the agenda.
    {From, {del, Name}} ->
      NewDict = dict:erase(Name, Dict),
      From ! {self(), erased},
      agenda(NewDict);

    %% Terminate the execution.
    {From, terminate} ->
      From ! {self(), bye}
  end.

%% Aquí tenéis como sería sesión típica:
%%
%% 1> A = tarea7:start().
%% <0.87.0>
%%
%% 2> tarea7:add_phone(A,pepe,123456).
%% added
%%
%% 3> tarea7:add_phone(A,pepe,765431).
%% added
%%
%% 4> tarea7:add_phone(A,rose,222222).
%% added
%%
%% 5> tarea7:get_phone(A,pepe).
%% pepe's phones: [123456,765431]
%% ok
%%
%% 6> tarea7:get_phone(A,rose).
%% rose's phones: [222222]
%% ok
%%
%% 7> tarea7:del_phone(A,rose).
%% erased
%%
%% 8> tarea7:get_phone(A,rose).
%% rose's phones: not_found
%% ok
%%
%% 9> tarea7:terminate(A).
%% bye
%%