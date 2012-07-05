JPJSON Encode
=============

Library written in pure "Free Pascal" to convert a "descending DataSet" in JSONString to be used in "grids" jQuery.

The method "DataSetToJSONString" converts the entire DataSet or you can specify which fields should be included.

Usage:

	var
	  json: String;
	begin
	  json := DataSetToJSONString(SQLQuery1);
	end;

Or:

	var
	  json: String;
	  aFields: Array[0..1] of String = ('id', 'name');
	begin
	  json := DataSetToJSONString(SQLQuery1, aFields);
	end;
