#tag Class
Protected Class DBReportPDFPage
Inherits DBReportPDFObject
	#tag Method, Flags = &h0
		Function GetData() As String
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetMediaBox() As DBReportPDFRect
		  If MediaBox<> Nil Then
		    Return MediaBox
		  ElseIf Parent<> Nil Then
		    Return Parent.MediaBox
		  Else
		    Return Nil
		  End
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetResources() As DBReportPDFResources
		  If Resources<> Nil Then
		    Return Resources
		  ElseIf Parent<> Nil Then
		    Return Parent.Resources
		  Else
		    Return Nil
		  End
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		MediaBox As DBReportPDFRect
	#tag EndProperty

	#tag Property, Flags = &h0
		Parent As DBReportPDFPages
	#tag EndProperty

	#tag Property, Flags = &h0
		Resources As DBReportPDFResources
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
