#tag Class
Protected Class DBReportPDFXObject
Inherits DBReportPDFObject
	#tag Method, Flags = &h0
		Sub GetData()
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		MD5 As String
	#tag EndProperty

	#tag Property, Flags = &h0
		Name As String
	#tag EndProperty

	#tag Property, Flags = &h0
		PictureQuality As Integer = 80
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="ByteOffset"
			Group="Behavior"
			Type="Integer"
			InheritedFrom="DBReportPDFObject"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Generator"
			Group="Behavior"
			Type="Integer"
			InheritedFrom="DBReportPDFObject"
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
			Name="MD5"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Number"
			Group="Behavior"
			Type="Integer"
			InheritedFrom="DBReportPDFObject"
		#tag EndViewProperty
		#tag ViewProperty
			Name="PictureQuality"
			Group="Behavior"
			InitialValue="80"
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
		#tag ViewProperty
			Name="Type"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
			InheritedFrom="DBReportPDFObject"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
