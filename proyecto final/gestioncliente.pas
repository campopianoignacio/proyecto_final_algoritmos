unit GestionCliente;
{$codepage UTF8}
interface

uses ArchivoCliente;

procedure MENU_CLIENTE(var Arch: TArchivoCliente);

implementation

uses crt, Validaciones, Tipos, manejo_menu;

procedure BuscarClientePorDni(var Arch: TArchivoCliente; dni: TDni; var pos: Integer);
var
  i: Integer;
  cliente: TCliente;
begin
   i := 0;
   pos := -1;
   while (not EoF(Arch)) and (pos = -1) do
   begin
      LeerArchivoCliente(Arch, i, cliente);
      if cliente.dni = dni then
         pos := i;
      Inc(i);
   end;
end;

procedure CrearCliente(var Arch: TArchivoCliente; dni: TDni);
var
  nuevoCliente: TCliente;
begin
  ClrScr;
  TextColor(LightCyan);
  Writeln('=== ALTA DE NUEVO CLIENTE ===');
  TextColor(White);
  Writeln('DNI registrado: ', dni);
  Writeln('-----------------------------------');

  // 1. Asignar el DNI que ya se verificó que no existe
  nuevoCliente.dni := dni;

  // 2. Cargar el resto de los campos
  nuevoCliente.nombreCompleto:= cargarnombre();

  nuevoCliente.direccion:= cargardireccion();

  nuevoCliente.fechaNac := cargarFecha();

  nuevoCliente.celular:= cargarTelefono();

  nuevoCliente.email:= cargarmail();

  // Por defecto, un cliente nuevo nace activo
  nuevoCliente.activo := true;

  // 3. Persistirlo
  EscribirArchivoCliente(Arch, TamanioArchivoCliente(Arch), nuevoCliente);

  // Mensaje de éxito
  ClrScr;
  TextColor(LightGreen);
  Writeln('¡Cliente creado exitosamente!');
  TextColor(White);
  Writeln('Presione cualquier tecla para continuar...');
  ReadKey;
end;

procedure ModificarCliente(var Arch: TArchivoCliente; pos: integer);
var
  menu: T_Menu;
  opcion: T_Menu_Op;
  cliente: TCliente;
  i: integer;
begin
  repeat
    // 1. Leer el estado más reciente del registro en el archivo
    LeerArchivoCliente(Arch, pos, cliente);

    ClrScr;

    // 2. Dibujar línea divisoria vertical al 50%
    TextColor(DarkGray);
    for i := 1 to SCREEN_HEIGHT do
    begin
      GotoXY(60, i);
      Write('|');
    end;

    // 3. Mostrar los datos actuales en el lado IZQUIERDO
    TextColor(LightCyan);
    GotoXY(3, 2);  Write('=== DATOS ACTUALES ===');

    TextColor(LightGray);
    GotoXY(3, 5);  Write('DNI (no modif.) : ', cliente.dni);
    GotoXY(3, 7);  Write('1. Nombre       : ', cliente.nombreCompleto);
    GotoXY(3, 9);  Write('2. Dirección    : ', cliente.direccion);
    GotoXY(3, 11); Write('3. Fecha Nac.   : ', cliente.fechaNac.dia, '/', cliente.fechaNac.mes, '/', cliente.fechaNac.anio);
    GotoXY(3, 13); Write('4. Celular      : ', cliente.celular);
    GotoXY(3, 15); Write('5. Email        : ', cliente.email);

    // 4. Armar las opciones del submenú en el lado DERECHO
    InicializarMenu(menu);
    menu[1] := 'Nombre Completo';
    menu[2] := 'Direccion';
    menu[3] := 'Fecha de Nacimiento';
    menu[4] := 'Telefono / Celular';
    menu[5] := 'Email';
    menu[6] := 'Volver';

    opcion := SeleccionarOpcionMenuInteractivoEnCoordenadas('=== MODIFICAR ===', menu, 6, 70, 5);

    // 5. Modificar exclusivamente el campo seleccionado
    case opcion of
      1:
      begin
        ClrScr;
        TextColor(LightCyan);
        Writeln('=== MODIFICAR NOMBRE ===');
        TextColor(White);
        Writeln('Nombre actual: ', cliente.nombreCompleto);
        Write('Nuevo nombre : ');
        cliente.nombreCompleto:=CargarNombre();
        EscribirArchivoCliente(Arch, pos, cliente);
      end;
      2:
      begin
        ClrScr;
        TextColor(LightCyan);
        Writeln('=== MODIFICAR DIRECCION ===');
        TextColor(White);
        Writeln('Dirección actual: ', cliente.direccion);
        Write('Nueva dirección : ');
        cliente.direccion:=CargarDireccion();
        EscribirArchivoCliente(Arch, pos, cliente);
      end;
      3:
      begin
        ClrScr;
        TextColor(LightCyan);
        Writeln('=== MODIFICAR FECHA DE NACIMIENTO ===');
        TextColor(White);
        cliente.fechaNac := cargarFecha();
        EscribirArchivoCliente(Arch, pos, cliente);
      end;
      4:
      begin
        ClrScr;
        TextColor(LightCyan);
        Writeln('=== MODIFICAR CELULAR ===');
        TextColor(White);
        Write('Nuevo celular : ');
        cliente.celular:=CargarTelefono;
        EscribirArchivoCliente(Arch, pos, cliente);
      end;
      5:
      begin
        ClrScr;
        TextColor(LightCyan);
        Writeln('=== MODIFICAR EMAIL ===');
        TextColor(White);
        Writeln('Email actual: ', cliente.email);
        cliente.email:= cargarMail();
        EscribirArchivoCliente(Arch, pos, cliente);
      end;
    end;

  until opcion = 6; // Opción 6: Volver
end;

procedure CambiarEstadoCliente(var Arch: TArchivoCliente; pos: integer; activar: boolean);
  // TODO: Implementar lógica de dar de baja o alta (cambiar campo 'activo')
var
  cliente: Tcliente;
begin
  LeerArchivoCliente(Arch, pos, cliente);
  cliente.activo := activar;
  EscribirArchivoCliente(Arch, pos, cliente);

  Clrscr;
  TextColor(LightGreen);
  if activar = true then
  begin
     writeln('Cliente dado de alta exitosamente!');
  end
  else
      writeln('Cliente dado de baja exitosamente!');
  TextColor(White);
  Writeln('Presione cualquier tecla para continuar...');
  readkey;
end;


procedure MENU_CLIENTE_CREACION(var Arch: TArchivoCliente; dni: TDni);
var
  menu: T_Menu;
  opcion: T_Menu_Op;
begin
  InicializarMenu(menu);
  menu[1] := 'Crear';
  menu[2] := 'Volver';

  opcion := SeleccionarOpcionMenuInteractivoFullscreen('Cliente inexistente, deseas crearlo?', menu, 2);

  case opcion of
    1: CrearCliente(Arch, dni);
    // Volver al menú anterior
  end;
end;

procedure MENU_CLIENTE_MODIFICACION(var Arch: TArchivoCliente; pos: integer);
var
  menu: T_Menu;
  opcion: T_Menu_Op;
  cliente: TCliente;
  i: integer;
  volver: boolean;
begin
  volver:= false;

  repeat
  ClrScr;
  // Pantalla 50% / 50% Menú para mostrar la información
  LeerArchivoCliente(Arch, pos, cliente);

  // 2. Dibujar línea divisoria vertical al 50%
  TextColor(DarkGray);
  for i := 1 to SCREEN_HEIGHT do
  begin
    GotoXY(60, i);
    Write('|');
  end;

  // 3. Mostrar datos del cliente en la mitad IZQUIERDA (Columnas 3 a 58)
  TextColor(LightCyan);
  GotoXY(3, 2);  Write('=== DATOS DEL CLIENTE ===');

  TextColor(LightGray);
  GotoXY(3, 5);  Write('DNI            : ', cliente.dni);
  GotoXY(3, 7);  Write('Nombre         : ', cliente.nombreCompleto);
  GotoXY(3, 9);  Write('Direccion      : ', cliente.direccion);
  GotoXY(3, 11); Write('Celular        : ', cliente.celular);
  GotoXY(3, 13); Write('Email          : ', cliente.email);

  GotoXY(3, 15);
  if cliente.activo then
  begin
    TextColor(LightGreen);
    Write('Estado         : ACTIVO');
  end
  else
  begin
    TextColor(LightRed);
    Write('Estado         : INACTIVO');
  end;

  // 4. Configurar el menú en mitad derecha según su estado
  InicializarMenu(menu);

  if cliente.activo then
  begin
    menu[1] := 'Modificar';
    menu[2] := 'Dar de baja';
    menu[3] := 'Volver';

    opcion := SeleccionarOpcionMenuInteractivoEnCoordenadas('=== GESTION DE CLIENTE ===', menu, 3, 70, 8);

    case opcion of
      1: ModificarCliente(Arch, pos);
      2: CambiarEstadoCliente(Arch, pos, false); // false = desactivar
      3: volver := true;
      // Volver al menú anterior
    end;
  end
  else
  begin
    menu[1] := 'Dar de alta';
    menu[2] := 'Volver';

    opcion := SeleccionarOpcionMenuInteractivoEnCoordenadas('=== GESTION DE CLIENTE ===', menu, 2, 70, 8);

    case opcion of
      1: CambiarEstadoCliente(Arch, pos, true); // true = activar
      2: volver:= true // Retorna true para salir de esta pantalla

      // Volver al menú anterior
    end;
  end;
  until volver= true;
end;

procedure MENU_CLIENTE(var Arch: TArchivoCliente);
var
  dni: TDni;
  pos: integer;
begin
  ClrScr;
  dni := cargarDni();
  BuscarClientePorDni(Arch, dni, pos);

  if pos = -1 then
    MENU_CLIENTE_CREACION(Arch, dni)
  else
    MENU_CLIENTE_MODIFICACION(Arch, pos);
end;

end.
