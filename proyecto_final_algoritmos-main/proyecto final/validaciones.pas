unit Validaciones;
{$codepage UTF8}

interface
uses
  Tipos, SysUtils, crt;

function cargarDni(): TDni;
function dniValido(dni: TDni): Boolean;
function cargarFecha(): TFecha;
function mailValido(mail: T_Mail): Boolean;
function cargarMail(): T_Mail;
function cargarTelefono(): Cardinal;
function ObtenerPosicionUltimoEspacio(cadena:string):Integer;
function direccionValida(dir: string): Boolean;
function cargarDireccion(): string;
function nombreValido(nombre: string): Boolean;
function cargarNombre(): string;

implementation

  function dniValido(dni: TDni): Boolean;
var i, cont:Integer;
begin
    dniValido:=false;
    cont:=0;
    If (length(dni)=7) or (length(dni)=8) then
      Begin
        For i:=1 to length(dni) do
          if dni[i] in ['1','2','3','4','5','6','7','8','9','0'] then
          cont:= cont+1;
      end;
   If length(dni)= cont then
      dniValido := true;
end;

function cargarDni(): TDni;
var dni: TDni;
begin
  repeat
    write('DNI del cliente: ');
    readLn(dni);
    if dniValido(dni) = false then
    begin
      dni := '';
      writeLn('DNI inválido: solo dígitos entre 7 y 8 de longitud');
    end;
  until dni <> '';
  cargarDni := dni;
end;

function diasDelMes(mes: integer; anio: integer): integer;
var
  dias: integer;
begin
  case mes of
    1, 3, 5, 7, 8, 10, 12: dias := 31;
    4, 6, 9, 11: dias := 30;
    2:
    begin
      if ((anio mod 4 = 0) and (anio mod 100 <> 0)) or (anio mod 400 = 0) then
        dias := 29
      else
        dias := 28;
    end;
  else
    dias := 31; // Valor de resguardo por si el mes ingresado es inválido
  end;
  diasDelMes := dias;
end;

function validar_string(aux: string; cantidadmin: integer; cantidadmax: integer):boolean;
var
  i, cont: integer;
begin
  cont:= 0;
  if (length(aux) <= cantidadmax) and (length(aux) >= cantidadmin) then
    for i:=1 to length(aux) do
    if aux[i] in ['1','2','3','4','5','6','7','8','9','0'] then
    cont:= cont + 1;
  if cont = length(aux) then
  validar_string:= true;
end;



function cargarFecha(): TFecha;
var
  f: TFecha;
  maxDias, auxMes, auxDia: integer;
  aux: string;
begin
  
  f.anio:= 0;
  f.mes:= 0;
  f.dia:= 0;
  auxMes := 0;
  auxDia:= 0;

  repeat
    writeln('--- Fecha de Nacimiento ---');
    write('Año: ');
    readln(aux);
    if Validar_String(aux,4,4) then
    f.anio:= strtoint(aux);

    if (f.anio < 1900) or (f.anio > 2026) then
    begin
      clrscr;
      writeln('Año inválido, ingréselo de nuevo.');
    end;
  until (f.anio >= 1900) and (f.anio <= 2026);

  repeat
    clrscr;
    writeln('--- Fecha de Nacimiento ---');
    writeln('Año: ', f.anio);
    write('Mes (1-12): ');
    readln(aux);
    if validar_String(aux,1, 2) then
      auxMes:= strtoint(aux);
    clrscr;
    if (auxMes < 1) or (auxMes > 12) then
      writeln('Mes inválido, ingréselo de nuevo.');
  until (auxMes >= 1) and (auxMes <= 12);

  f.mes:= auxMes;

  // Calculamos maxDias
  maxDias := diasDelMes(f.mes, f.anio);

  repeat
    writeln('--- Fecha de Nacimiento ---');
    writeln('Año: ', f.anio);
    writeln('Mes: ', f.mes);
    write('Día (1-', maxDias, '): ');
    readln(aux);
    if validar_string(aux,1,2) then
    auxDia:= strtoint(aux);

    clrscr;
    if (auxDia < 1) or (auxDia > maxDias) then
      writeln('Día inválido, ingréselo de nuevo.');
  until (auxDia >= 1) and (auxDia <= maxDias);

  f.dia:= auxDia;
  cargarFecha := f;
end;

function mailValido(mail: T_mail): Boolean;
var
  i, posArroba, posPunto, cantArrobas: Integer;
  esValido: Boolean;
begin
  esValido := true;
  cantArrobas := 0;
  posArroba := 0;
  posPunto := 0;

  if length(mail) < 10 then
    esValido := false
  else
  begin
    if (mail[1] in ['.', '@']) or (mail[length(mail)] in ['.', '@']) then
      esValido := false;

    if esValido then
    begin
      for i := 1 to length(mail) do
      begin
        if mail[i] = '@' then
        begin
          cantArrobas := cantArrobas + 1;
          posArroba := i;
        end;
      end;
      if cantArrobas <> 1 then
        esValido := false
      else
      begin
        for i := posArroba + 1 to length(mail) do
        begin
          if mail[i] = '.' then
            posPunto := i;
        end;
        If posPunto<PosArroba then
          esValido:=false;
    end;
  end;
  mailValido := esValido;
end;
end;

function cargarMail(): T_Mail;
var
  mail: T_Mail;
begin
  repeat
    writeLn('Ingrese correo electrónico: ');
    readLn(mail);
    if not mailValido(mail) then
      writeLn('Mail inválido. Ejemplo válido: usuario@dominio.com');
  until mailValido(mail);
  cargarMail := mail;
end;


function cargarTelefono() : Cardinal;
var
  telStr: string;
begin
  clrscr;
  repeat
    write('Teléfono/Celular del cliente: ');
    readLn(telStr);

    if not Validar_String(telStr,8,10) then
    begin
      clrscr;
      writeLn('Teléfono inválido: ingrese solo dígitos (entre 8 y 10 de longitud)');
    end;

  until validar_String(telStr,8,10);
  clrscr;
  cargarTelefono := StrToInt64(telStr);
end;

function obtenerPosicionUltimoEspacio(cadena: string): Integer;
var
  i: integer;
  posicion: integer;
begin
  posicion:=-1;
  for i:=1 to length(cadena) do
  begin
    if cadena[i]=' ' then
       posicion:=i
  end;
  obtenerPosicionUltimoEspacio := posicion;
end;

function direccionValida(dir: string): Boolean;
var
  i: integer;
  esValida: boolean;
begin
  esValida := true;

  if (length(dir) >= 5) and (length(dir) <= 150) and (dir[1] <> ' ') and (obtenerPosicionUltimoEspacio(dir) < length(dir)) then
  begin
    for i := 1 to (obtenerPosicionUltimoEspacio(dir) - 1) do
    begin
      if not (LowerCase(dir[i]) in ['a'..'z',' ']) then
        esValida := false;
    end;

    for i := (obtenerPosicionUltimoEspacio(dir) + 1) to length(dir) do
    begin
      if not (dir[i] in ['0'..'9']) then
        esValida := false;
    end;
  end
  else
    esValida := false;

  direccionValida := esValida;
end;

function cargarDireccion(): string;
var
  dir: string;
begin
  repeat
    write('Dirección del cliente: ');
    readLn(dir);

    if not direccionValida(dir) then
    begin
      dir := '';
      writeLn('Dirección inválida: ingrese el nombre de la calle (solo letras) seguido de la altura (solo números).');
    end;
  until dir <> '';
  cargarDireccion := dir;
end;

function nombreValido(nombre: string): Boolean;
var
  i, posEspacio: integer;
  esValido: boolean;
begin
  esValido := true;

  if (length(nombre) >= 3) and (length(nombre) <= 75) and (nombre[1] <> ' ') and (nombre[length(nombre)] <> ' ') and (obtenerPosicionUltimoEspacio(nombre)<>-1) then
  begin
    for i := 1 to length(nombre) do
    begin
      if not (LowerCase(nombre[i]) in ['a'..'z', ' ']) then
        esValido := false;
    end;

  end
  else
    esValido := false;

  nombreValido := esValido;
end;

function cargarNombre(): string;
var
  nom: string;
begin
  repeat
    write('Nombre completo del cliente: ');
    readLn(nom);

    if not nombreValido(nom) then
    begin
      nom := '';
      writeLn('Nombre inválido: ingrese nombre y apellido (solo letras) separados por espacio.');
    end;
  until nom <> '';

  cargarNombre := nom;
end;

end.



