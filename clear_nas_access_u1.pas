unit clear_nas_access_u1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Windows,
  ShellApi;

type

  { TForm1 }

  TForm1 = class(TForm)
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    plinkStarted : Boolean;
    SEInfo: TShellExecuteInfo;
    function PlinkStarten : Boolean;
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if plinkStarted then begin;
    TerminateProcess(SEInfo.hProcess, 1);
  end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  plinkStarted:= PlinkStarten;
end;

function TForm1.PlinkStarten: Boolean;
var
  ExitCode: DWORD;
  ExecuteFile, ParamString, StartInString: string;
begin
  // https://www.thoughtco.com/execute-and-run-applications-1058462
  ExecuteFile:='plink.exe';

  FillChar(SEInfo, SizeOf(SEInfo), 0) ;
  SEInfo.cbSize := SizeOf(TShellExecuteInfo) ;
  with SEInfo do begin
    fMask := SEE_MASK_NOCLOSEPROCESS;
    Wnd := Application.Handle;
    lpFile := PChar(ExecuteFile) ;
    lpParameters := PChar('-L 9999:192.168.42.2:80 -N pi@192.168.2.43 -pw kaas1234') ;

    lpDirectory := PChar('.') ;
    nShow := SW_HIDE;
  end;
  Result:= ShellExecuteExA(@SEInfo);
end;

end.

