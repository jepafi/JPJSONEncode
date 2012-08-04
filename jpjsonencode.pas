{
JPJSON Encode

Version: 1.1

Author: JEAN PATRICK - www.jeansistemas.net - jpsoft-sac-pa@hotmail.com

Date: 2012-07-05

Licence: Free and OpenSource
}

unit jpjsonencode;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, DB;

type

  { TJPJSONEncode }

  TJPJSONEncode = class
  public
    function DataSetToJSONArray(DataSet: TDataSet; CheckedImgPath: string = 'true';
      UncheckedImgPath: string = 'false'): string;
  private
    function EscapeJSONString(sJSON: string): string;
  end;


implementation

{ TJPJSONEncode }

function TJPJSONEncode.DataSetToJSONArray(DataSet: TDataSet;
  CheckedImgPath: string; UncheckedImgPath: string): string;
var
  i: integer;
  jf: TFormatSettings;
begin
  Result := '';
  if (CheckedImgPath <> 'true') then
    CheckedImgPath := '"<img src=''' + CheckedImgPath +
      ''' style=''padding-top:3px;''></img>"';
  if (UncheckedImgPath <> 'false') then
    UncheckedImgPath := '"<img src=''' + UncheckedImgPath +
      ''' style=''padding-top:3px;''></img>"';
  with DataSet do
  begin
    if (IsEmpty) then
    begin
      Result := '[]';
      Exit;
    end;
    if not (Active) then
    begin
      try
        Open;
      except
        raise Exception.Create('JPJSONEncode error: Unable to open DataSet!');
      end;
    end;
    First;
    jf := DefaultFormatSettings;
    jf.DecimalSeparator := '.';
    jf.ThousandSeparator := ',';
    while not (EOF) do
    begin
      Result += '{';
      for i := 0 to FieldCount - 1 do
      begin
        if (i > 0) then
          Result += ',';
        Result += '"' + Fields[i].FieldName + '":';
        if Fields[i].IsNull then
          Result += 'null'
        else
        begin
          case Fields[i].DataType of
            ftSmallint, ftInteger:
            begin
              if (Fields[i].Tag > 0) then
                Result += '"' + FormatFloat(
                  StringOfChar('0', Fields[i].Tag), Fields[i].AsFloat) + '"'
              else
                Result += Fields[i].AsString;
            end;
            ftFloat:
            begin
              if (Fields[i].Tag = 1) then
                Result += '"' + FloatToStrF(Fields[i].AsFloat, ffCurrency, 14, 2) + '"'
              else if (Fields[i].Tag = 2) then
                Result += '"' + FloatToStrF(Fields[i].AsFloat, ffNumber, 14, 2) + '"'
              else
                Result += FloatToStrf(Fields[i].AsFloat, ffGeneral, 14, 2, jf);
            end;
            ftBoolean: if (Fields[i].AsBoolean) then
                Result += CheckedImgPath
              else
                Result += UncheckedImgPath;
            else
              Result += '"' + EscapeJSONString(Fields[i].AsString) + '"';
          end;
        end;
      end;
      Result += '}';
      Next;
      if not (EOF) then
        Result += ',';
    end;
  end;
  Result := '[' + Result + ']';
end;

function TJPJSONEncode.EscapeJSONString(sJSON: string): string;
var
  i, j, l: integer;
  p: PChar;
begin
  j := 1;
  Result := '';
  l := Length(sJSON) + 1;
  p := PChar(sJSON);
  for i := 1 to l do
  begin
    if (p^ in ['"', '/', '\', #8, #9, #10, #12, #13]) then
    begin
      Result += Copy(sJSON, j, i - j);
      case p^ of
        '\': Result += '\\';
        '/': Result += '\/';
        '"': Result += '\"';
        #8: Result += '\b';
        #9: Result += '\t';
        #10: Result += '\n';
        #12: Result += '\f';
        #13: Result += '\r';
      end;
      j := i + 1;
    end;
    Inc(p);
  end;
  Result += Copy(sJSON, j, i - 1);
end;

end.
