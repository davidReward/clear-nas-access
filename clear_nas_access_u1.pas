unit clear_nas_access_u1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    function PlinkStarten : Integer;
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

uses
  Windows,ShellApi;

procedure TForm1.Button1Click(Sender: TObject);
begin
  PlinkStarten;
end;

function TForm1.PlinkStarten: Integer;
var
 SEInfo: LPShellExecuteInfo;
 ExitCode: DWORD;
 ExecuteFile, ParamString, StartInString: string;
begin
 ShellExecute(0, nil, 'putty.exe', nil, '.', SW_SHOWNORMAL);
end;

end.

