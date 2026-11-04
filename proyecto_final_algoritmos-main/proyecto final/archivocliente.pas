unit ArchivoCliente;
interface
uses Tipos;
type TCliente = record
  dni: TDni;
  nombreCompleto: string[75];
  direccion: string[150];
  fechaNac: TFecha;
  celular: Cardinal;
  email: string[150];
  activo: boolean;
  end;
  TArchivoCliente = file of TCliente;

procedure AbrirOCrearArchivoCliente(var Arch: TArchivoCliente; Ruta: string);
function TamanioArchivoCliente(var Arch: TArchivoCliente): Integer;
procedure CerrarArchivoCliente(var Arch: TArchivoCliente);
procedure LeerArchivoCliente(var Arch: TArchivoCliente; Pos: Integer; var Value: TCliente);
procedure EscribirArchivoCliente(var Arch: TArchivoCliente; Pos: Integer; var Value: TCliente);

implementation
uses SysUtils;
{ Abre el archivo si ya existe, o lo crea en caso contrario }
procedure AbrirOCrearArchivoCliente(var Arch: TArchivoCliente; Ruta: string);
begin
  Assign(Arch, Ruta);

  if FileExists(Ruta) then
    Reset(Arch)
  else
    Rewrite(Arch);
end;

{ Cantidad de registros físicos en el archivo }
function TamanioArchivoCliente(var Arch: TArchivoCliente): Integer;
begin
  TamanioArchivoCliente := FileSize(Arch);
end;

{ Cierra el archivo físico en disco }
procedure CerrarArchivoCliente(var Arch: TArchivoCliente);
begin
  Close(Arch);
end;

procedure LeerArchivoCliente(var Arch: TArchivoCLiente; Pos: Integer; var Value: TCliente);
begin
  Seek(Arch, Pos);
  Read(Arch, Value);
end;

procedure EscribirArchivoCliente(var Arch: TArchivoCliente; Pos: Integer; var Value: TCliente);
begin
  Seek(Arch, Pos);
  Write(Arch, Value);
end;

end.

