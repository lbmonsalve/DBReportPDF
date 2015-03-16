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


	#tag ViewBehavior
		#tag ViewProperty
			Name="EncodingID"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Offset"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="PlatformID"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			InheritedFrom="Object"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
