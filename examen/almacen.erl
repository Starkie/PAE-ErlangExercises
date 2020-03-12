-module(almacen).
-export([inicio/0, add_item/2, stock_item/2, remove_item/2, terminate/1]).

%% Tarea 7. Concurrencia
%%
%% Escribid un módulo que implemente un pequeño almacén de productos.
%%
%% Hay que implementar las siguientes funciones:
%%
%% 1) inicio/0: crea un nuevo proceso (con spawn_link) que ejecute la función almacen/1 con una lista
%%    vacía como argumento. Este proceso actuará como un servidor encargado de gestionar las
%%    peticiones sobre el almacén.
inicio() -> spawn_link(fun () -> almacen([]) end).

%%
%% 2) add_item(Almacen,Item): manda un mensaje al servidor (Almacen) de la forma {add,Item}
%%    para que lo añada, donde From es el pid del cliente. No importa si ya existe
%%    (pueden haber repeticiones).
%%    No espera respuesta (asíncrono).

add_item(Almacen, Item) ->
  Almacen ! {self(), {add, Item}}.

%% 3) stock_item(Almacen,Item): manda una petición al servidor de la forma {From,{stock,Item}}
%%   para conocer el stock actual de Item. Puede ser cero (si no existe) o un número que se
%%   obtiene contando cuantas ocurrencias de dicho Item hay en el Almacen actualmente.

stock_item(Almacen,Item) ->
  Almacen ! {self(), {stock, Item}},
  receive
    {Almacen, Result} -> Result
  after 5000 ->
    timeout
  end.

%% 4) remove_item(Almacen,Item): manda una petición de la forma {From,{remove,Item}} para eliminar el
%%    elemento Item del Almacen. Devuelve ok si existe y not_found en caso contrario.
%% Nota: No elimina todas los productos Item del Almacen, solo el primero.

remove_item(Almacen,Item) ->
  Almacen ! {self(), {remove, Item}},
  receive
    {Almacen, Result} -> Result
  after 5000 ->
    timeout
  end.

%% 5) terminate(almacen): manda al servidor un mensaje de la forma {From, terminate}
%%    para que termine. Devuelve el número de elementos que había en este momento.
terminate(Almacen) ->
  Almacen ! {self(), terminate},
  receive
    {Almacen, Result} -> Result
  after 5000 ->
    timeout
  end.

%% Observa que todas las funciones anteriores son síncronas (esperan un mensaje de respuesta) excepto add_item/2.
%%
%% 6) Por último, será necesario implementar la función almacen/1 que toma como argumento una lista con los ítems actuales y cuyo cuerpo será un "receive" que maneja las diferentes peticiones.
%%
%% Pista: puedes usar lists:member/2 para saber si un elemento está en la lista, e implementar una función propia para contar el número de veces que aparece (erlang:length/1 nos devuelve la longitud de una lista). También puedes usar lists:delete/2 para eliminar un elemento de una lista.
%%
%% Aquí tenéis como sería sesión típica:
%%
%% > Almacen = examen:inicio().
%% <0.68.0>
%%
%% > examen:add_item(Almacen,papel).
%% {add,papel}
%%
%% > examen:add_item(Almacen,papel).
%% {add,papel}
%%
%% > examen:add_item(Almacen,piedra).
%% {add,piedra}
%%
%% > examen:stock_item(Almacen,papel).
%% 2
%%
%% > examen:stock_item(Almacen,piedra).
%% 1
%%
%% > examen:remove_item(Almacen,tijeras).
%% not_found
%%
%% > examen:remove_item(Almacen,papel).
%% ok
%%
%% > examen:stock_item(Almacen,papel).
%% 1
%%
%% > examen:terminate(Almacen).
%% 2
almacen(Stock) ->
  receive
    {_, {add, Item}} -> almacen([Item | Stock]);

    {From, {stock, Item}} ->
      Count = count_stock(Item, Stock),
      From ! {self(), Count},
      almacen(Stock);

    {From, {remove, Item}} ->
      {Result, UpdatedStock} = remove_stock(Item, Stock),
      From ! {self(), Result},
      almacen(UpdatedStock);

    {From, terminate} ->
      TotalStock = count_stock(Stock),
      From ! {self(), TotalStock}
  end.

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