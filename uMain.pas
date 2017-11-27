unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.pngimage, Vcl.ExtCtrls,
  Vcl.StdCtrls;

type
  TformMain = class(TForm)
    Image1: TImage;
    RadioGroupCut: TRadioGroup;
    RadioGroupMethod: TRadioGroup;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    LabelX: TLabel;
    LabelCount: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure RadioGroupMethodClick(Sender: TObject);
    procedure RadioGroupCutClick(Sender: TObject);
  private
    { Private declarations }
    procedure Calculate;
  public
    { Public declarations }
  end;

var
  formMain: TformMain;

implementation

{$R *.dfm}

uses
  Math;

const
  eps = 10e-6;

// функция
function Fx(x: Double): Double;
begin
  Result := Exp(-2*x) - 2*x + 1;
end;

// производная ф-ии
function Fxx(X: Real): Real;
begin
  Result := -2*Exp(-2*x)-2;
end;

// https://ru.wikipedia.org/wiki/Метод_бисекции
function HalfDiv(a, b: Double; var Count: Integer): Double;
var
  c: Double;
begin
  Count := 0;

  if abs(Fx(a)) < eps then
  begin
    Result := a;
    Exit;
  end;

  if abs(Fx(b)) < eps then
  begin
    Result := b;
    Exit;
  end;

  while abs(b - a) > eps do
  begin
    Count := Count + 1;

    c := a + (b - a) / 2;

    if Sign(Fx(a)) <> Sign(Fx(c)) then
      b := c
    else
      a := c;
  end;

  Result := c;
end;

// http://cyclowiki.org/wiki/Метод_хорд
function Corde(a, b: Double; var Count: Integer): Double;
var
  x: Double;
  aOld, t: Double;
begin
  Count := 0;

  if a > b then
  begin
    t := b;
    b := a;
    a := t;
  end;

  a := a - (Fx(a) * (b - a)) / (Fx(b) - Fx(a));
  repeat
    Count := Count + 1;

    aOld := a;
    a := a - (Fx(a) * (b - a)) / (Fx(b) - Fx(a));
  until not (abs(a - aOld) > eps);

  Result := a;
end;

// https://ru.wikipedia.org/wiki/Метод_Ньютона
function Newton(x0: Double; var Count: Integer): Double;
var
  oldX, x: Double;
begin
  Count := 0;

  oldX := x0;
  repeat
    Count := Count + 1;

    x := x - Fx(x) / Fxx(x);

    if abs(x - oldX) <= eps then
      break;

    oldX := x;

  until False;

  Result := x;
end;

{ TformMain }

procedure TformMain.Calculate;
var
  a, b, x: Double;
  count: Integer;

begin
  // a, b
  if RadioGroupCut.ItemIndex = 0 then
  begin
    a := -10;
    b := 10;
  end else
  begin
    a := 10;
    b := -10;
  end;

  // method
  case RadioGroupMethod.ItemIndex of
    0: x := HalfDiv(a, b, count);
    1: x := Corde(a, b, count);
    2: x := Newton(a, count);
  end;

  LabelX.Caption := x.ToString;
  LabelCount.Caption := count.ToString;
end;

procedure TformMain.FormCreate(Sender: TObject);
begin
  Calculate;
end;

procedure TformMain.RadioGroupCutClick(Sender: TObject);
begin
  Calculate;
end;

procedure TformMain.RadioGroupMethodClick(Sender: TObject);
begin
  Calculate;
  RadioGroupCut.Enabled := RadioGroupMethod.ItemIndex = 0;
end;

end.
