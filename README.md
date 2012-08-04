JPJSON Encode
=============

Library written in pure "Free Pascal" to convert a "descending DataSet" in JSONArray to be used in "grids" jQuery.

The method "DataSetToJSONArray" converts the entire DataSet.

Usage:

	var
	  jpjson: TJPJSONEncode;
	  sJSON: String;
	begin
	  try
	    jpjson := TJPJSONEncode.Create;
	    sJSON := jpjson.DataSetToJSONArray(SQLQuery1);
	  finally
	    jpjson.Free;
	  end;
	end;


