unit clear_nas_access_u1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Windows,
  ShellApi;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    SEInfo: TShellExecuteInfo;
    function PlinkStarten : Integer;
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
begin
  PlinkStarten;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  TerminateProcess(SEInfo.hProcess, 1);
end;

function TForm1.PlinkStarten: Integer;
var
  ExitCode: DWORD;
  ExecuteFile, ParamString, StartInString: string;
begin
  //ShellExecute(Handle, nil, 'putty.exe', nil, '.', SW_SHOWNORMAL);
  //ExecuteFile:='putty.exe';
  ExecuteFile:='plink.exe';

 FillChar(SEInfo, SizeOf(SEInfo), 0) ;
 SEInfo.cbSize := SizeOf(TShellExecuteInfo) ;
 with SEInfo do begin
 fMask := SEE_MASK_NOCLOSEPROCESS;
 Wnd := Application.Handle;
 lpFile := PChar(ExecuteFile) ;
{
ParamString can contain the
application parameters.
}
 lpParameters := PChar('-L 9999:192.168.42.2:80 -N pi@192.168.2.43 -pw kaas1234') ;
{
StartInString specifies the
name of the working directory.
If ommited, the current directory is used.
}
 lpDirectory := PChar('.') ;
 nShow := SW_SHOWNORMAL;
 end;
 ShellExecuteExA(@SEInfo)
 {if ShellExecuteExA(@SEInfo) then begin
 repeat
 Application.ProcessMessages;
 GetExitCodeProcess(SEInfo.hProcess, ExitCode) ;
 until (ExitCode <> STILL_ACTIVE) or
 Application.Terminated;
 ShowMessage('Calculator terminated') ;
 end
 else ShowMessage('Error starting Calc!') ;}
end;

end.

