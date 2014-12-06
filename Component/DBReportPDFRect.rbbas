#tag Class
Protected Class DBReportPDFRect
Inherits REALbasic.Rect
	#tag Method, Flags = &h0
		Function DataStream() As String
		  Return "["+ str(Left)+ " "+ str(Top)+ " "+ str(Width)+ " "+ str(Height)+ "]"
		End Function
	#tag EndMethod


End Class
#tag EndClass
