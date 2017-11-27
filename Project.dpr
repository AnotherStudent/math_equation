program Project;

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {formMain},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Sky');
  Application.CreateForm(TformMain, formMain);
  Application.Run;
end.
