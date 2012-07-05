unit jpjsonencode;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db;

Type

  { TJPJSONEncode }

  TJPJSONEncode = Class
    public
      function DataSetToJSONString(DataSet: TDataSet): String;
      function DataSetToJSONString(DataSet: TDataSet; aFields: Array of String): String;
    private
      function EscapeJSONString(sJSON: String): String;
    end;


implementation

{ TJPJSONEncode }

function TJPJSONEncode.DataSetToJSONString(DataSet: TDataSet): String;
var
  i: Integer;
begin
  Result := '';
  if (DataSet.IsEmpty) then Exit;
  if not(DataSet.Active) then begin
    try
      DataSet.Open;
    except
      raise Exception.Create('JPJSONEncode error: Unable to open DataSet!');
    end;
  end;
  DataSet.First;
  while not(DataSet.EOF) do
  begin
    Result += '{';
    for i := 0 to DataSet.FieldCount - 1 do
    begin
      if (i > 0) then Result +=',';
      Result += '"'+DataSet.Fields[i].FieldName+'":';
      if DataSet.Fields[i].IsNull then Result += 'null' else
        begin
          case DataSet.Fields[i].DataType of
            ftSmallint,ftInteger: Result += DataSet.Fields[i].AsString;
            ftFloat: Result += FloatToStr(DataSet.Fields[i].AsFloat);
            ftBoolean: if (DataSet.Fields[i].AsBoolean) then Result += 'true' else Result += 'false';
            else
              Result += '"'+EscapeJSONString(DataSet.Fields[i].AsString)+'"';
          end;
        end;
    end;
    Result += '}';
    DataSet.Next;
    if not(DataSet.EOF) then Result += ',';
  end;
  Result := '['+Result+']';
end;

function TJPJSONEncode.DataSetToJSONString(DataSet: TDataSet;
  aFields: Array of String): String;
var
  i: Integer;
begin
  Result := '';
  if (DataSet.IsEmpty) then Exit;
  if not(DataSet.Active) then begin
    try
      DataSet.Open;
    except
      raise Exception.Create('JPJSONEncode error: Unable to open DataSet!');
    end;
  end;
  DataSet.First;
  while not(DataSet.EOF) do
  begin
    Result += '{';
    for i := 0 to Length(aFields) - 1 do
    begin
      if (i > 0) then Result +=',';
      Result += '"'+DataSet.FieldByName(aFields[i]).FieldName+'":';
      if DataSet.FieldByName(aFields[i]).IsNull then Result += 'null' else
        begin
          case DataSet.FieldByName(aFields[i]).DataType of
            ftSmallint,ftInteger: Result += DataSet.FieldByName(aFields[i]).AsString;
            ftFloat: Result += FloatToStr(DataSet.FieldByName(aFields[i]).AsFloat);
            ftBoolean: if (DataSet.FieldByName(aFields[i]).AsBoolean) then Result += 'true' else Result += 'false';
            else
              Result += '"'+EscapeJSONString(DataSet.FieldByName(aFields[i]).AsString)+'"';
          end;
        end;
    end;
    Result += '}';
    DataSet.Next;
    if not(DataSet.EOF) then Result += ',';
  end;
  Result := '['+Result+']';
end;

function TJPJSONEncode.EscapeJSONString(sJSON: String): String;
begin
  Result := StringReplace(sJSON,'\','\\',[rfReplaceAll]);
  Result := StringReplace(Result,'/','\/',[rfReplaceAll]);
  Result := StringReplace(Result,'"','\"',[rfReplaceAll]);
  Result := StringReplace(Result,#8 ,'\b',[rfReplaceAll]);
  Result := StringReplace(Result,#9 ,'\t',[rfReplaceAll]);
  Result := StringReplace(Result,#10,'\n',[rfReplaceAll]);
  Result := StringReplace(Result,#12,'\f',[rfReplaceAll]);
  Result := StringReplace(Result,#13,'\r',[rfReplaceAll]);
end;

end.

