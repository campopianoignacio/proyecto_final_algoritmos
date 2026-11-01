unit manejo_menu;

interface

const
  CANT_OP = 6;

  // Constantes de dimensiones de pantalla (120x25)
  SCREEN_WIDTH = 120;
  SCREEN_HEIGHT = 25;

type
  T_Menu_Op = 1..CANT_OP;
  T_Menu = array [T_Menu_Op] of string;

procedure InicializarMenu(var opciones: T_Menu);

// Versión automática: Centra el menú basándose en el título y la opción más larga
function SeleccionarOpcionMenuInteractivoFullscreen(titulo: string; var opciones: T_Menu; maxOp: T_Menu_Op): T_Menu_Op;

// Versión con coordenadas exactas
function SeleccionarOpcionMenuInteractivoEnCoordenadas(titulo: string; var opciones: T_Menu; maxOp: T_Menu_Op; startX, startY: integer): T_Menu_Op;

implementation

uses
  crt;

procedure InicializarMenu(var opciones: T_Menu);
var
  i: T_Menu_Op;
begin
  for i := 1 to CANT_OP do
    opciones[i] := '';
end;

procedure EscribirOpcion(startX, startY: integer; posicion: T_Menu_Op; texto: string; resaltar: boolean);
var
  indicador: Char;
begin
  GotoXY(startX, startY + posicion);
  if not resaltar then
  begin
    TextColor(Green);
    indicador := '-';
  end
  else
  begin
    TextColor(Yellow);
    indicador := '>';
  end;
  Write(indicador, ' ', texto);
end;

// Implementación de la versión Fullscreen (Calcula el centro dinámicamente)
function SeleccionarOpcionMenuInteractivoFullscreen(titulo: string; var opciones: T_Menu; maxOp: T_Menu_Op): T_Menu_Op;
var
  i: T_Menu_Op;
  longitudMax, anchoBloque, startX, startY: integer;
begin
  // 0. Limpiar pantalla
  ClrScr;

  // 1. Encontrar la longitud máxima entre el título y todas las opciones activas
  longitudMax := Length(titulo);
  for i := 1 to maxOp do
  begin
    // Sumamos 2 por el indicador ('> ' o '- ') que se imprime al lado del texto
    if (Length(opciones[i]) + 2) > longitudMax then
      longitudMax := Length(opciones[i]) + 2;
  end;

  // 2. Calcular el ancho total del bloque del menú
  anchoBloque := longitudMax;

  // 3. Calcular la coordenada X para que quede perfectamente CENTRADO horizontalmente
  startX := (SCREEN_WIDTH - anchoBloque) div 2;

  // Si por alguna razón el texto es muy largo y sale de la pantalla, lo anclamos al borde izquierdo mínimo (1)
  if startX < 1 then
    startX := 1;

  // 4. Calcular la coordenada Y para centrarlo verticalmente
  // (El bloque ocupa: 1 línea de título + 'maxOp' líneas de opciones)
  startY := (SCREEN_HEIGHT - (1 + maxOp)) div 2;
  if startY < 1 then
    startY := 1;

  // 5. Llamar a la versión por coordenadas con los valores calculados
  SeleccionarOpcionMenuInteractivoFullscreen := SeleccionarOpcionMenuInteractivoEnCoordenadas(titulo, opciones, maxOp, startX, startY);
end;

// Implementación de la versión con Coordenadas (idéntica a la anterior)
function SeleccionarOpcionMenuInteractivoEnCoordenadas(titulo: string; var opciones: T_Menu; maxOp: T_Menu_Op; startX, startY: integer): T_Menu_Op;
var
  i, seleccion: T_Menu_Op;
  tecla: Char;
begin
  GotoXY(startX, startY);
  TextColor(LightCyan);
  Write(titulo);

  seleccion := 1;
  for i := 1 to maxOp do
    EscribirOpcion(startX, startY, i, opciones[i], false);

  EscribirOpcion(startX, startY, seleccion, opciones[seleccion], true);

  repeat
    tecla := ReadKey;
    if tecla = #0 then
    begin
      tecla := ReadKey;
      case tecla of
        #72: // Flecha Arriba
        begin
          EscribirOpcion(startX, startY, seleccion, opciones[seleccion], false);
          if seleccion = 1 then
            seleccion := maxOp
          else
            seleccion := seleccion - 1;
          EscribirOpcion(startX, startY, seleccion, opciones[seleccion], true);
        end;
        #80: // Flecha Abajo
        begin
          EscribirOpcion(startX, startY, seleccion, opciones[seleccion], false);
          if seleccion = maxOp then
            seleccion := 1
          else
            seleccion := seleccion + 1;
          EscribirOpcion(startX, startY, seleccion, opciones[seleccion], true);
        end;
      end;
    end;
  until tecla = #13; // Enter

  TextColor(White);
  SeleccionarOpcionMenuInteractivoEnCoordenadas := seleccion;
end;

end.
