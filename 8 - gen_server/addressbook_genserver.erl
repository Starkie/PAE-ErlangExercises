-module(addressbook_genserver).
-behaviour(gen_server).

-export([start/0, add_phone/3, get_phone/2, del_phone/2, terminate/1]).
-export([init/1, handle_call/3, terminate/2]).

%% Escribid un módulo que implemente la agenda telefónica de la tarea 7,
%% pero ahora usando el "behavior" gen-server.

%% 1) start/0: crea un nuevo proceso (con spawn_link) que ejecute la función agenda/1 con
%%    un diccionario vacío como argumento. Este proceso actuará como un servidor encargado
%%    de gestionar las peticiones sobre la agenda.
start() -> gen_server:start(?MODULE, [], []).

%% 2) add_phone(PidAgenda,Name,Phone): manda un mensaje de la forma {From, {add, Name, Phone}}
%%    al servidor PidAgenda, donde From es el pid del cliente.
add_phone(PidAgenda, Name, Phone) ->
  gen_server:call(PidAgenda, {add, Name, Phone}).

%% 3) del_phone (PidAgenda,Name): manda un mensaje de la forma {From, {del, Name}} al
%%    servidor PidAgenda, donde From es el pid del cliente.
del_phone(PidAgenda, Name) ->
  gen_server:call(PidAgenda, {del, Name}).

%% 4) get_phone(PidAgenda,Name): manda un mensaje de la forma {From, {get,Name}} al servidor
%%    PidAgenda, donde From es el pid del cliente.
get_phone(PidAgenda, Name) ->
  gen_server:call(PidAgenda, {get, Name}).

%% 5) terminate(PidAgenda): manda un mensaje de la forma {From, terminate} al servidor PidAgenda.
%% En las cuatro funciones anteriores, los mensajes serán síncronos. Es decir, que una vez enviado el mensaje, las funciones deberán esperar una respuesta (y devolverla como resultado).
terminate(PidAgenda) ->
  gen_server:call(PidAgenda, {terminate}).

%% Callback functions
init([]) -> {ok,dict:new()}.

handle_call({add, Name, Phone}, _From, Agenda) ->
	NewAgenda = dict:append(Name,Phone,Agenda),
	{reply,added,NewAgenda};

handle_call({del, Name}, _From, Agenda) ->
  NewAgenda = dict:erase(Name, Agenda),
  {reply, deleted, NewAgenda};

handle_call({get, Name}, _From, Agenda) ->
  case dict:find(Name, Agenda) of
    {ok, Value} -> {reply, Value, Agenda};
    error -> {reply, not_found, Agenda}
  end;

handle_call({terminate}, _From, Agenda) ->
	{stop, normal, ok, Agenda}.

terminate(_,_State) ->
    bye.