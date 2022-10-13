unit clear_nas_access_u1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Windows,
  ShellApi;

type

  { TForm1 }

  TRaspiData = record
    host_ip,
    username,
    pw,
    nas_ip: String;
  end;

  TForm1 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    plinkStarted : Boolean;
    SEInfo: TShellExecuteInfo;
    TempDir : String;
    RaspiData : TRaspiData;
    function TrustHost : Boolean;
    function PlinkStarten : Boolean;
    procedure EntpackeRessource(NameRessource, DestFilename : String);
  public

  end;

const
  exe_plink_filename = 'plink_ct.exe';
  script_plink_filename = 'plink_script.bat';
  tunnel_port = 9999;
  nas_web_interface_port = 80;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }
uses
    LCLType;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if plinkStarted then begin;
    TerminateProcess(SEInfo.hProcess, 1);
  end;

  if FileExists(TempDir + script_plink_filename) then begin
    DeleteFile(PChar(TempDir + script_plink_filename));
  end;

  if FileExists(TempDir + exe_plink_filename) then begin
    DeleteFile(PChar(TempDir + exe_plink_filename));
  end;

end;


procedure TForm1.Button1Click(Sender: TObject);
begin
  if TrustHost then begin
    plinkStarted:= PlinkStarten;
    if plinkStarted then begin
      ShowMessage('Verbunden!');
      ShellExecute(0, 'open', PChar('127.0.0.1:' + IntToStr(tunnel_port)), nil, nil, SW_SHOWNORMAL);
    end
    else begin
      MessageDlg('Fehler beim Verbinden', 'Verbindung konnte nicht hergestellt werden!', mtError, [mbOk], 0);
    end;
  end;
end;



procedure TForm1.FormShow(Sender: TObject);
begin
  TempDir:= IncludeTrailingBackslash(GetTempDir(False));

  with RaspiData do begin
    host_ip:= '192.168.2.43';
    username:= 'pi';
    pw:= 'kaas1234';
    nas_ip:= '192.168.42.2';
  end;


  plinkStarted:= False;

  if not FileExists(TempDir + exe_plink_filename) then begin
     EntpackeRessource('PLINK', exe_plink_filename);
  end;

  if not FileExists(TempDir + script_plink_filename) then begin
     EntpackeRessource('PLINK_SCRIPT', script_plink_filename);
  end;


end;

function TForm1.TrustHost: Boolean;
var
 SEInfoTrust: TShellExecuteInfo;
 ExitCode: DWORD;
 ExecuteFile, ParamString, StartInString: string;
begin
  ExecuteFile:= TempDir + script_plink_filename;
  FillChar(SEInfoTrust, SizeOf(SEInfoTrust), 0) ;
  SEInfoTrust.cbSize := SizeOf(TShellExecuteInfo) ;
  with SEInfoTrust do begin
    fMask := SEE_MASK_NOCLOSEPROCESS;
    Wnd := Application.Handle;
    lpFile := PChar(ExecuteFile) ;
    lpParameters := PChar(RaspiData.host_ip + ' ' + RaspiData.username + ' ' +
                 RaspiData.pw) ;
    lpDirectory := PChar(TempDir) ;
    nShow := SW_Hide;
  end;
  if ShellExecuteExA(@SEInfoTrust) then begin
     repeat
       Application.ProcessMessages;
       GetExitCodeProcess(SEInfoTrust.hProcess, ExitCode) ;
     until ((ExitCode <> STILL_ACTIVE) or
       Application.Terminated);

     Result := True;
  end
  else begin
    Result := False;
  end;
end;

function TForm1.PlinkStarten: Boolean;
var
  ExecuteFile : string;
begin
  // https://www.thoughtco.com/execute-and-run-applications-1058462
  ExecuteFile:= TempDir + exe_plink_filename;

  FillChar(SEInfo, SizeOf(SEInfo), 0) ;
  SEInfo.cbSize := SizeOf(TShellExecuteInfo) ;
  with SEInfo do begin
    fMask := SEE_MASK_NOCLOSEPROCESS;
    Wnd := Application.Handle;
    lpFile := PChar(ExecuteFile) ;
    lpParameters := PChar('-L ' + IntToStr(tunnel_port) + ':' + RaspiData.nas_ip + ':' + IntToStr(nas_web_interface_port) + ' -N ' +
                 RaspiData.username +'@' + RaspiData.host_ip +' -pw ' + RaspiData.pw) ;
    lpDirectory := PChar(TempDir) ;
    nShow := SW_HIDE;
  end;
  Result:= ShellExecuteExA(@SEInfo);
end;

procedure TForm1.EntpackeRessource(NameRessource, DestFilename : String);
var
  S: TResourceStream;
  F: TFileStream;
begin
  // create a resource stream which points to our resource
  S := TResourceStream.Create(HInstance, NameRessource, RT_RCDATA);
  // Please ensure you write the enclosing apostrophes around MYDATA,
  // otherwise no data will be extracted.
  try
    // create a file mydata.dat in the application directory
    F := TFileStream.Create(TempDir + DestFilename, fmCreate);
    try
      F.CopyFrom(S, S.Size); // copy data from the resource stream to file stream
    finally
      F.Free; // destroy the file stream
    end;
  finally
    S.Free; // destroy the resource stream
  end;

end;
end.

