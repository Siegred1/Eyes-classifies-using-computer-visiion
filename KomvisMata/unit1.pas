unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  ExtDlgs;

type
  TImageProcess = class
    type TFilter = array[-1..1, -1..1] of Integer;

    function ProcessGrayScale(Image: TImage): TPicture;
    function ProcessThreshold(Image: TImage; Threshold: Integer): TPicture;
    function ProcessBrightness(Image: TImage; Brightness: Integer): TPicture;
    function ProcessInvers(Image: TImage): TPicture;
    function ProcessContrast(Image: TImage; gCon: Double; pCon: Integer): TPicture;
    function ProcessFilter(Image: TImage; Filter: TFilter): TPicture;
    function ProcessMul(Image, Image2: TImage): TPicture;
  end;

  { TForm1 }

  TForm1 = class(TForm)
    ButtonProcessTekturIrisMata: TButton;
    ButtonProcessMaskPupil: TButton;
    ButtonLoad: TButton;
    ButtonProcessKonturBijiMata: TButton;
    ButtonProcessPupil: TButton;
    ButtonProcessKonturPupil: TButton;
    ButtonProcessMaskIris: TButton;
    ButtonProcessHasilTekturIrisMata: TButton;
    ImageMaskIrisMata: TImage;
    ImageHasilMaskIrisMata: TImage;
    ImageOriginal: TImage;
    ImageKonturBijiMata: TImage;
    ImagePupil: TImage;
    ImageKonturPupil: TImage;
    ImageMaskBijiMata: TImage;
    ImageMaskPupil: TImage;
    BijiMata: TLabel;
    KonturBijiMata: TLabel;
    TeksturIrisMata: TLabel;
    Pupil: TLabel;
    KonturPupil: TLabel;
    MaskBijiMata: TLabel;
    TeksturIris: TLabel;
    OpenPictureDialog1: TOpenPictureDialog;
    HasilTeksturIrisMata: TLabel;
    procedure ButtonLoadClick(Sender: TObject);
    procedure ButtonProcessHasilTekturIrisMataClick(Sender: TObject);
    procedure ButtonProcessKonturBijiMataClick(Sender: TObject);
    procedure ButtonProcessKonturPupilClick(Sender: TObject);
    procedure ButtonProcessMaskIrisClick(Sender: TObject);
    procedure ButtonProcessMaskPupilClick(Sender: TObject);
    procedure ButtonProcessPupilClick(Sender: TObject);
    procedure ButtonProcessTekturIrisMataClick(Sender: TObject);
  private
    ImageProcessing: TImageProcess;
    Filter: TImageProcess.TFilter;
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

uses windows;

function TImageProcess.ProcessGrayScale(Image: TImage): TPicture;
var
  X, Y: Integer;
  R, G, B, Gray: Integer;
begin
    Result := TPicture.Create;
    try
      Result.Assign(Image.Picture);

    for y := 0 to Image.Height -1 do
    begin
      for x := 0 to Image.Width -1 do
      begin
        R := getRvalue(Image.Canvas.Pixels[x,y]);
        G := getGvalue(Image.Canvas.Pixels[x,y]);
        B := getBvalue(Image.Canvas.Pixels[x,y]);

        Gray := (R+G+B) div 3;
        Gray := Min(255, Max(0, Gray));

        Result.Bitmap.Canvas.Pixels[x,y] := RGB(Gray,Gray,Gray);
      end;
    end;
    except
    Result.Free;
    raise;
    end;
end;

function TImageProcess.ProcessThreshold(Image: TImage; Threshold: Integer): TPicture;
var
  X, Y: Integer;
  R, G, B, Gray: Integer;
begin
    Result := TPicture.Create;
    try
      Result.Assign(Image.Picture);

    for y := 0 to Image.Height -1 do
    begin
      for x := 0 to Image.Width -1 do
      begin
        R := getRvalue(Image.Canvas.Pixels[x,y]);
        G := getGvalue(Image.Canvas.Pixels[x,y]);
        B := getBvalue(Image.Canvas.Pixels[x,y]);

        Gray := (R+G+B) div 3;
        Gray := Min(255, Max(0, Gray));

        if Gray <= Threshold then
        begin
          Result.Bitmap.Canvas.Pixels[X, Y] := RGB(0,0,0);
        end
        else Begin
          Result.Bitmap.Canvas.Pixels[X, Y] := RGB(255,255,255);
        end;
      end;
    end;
    except
    Result.Free;
    raise;
    end;
end;

function TImageProcess.ProcessBrightness(Image: TImage; Brightness: Integer): TPicture;
var
  X, Y: Integer;
  R, G, B: Integer;
begin
    Result := TPicture.Create;
    try
      Result.Assign(Image.Picture);

    for y := 0 to Image.Height -1 do
    begin
      for x := 0 to Image.Width -1 do
      begin
        R := getRvalue(Image.Canvas.Pixels[x,y]);
        G := getGvalue(Image.Canvas.Pixels[x,y]);
        B := getBvalue(Image.Canvas.Pixels[x,y]);

        R := Min(255, Max(0, R + Brightness));
        G := Min(255, Max(0, G + Brightness));
        B := Min(255, Max(0, B + Brightness));

        Result.Bitmap.Canvas.Pixels[x,y] := RGB(R,G,B);
      end;
    end;
    except
    Result.Free;
    raise;
    end;
end;

function TImageProcess.ProcessContrast(Image: TImage; gCon: Double; pCon: Integer): TPicture;
var
  X, Y: Integer;
  R, G, B: Integer;
Begin
    Result := TPicture.Create;
    try
      Result.Assign(Image.Picture);

    for y := 0 to Image.Height -1 do
    begin
      for x := 0 to Image.Width -1 do
      begin
        R := getRvalue(Image.Canvas.Pixels[x,y]);
        G := getGvalue(Image.Canvas.Pixels[x,y]);
        B := getBvalue(Image.Canvas.Pixels[x,y]);

        R := Min(255, Max(0, Round((R - pCon) * gCon + pCon)));
        G := Min(255, Max(0, Round((G - pCon) * gCon + pCon)));
        B := Min(255, Max(0, Round((B - pCon) * gCon + pCon)));

        Result.Bitmap.Canvas.Pixels[x,y] := RGB(R,G,B);
      end;
    end;
    except
    Result.Free;
    raise;
    end;
end;

function TImageProcess.ProcessInvers(Image: TImage): TPicture;
var
  X, Y: Integer;
  R, G, B: Integer;
begin
    Result := TPicture.Create;
    try
      Result.Assign(Image.Picture);

    for y := 0 to Image.Height -1 do
    begin
      for x := 0 to Image.Width -1 do
      begin
        R := getRvalue(Image.Canvas.Pixels[x,y]);
        G := getGvalue(Image.Canvas.Pixels[x,y]);
        B := getBvalue(Image.Canvas.Pixels[x,y]);

        R := Min(255, Max(0, 255 - R));
        G := Min(255, Max(0, 255 - G));
        B := Min(255, Max(0, 255 - B));

        Result.Bitmap.Canvas.Pixels[x,y] := RGB(R,G,B);
      end;
    end;
    except
    Result.Free;
    raise;
    end;
end;

function TImageProcess.ProcessFilter(Image: TImage; Filter: TFilter): TPicture;
var
  X, Y, ImageHeight, ImageWidth, sum: Integer;
  ImageTemp: array[0..370, 0..370] of Integer;

  M1, M2, M3, M4, M5, M6, M7, M8, M9: Integer;
begin
    Result := TPicture.Create;
    try
      // Mendapatkan tinggi dan lebar gambar
      ImageHeight := Image.Picture.Bitmap.Height -1;
      ImageWidth := Image.Picture.Bitmap.Width -1;

      Result.Assign(Image.Picture);

      // Copying edge
      // Menyalin edge atas dan bawah ke baris di atas dan di bawahnya
      for x := 0 to ImageWidth do
      begin
        ImageTemp[x+1, 0] := Image.Canvas.Pixels[x,0];
        ImageTemp[x+1, ImageHeight +2] := Image.Canvas.Pixels[x, ImageHeight];
      end;

      for y := 0 to ImageHeight do
      begin
        ImageTemp[0, y+1] := Image.Canvas.Pixels[0,y];
        ImageTemp[ImageWidth +2, y+1] := Image.Canvas.Pixels[ImageWidth, y];
      end;

      // Copying each 4 corner
      // Menyalin informasi sudut secara diagonal
      ImageTemp[0,0] := Image.Canvas.Pixels[0,0];
      ImageTemp[ImageWidth +2, 0] := Image.Canvas.Pixels[ImageWidth, 0];
      ImageTemp[Imagewidth +2, ImageHeight +2] := Image.Canvas.Pixels[ImageWidth, ImageHeight];
      ImageTemp[0, ImageHeight +2] := Image.Canvas.Pixels[1, ImageHeight];

      // Copying all image
      // Menyalin seluruh gambar dengan offset 1
      for x := 0 to ImageWidth do
      begin
        for y := 0 to ImageHeight do
        begin
          ImageTemp[x+1, Y+1] := Image.Canvas.Pixels[x,y];
        end;
      end;

      // Dilakukan konvolusi
      for x := 1 to ImageWidth -1 do
      begin
        for y := 1 to ImageHeight -1 do
        begin
          // [-1, -1] M1  [0, -1] M2  [1, -1] M3
          // [-1,  0] M4  [0,  0] M5  [1,  0] M6
          // [-1,  1] M7  [0,  1] M8  [1,  1] M9
          M1 := ImageTemp[X - 1, Y - 1];
          M2 := ImageTemp[X, Y - 1];
          M3 := ImageTemp[X + 1, Y - 1];
          M4 := ImageTemp[X - 1, Y];
          M5 := ImageTemp[X, Y];
          M6 := ImageTemp[X + 1, Y];
          M7 := ImageTemp[X - 1, Y + 1];
          M8 := ImageTemp[X, Y + 1];
          M9 := ImageTemp[X + 1, Y + 1];

          // Multiply by filter coefficients
          M1 := M1 * Filter[-1, -1];
          M2 := M2 * Filter[0, -1];
          M3 := M3 * Filter[1, -1];
          M4 := M4 * Filter[-1, 0];
          M5 := M5 * Filter[0, 0];
          M6 := M6 * Filter[1, 0];
          M7 := M7 * Filter[-1, 1];
          M8 := M8 * Filter[0, 1];
          M9 := M9 * Filter[1, 1];

          //SUM
          sum := M1+M2+M3+M4+M5+M6+M7+M8+M9;

          sum := Min(255, Max(0, sum));

          Result.Bitmap.Canvas.Pixels[x-1,y-1] := RGB(sum,sum,sum);
        end;
      end;
      except
      Result.Free;
      raise;
    end;
end;

function TImageProcess.ProcessMul(Image, Image2: TImage): TPicture;
var
  X, Y: Integer;
  R, G, B: Integer;
  R2, G2, B2: Integer;
begin
    Result := TPicture.Create;
    try
      Result.Assign(Image.Picture);

    for y := 0 to Image.Height -1 do
    begin
      for x := 0 to Image.Width -1 do
      begin
        R := getRvalue(Image.Canvas.Pixels[x,y]);
        G := getGvalue(Image.Canvas.Pixels[x,y]);
        B := getBvalue(Image.Canvas.Pixels[x,y]);

        R2 := getRvalue(Image2.Canvas.Pixels[x,y]);
        G2 := getGvalue(Image2.Canvas.Pixels[x,y]);
        B2 := getBvalue(Image2.Canvas.Pixels[x,y]);

        //R := Min(255, Max(0, R * R2));
        //G := Min(255, Max(0, G * G2));
        //B := Min(255, Max(0, B * B2));

        R := R * R2 div 255;
        G := G * R2 div 255;
        B := B * R2 div 255;
        Result.Bitmap.Canvas.Pixels[x,y] := RGB(R,G,B);
      end;
    end;
    except
    Result.Free;
    raise;
    end;
end;

{ TForm1 }

procedure TForm1.ButtonLoadClick(Sender: TObject);
begin
    if OpenPictureDialog1.Execute then
  begin
    ImageOriginal.Picture.LoadFromFile(OpenPictureDialog1.FileName);
  end;
end;

procedure TForm1.ButtonProcessKonturBijiMataClick(Sender: TObject);
begin
    ImageKonturBijiMata.Picture := ImageOriginal.Picture;
    ImageKonturBijiMata.Picture := ImageProcessing.ProcessGrayScale(ImageKonturBijiMata);
    ImageKonturBijiMata.Picture := ImageProcessing.ProcessThreshold(ImageKonturBijiMata,240);

    // Mendefinisikan filter default
    Filter[-1,-1] := 1;
    Filter[0,1] := 1;
    Filter[1,-1] := 1;
    Filter[-1,0] := 1;
    Filter[0,0] := -8;
    Filter[1,0] := 1;
    Filter[-1,1] := 1;
    Filter[0,1] := 1;
    Filter[1,1] := 1;
    ImageKonturBijiMata.Picture := ImageProcessing.ProcessFilter(ImageKonturBijiMata, Filter);
end;

procedure TForm1.ButtonProcessKonturPupilClick(Sender: TObject);
begin
    ImageKonturPupil.Picture := ImageOriginal.Picture;
    ImageKonturPupil.Picture := ImageProcessing.ProcessGrayScale(ImageKonturPupil);
    ImageKonturPupil.Picture := ImageProcessing.ProcessThreshold(ImageKonturPupil,10);

    // Mendefinisikan filter default
    Filter[-1,-1] := 1;
    Filter[0,1] := 1;
    Filter[1,-1] := 1;
    Filter[-1,0] := 1;
    Filter[0,0] := -8;
    Filter[1,0] := 1;
    Filter[-1,1] := 1;
    Filter[0,1] := 1;
    Filter[1,1] := 1;
    ImageKonturPupil.Picture := ImageProcessing.ProcessFilter(ImageKonturPupil, FIlter);
end;

procedure TForm1.ButtonProcessMaskIrisClick(Sender: TObject);
begin
    ImageMaskBijiMata.Picture := ImageOriginal.Picture;
    ImageMaskBijiMata.Picture := ImageProcessing.ProcessGrayScale(ImageMaskBijiMata);
    ImageMaskBijiMata.Picture := ImageProcessing.ProcessThreshold(ImageMaskBijiMata,240);
    ImageMaskBijiMata.Picture := ImageProcessing.ProcessInvers(ImageMaskBijiMata);
end;

procedure TForm1.ButtonProcessMaskPupilClick(Sender: TObject);
begin
    ImageMaskPupil.Picture := ImageOriginal.Picture;
    ImageMaskPupil.Picture := ImageProcessing.ProcessGrayScale(ImageMaskPupil);
    ImageMaskPupil.Picture := ImageProcessing.ProcessThreshold(ImageMaskPupil,10);
end;

procedure TForm1.ButtonProcessPupilClick(Sender: TObject);
begin
    ImagePupil.Picture := ImageOriginal.Picture;
    ImagePupil.Picture := ImageProcessing.ProcessGrayScale(ImagePupil);
    ImagePupil.Picture := ImageProcessing.ProcessThreshold(ImagePupil,10);
end;

procedure TForm1.ButtonProcessTekturIrisMataClick(Sender: TObject);
begin
    ImageMaskIrisMata.Picture := ImageOriginal.Picture;
    ImageMaskIrisMata.Picture := ImageProcessing.ProcessMul(ImageMaskBijiMata, ImageMaskPupil);
end;

procedure TForm1.ButtonProcessHasilTekturIrisMataClick(Sender: TObject);
begin
    ImageHasilMaskIrisMata.Picture := ImageOriginal.Picture;
    ImageHasilMaskIrisMata.Picture := ImageProcessing.ProcessMul(ImageOriginal, ImageMaskIrisMata);
end;

end.

