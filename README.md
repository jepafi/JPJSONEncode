JPJSON Encode
=============

Library written in pure "Free Pascal" to convert a "descending DataSet" in JSONString to be used in "grids" jQuery.

The method "DataSetToJSONString" converts the entire DataSet or you can specify which fields should be included.

Usage:

	var
	  jpjson: TJPJSONEncode;
	  sJSON: String;
	begin
	  try
	    jpjson := TJPJSONEncode.Create;
	    sJSON := jpjson.DataSetToJSONString(SQLQuery1);
	  finally
	    jpjson.Free;
	  end;
	end;

Or:

	var
	  jpjson: TJPJSONEncode;
	  sJSON: String;
	  aFields: Array[0..1] of String = ('id', 'name');
	begin
	  try
	    jpjson := TJPJSONEncode.Create;
	    sJSON := jpjson.DataSetToJSONString(SQLQuery1, aFields);
	  finally
	    jpjson.Free;
	  end;
	end;
