#tag Class
Protected Class DBReportPDFInfo
Inherits DBReportPDFObject
	#tag Method, Flags = &h0
		Sub Constructor(root As DBReportPDF)
		  FileRoot= root
		  root.Objects.Append Me
		  
		  Type="Info"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetData() As String
		  Dim s, t As String
		  
		  #if TargetWin32
		    t= " - (Windows)"
		  #elseif TargetMacOS
		    t= " - (Mac OSX)"
		  #else
		    t= " - (Linux)"
		  #endif
		  
		  s= "<< "
		  If FileRoot.Title<> "" Then
		    s= s+ "/Title "+ FormatLiteralString(FileRoot.Title)
		  End
		  If FileRoot.Author<> "" Then
		    s= s+ "/Author "+ FormatLiteralString(FileRoot.Author)
		  End
		  If FileRoot.Subject<> "" Then
		    s= s+ "/Subject "+ FormatLiteralString(FileRoot.Subject)
		  End
		  If FileRoot.Keywords<> "" Then
		    s= s+ "/Keywords "+ FormatLiteralString(FileRoot.Keywords)
		  End
		  s= s+ "/CreationDate "+ FormatLiteralString(FormatDate)
		  s= s+ "/Producer "+ FormatHexString("DBReportPDF v"+ FileRoot.Version+ t)
		  If FileRoot.Creator<> "" Then
		    s= s+ "/Creator "+ FormatLiteralString(FileRoot.Creator)
		  End
		  
		  Return s+ " >> "
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private FileRoot As DBReportPDF
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
			InheritedFrom="DBReportPDFObject"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
