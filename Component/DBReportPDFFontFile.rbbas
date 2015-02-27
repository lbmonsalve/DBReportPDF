#tag Class
Protected Class DBReportPDFFontFile
Inherits DBReportPDFObject
	#tag Method, Flags = &h0
		Sub Constructor(root As DBReportPDF, file As FolderItem)
		  If root<> Nil Then
		    FileRoot= root
		    root.Objects.Append Me
		  End
		  
		  Me.FileFont= file
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetData() As String
		  #pragma BackgroundTasks false // to speed up
		  
		  Dim s, filter As String
		  Dim nLen1 As UInt64
		  
		  If FileFont.Exists Then  //TODO: seek on cache
		    Dim ReadStream as BinaryStream = BinaryStream.Open(FileFont, False)
		    nLen1= ReadStream.Length
		    s= ReadStream.Read(nLen1)
		    ReadStream.Close
		  End
		  
		  If FileRoot.Compression Then
		    filter= " /Filter /FlateDecode "
		    s= DBReportPDF.zlibCompress(s)
		  End
		  
		  Return "<< /Length "+ str(len(s))+ filter+ "/Length1 "+ Str(nLen1)+ " >> "+ "stream"+ CR+ s+ CR+ "endstream"+ CR
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		FileFont As FolderItem
	#tag EndProperty

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
			EditorType="MultiLineEditor"
			InheritedFrom="DBReportPDFObject"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
