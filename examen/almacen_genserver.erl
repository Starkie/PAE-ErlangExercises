-module(almacen_genserver).
-behaviour(gen_server).

%% Module functionality exports.
-export([inicio/0, add_item/2, stock_item/2, remove_item/2, terminate/1]).

%% gen_server exports.
-export([init/1, handle_cast/2, handle_call/3, terminate/2]).

%% Tarea 8. gen-server
%%
%% Escribid un módulo que implemente el almacén de la tarea anterior,
%% pero ahora usando el "behavior" gen-server.

%% 1) inicio/0: crea un nuevo proceso con una lista vacía como argumento.
inicio() -> gen_server:start(?MODULE, [], []).

%% 2) add_item(Almacen,Item): manda un mensaje al servidor (Almacen) de la forma {add,Item}
%%    para que lo añada, donde From es el pid del cliente. No importa si ya existe
%%    (pueden haber repeticiones).
%%    No espera respuesta (asíncrono).
add_item(Almacen, Item) ->
  gen_server:cast(Almacen, {add, Item}).

%% 3) stock_item(Almacen,Item): manda una petición al servidor de la forma {From,{stock,Item}}
%%   para conocer el stock actual de Item. Puede ser cero (si no existe) o un número que se
%%   obtiene contando cuantas ocurrencias de dicho Item hay en el Almacen actualmente.
stock_item(Almacen,Item) ->
  gen_server:call(Almacen, {stock, Item}).

%% 4) remove_item(Almacen,Item): manda una petición de la forma {From,{remove,Item}} para eliminar el
%%    elemento Item del Almacen. Devuelve ok si existe y not_found en caso contrario.
%% Nota: No elimina todas los productos Item del Almacen, solo el primero.
remove_item(Almacen,Item) ->
  gen_server:call(Almacen, {remove, Item}).

%% 5) terminate(almacen): manda al servidor un mensaje de la forma {From, terminate}
%%    para que termine. Devuelve el número de elementos que había en este momento.
terminate(Almacen) ->
  gen_server:call(Almacen, {terminate}).

%% Gen_Server callbacks.
init([]) -> {ok, []}.

%% Handles the add item operation, which
%% requires no response.
handle_cast({add, Item}, Stock) ->
  {noreply, [Item | Stock]}.

handle_call({stock, Item}, _, Stock) ->
  Count = count_stock(Item, Stock),
  {reply, Count, Stock};

handle_call({remove, Item}, _, Stock) ->
  {Result, UpdatedStock} = remove_stock(Item, Stock),
  {reply, Result, UpdatedStock};

handle_call({terminate}, _, Stock) ->
  {stop, normal, ok, Stock}.

%% Counts the current stock.
count_stock(Stock) -> lists:foldl(
  fun(_, Total) -> Total + 1 end, 0, Stock).

%% Counts the appeareance of the item in the stock.
count_stock(Item, Stock) -> lists:foldl(
  fun(Value, Appearances) ->
    case Value =:= Item of
      true -> Appearances + 1;
      false -> Appearances
    end
  end,
  0,
  Stock).

%% Removes the given item of the current stock.
remove_stock(Item, Stock) ->
  case lists:member(Item, Stock) of
    true -> {ok, lists:delete(Item, Stock)};
    false -> {not_found, Stock}
  end.

%% Called when the server is terminated.
terminate(Reason, Stock) ->
    io:format("Server stopped: ~p (Items in stock:~p)~n",[Reason, count_stock(Stock)]).