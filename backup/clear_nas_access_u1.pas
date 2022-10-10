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
 //ShellExecute(0, nil, 'putty.exe', nil, '.', SW_SHOWNORMAL);
  ExecuteFile:='putty.exe';

 FillChar(SEInfo, SizeOf(SEInfo), 0) ;
 //SEInfo.cbSize := SizeOf(LPShellExecuteInfo) ;
 with ^SEInfo do begin
 fMask := SEE_MASK_NOCLOSEPROCESS;
 Wnd := Application.Handle;
 lpFile := PChar(ExecuteFile) ;
{
ParamString can contain the
application parameters.
}
// lpParameters := PChar(ParamString) ;
{
StartInString specifies the
name of the working directory.
If ommited, the current directory is used.
}
// lpDirectory := PChar(StartInString) ;
 nShow := SW_SHOWNORMAL;
 end;
 if ShellExecuteEx(SEInfo) then begin
 repeat
 Application.ProcessMessages;
 GetExitCodeProcess(SEInfo.hProcess, ExitCode) ;
 until (ExitCode <> STILL_ACTIVE) or
 Application.Terminated;
 ShowMessage('Calculator terminated') ;
 end
 else ShowMessage('Error starting Calc!') ;
end;

end.

