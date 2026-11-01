unit Menu;
{$codepage UTF8}
interface
procedure MENU_PRINCIPAL();

implementation
uses
  crt, manejo_menu, GestionCliente, ArchivoCliente;

procedure MENU_PRINCIPAL();
var menu_pr: T_Menu;
    menu_op: T_Menu_Op;
    archivo_cliente: TArchivoCLiente;
begin
  InicializarMenu(menu_pr);
  menu_pr[1] := 'Gestión Clientes';
  menu_pr[2] := 'Gestión Pólizas';
  menu_pr[3] := 'Listados';
  menu_pr[4] := 'Estadisticas';
  menu_pr[5] := 'Salir';

  // Abrir y cerrar archivos en cada ciclo para asegurar
  // persistencia y actualización del buffer (al crear elementos)
  repeat
    AbrirOCrearArchivoCliente(archivo_cliente, 'clientes.dat');

    menu_op := SeleccionarOpcionMenuInteractivoFullscreen(
      'MENU PRINCIPAL',
      menu_pr,
      5
    );
    case menu_op of
      1: MENU_CLIENTE(archivo_cliente);
    end;

    CerrarArchivoCliente(archivo_cliente);
  until menu_op = 5;
end;

end.

