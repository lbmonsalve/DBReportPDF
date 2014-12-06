#tag Class
Protected Class DBReportPDFFontCMAP
	#tag Method, Flags = &h0
		Sub Constructor(platformID As Integer, encodingID As Integer, offset As Integer)
		  Me.PlatformID= platformID
		  Me.EncodingID= encodingID
		  Me.Offset= offset
		  Mapping= New Dictionary
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		EncodingID As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Mapping As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h0
		Offset As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		PlatformID As Integer
	#tag EndProperty


End Class
#tag EndClass
